import 'package:flutter/material.dart';
import 'package:minecraft_server_status/data/service/server_status_service.dart';
import 'package:minecraft_server_status/domain/model/server_status_model.dart';
import 'package:minecraft_server_status/infra/constants/image_constants.dart';
import 'package:minecraft_server_status/presentation/designSytem/button/mc_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late var _serverStatusFuture = _getServerStatus();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstants.backgroundPattern),
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(
                top: 40.0,
                bottom: 20.0,
              ),
              child: Text(
                "Server List",
                style: TextStyle(
                  fontFamily: "Minecraft-ui",
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.black.withOpacity(0.6),
                child: FutureBuilder<ServerStatusModel>(
                  future: _serverStatusFuture,
                  builder: (contex, snap) {
                    final server = snap.data;
                    if (snap.connectionState == ConnectionState.done &&
                        snap.hasData &&
                        server != null) {
                      return ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return ListTile(
                            // leading: Image.network(server.favicon),
                            title: const Text(
                              "Name here",
                              style: TextStyle(
                                fontFamily: "Minecraft-ui",
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            subtitle: Text(
                              server.serverName,
                              style: const TextStyle(
                                fontFamily: "Minecraft-ui",
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            trailing: Text(
                              "${server.currentPlayers}/${server.maxPlayers} - ${server.ping.inMilliseconds}ms",
                              style: const TextStyle(
                                fontFamily: "Minecraft-ui",
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          );
                        },
                      );
                    }
                    if (snap.connectionState == ConnectionState.waiting &&
                        (snap.hasError || server == null)) {
                      return const Center(
                        child: Text(
                          "Could not connect to server",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 16.0,
                children: [
                  McButton(text: "Refresh", onPressed: _refresh),
                  McButton(text: "Add Server", onPressed: () {}),
                  const McButton(
                    text: "Delete",
                  ),
                  const McButton(
                    text: "Edit",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _refresh() {
    _setServerStatusFuture();
  }

  void _setServerStatusFuture() {
    setState(() {
      _serverStatusFuture = _getServerStatus();
    });
  }

  Future<ServerStatusModel> _getServerStatus() {
    return const ServerStatusService().connect(ip: "24.144.82.12");
  }
}
