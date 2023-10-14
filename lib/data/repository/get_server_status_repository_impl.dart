import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:minecraft_server_status/domain/model/server_status_model.dart';
import 'package:minecraft_server_status/domain/repository/get_server_status_repository.dart';
import 'package:logger/logger.dart';

class GetServerStatusRepositoryImpl implements GetServerStatusRepository {
  @override
  Future<ServerStatusModel> call({required String ip, int port = 25565}) async {
    final startTime = DateTime.now();
    final socket = await Socket.connect(
      ip,
      port,
      timeout: const Duration(seconds: 10),
    );
    final endTime = DateTime.now();
    var broadCast = socket.asBroadcastStream();
    //TODO remove
    final listen = broadCast.listen((event) {
      print("listening: " + String.fromCharCodes(event));
    });
    Uint8List bytesToSend = Uint8List.fromList([0x00]);
    bytesToSend = Uint8List.fromList(
        bytesToSend + (Uint8List.fromList([0xff, 0xff, 0xff, 0xff, 0x0f])));
    //send uint8list of ip length
    bytesToSend = Uint8List.fromList(bytesToSend + _getVarInt(ip.length));
    bytesToSend = Uint8List.fromList(bytesToSend + utf8.encode(ip));

    // ByteData data = ByteData(2);
    // data.setUint16(0, port, Endian.big);
    // Uint8List portShort = data.buffer.asUint8List();
    var a = (port & 0xFF00) >> 8;
    var b = (port & 0x00FF);
    final portShort = Uint8List.fromList([a, b]);

    bytesToSend =
        Uint8List.fromList(bytesToSend + portShort); //send port as a short
    bytesToSend =
        Uint8List.fromList(bytesToSend + (Uint8List.fromList([0x01])));
    bytesToSend =
        (Uint8List.fromList(_getVarInt(bytesToSend.length) + bytesToSend));
    //transform the list to bytes and send it
    print(bytesToSend.toString().replaceAll(',', ''));
    socket.add(bytesToSend);
    socket.add(Uint8List.fromList([0x01, 0x00]));

    final first = await broadCast.first;
    // await Future.delayed(const Duration(seconds: 5));
    // await listen.cancel();
    socket.close();
    var status = _getJsonStatusFromBytes(first, endTime.difference(startTime));

    return status;
  }

  List<int> _getVarInt(int paramInt) {
    final List<int> arrayOfByte = [];
    while ((paramInt & -128) != 0) {
      arrayOfByte.add(paramInt & 0x7F | 0x80);
      paramInt = paramInt >> 7;
    }
    arrayOfByte.add(paramInt);
    return arrayOfByte;
  }

  ServerStatusModel _getJsonStatusFromBytes(
    Uint8List data,
    Duration duration,
  ) {
    final fromCharCodes = String.fromCharCodes(data);
    final indexOfFirst = fromCharCodes.indexOf("{");
    final payload = fromCharCodes.substring(indexOfFirst);
    //TODO fix description with extras
    final json = jsonDecode(payload);
    _print(json.toString());
    final dataDecoded = ServerStatusModel.fromJson(
      json..['ping'] = duration,
    );

    return dataDecoded;
  }

  void _print(String message) {
    var logger = Logger(
      printer: PrettyPrinter(
          methodCount: 2, // Number of method calls to be displayed
          errorMethodCount:
              8, // Number of method calls if stacktrace is provided
          lineLength: 120, // Width of the output
          colors: true, // Colorful log messages
          printEmojis: true, // Print an emoji for each log message
          printTime: false // Should each log print contain a timestamp
          ),
    );
    logger.i(message);
  }

  ServerStatusModel _getStatusFromBytes(
    Uint8List data,
    Duration duration,
  ) {
    final fromCharCodes = String.fromCharCodes(data);
    final serverInfo = fromCharCodes.split("\x00\x00\x00");
    final dataDecoded = ServerStatusModel(
      version: serverInfo[2].replaceAll("\x00", ""),
      description: serverInfo[3].replaceAll("\x00", ""),
      currentPlayers: int.parse(serverInfo[4].replaceAll("\x00", "")),
      maxPlayers: int.parse(serverInfo[5].replaceAll("\x00", "")),
      playerList: const [],
      ping: duration,
    );

    return dataDecoded;
  }
}
