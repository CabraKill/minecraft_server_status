import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:minecraft_server_status/domain/model/server_status_model.dart';

class ServerStatusService {
  const ServerStatusService();

  Future<ServerStatusModel> connect({
    required String ip,
    int port = 25565,
  }) async {
    final startTime = DateTime.now();
    final socket = await Socket.connect(
      ip,
      port,
      timeout: const Duration(seconds: 10),
    );
    final endTime = DateTime.now();
    socket.add(Uint8List.fromList([0xFE, 0x01]));
    final firstData = await socket.asBroadcastStream().first;
    socket.close();
    return _getStatusFromBytes(firstData, endTime.difference(startTime));
  }

  ServerStatusModel _getStatusFromBytes(
    Uint8List data,
    Duration duration,
  ) {
    final serverInfo = String.fromCharCodes(data).split("\x00\x00\x00");
    final dataDecoded = ServerStatusModel(
      version: serverInfo[2].replaceAll("\x00", ""),
      serverName: serverInfo[3].replaceAll("\x00", ""),
      currentPlayers: int.parse(serverInfo[4].replaceAll("\x00", "")),
      maxPlayers: int.parse(serverInfo[5].replaceAll("\x00", "")),
      ping: duration,
    );

    return dataDecoded;
  }
}
