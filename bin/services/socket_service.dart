import 'package:socket_io/socket_io.dart';

import '../events/create_room/create_room_handler.dart';
import '../events/join_to_lobby/join_to_lobby_handler.dart';

class SocketService {
  final Server server;
  final JoinToLobbyHandler joinToLobbyHandler;
  final CreateRoomHandler createRoomHandler;

  const SocketService({
    required this.server,
    required this.joinToLobbyHandler,
    required this.createRoomHandler,
  });

  void init() {
    server.on("connection", (socket) {
      try {
        socket as Socket;

        socket.on("jonToLobby", (data) {
          joinToLobbyHandler.joinToLobby(server, socket, data);
        });

        socket.on("createNewRoom", (data) {
          createRoomHandler.createRoom(server, socket, data);
        });
      } catch (e) {
        socket.emit({
          "error": e.toString(),
        });
      }
    });
    server.listen(8082);
  }
}
