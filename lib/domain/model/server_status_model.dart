import 'package:equatable/equatable.dart';

class ServerStatusModel extends Equatable {
  final String version;
  final String serverName;
  final int currentPlayers;
  final int maxPlayers;
  final Duration ping;

  const ServerStatusModel({
    required this.version,
    required this.serverName,
    required this.currentPlayers,
    required this.maxPlayers,
    required this.ping,
  });

  @override
  List<Object?> get props => [
        version,
        serverName,
        currentPlayers,
        maxPlayers,
        ping,
      ];
}
