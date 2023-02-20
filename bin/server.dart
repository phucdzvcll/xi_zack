import 'package:get_it/get_it.dart';
import 'package:socket_io/socket_io.dart' as IO;

import 'di.dart';
import 'events/change_admin_handler/change_admin_handler.dart';
import 'events/create_room/create_room_handler.dart';
import 'events/disconnect_handler/disconnect_handler.dart';
import 'events/join_room/join_room_handler.dart';
import 'events/join_to_lobby/join_to_lobby_handler.dart';
import 'events/leave_room/leave_room_handler.dart';
import 'events/on_lobby_change/on_lobby_change_handler.dart';

final getIt = GetIt.instance;

void main(List<String> args) async {
  await _systemInit(getIt);
}

Future<void> _systemInit(GetIt injector) async {
  await appDI(injector);
  var server = IO.Server();
  server.on("connection", (socket) async {
    socket.on("joinToLobby", (data) async {
      final joinToLobbyHandler = getIt.get<JoinToLobbyHandler>();

      await joinToLobbyHandler.joinToLobby(server, socket, data);
    });

    socket.on("createRoom", (data) async {
      final onLobbyChangeHandler = getIt.get<OnLobbyChangeHandler>();
      final createRoomHandler = getIt.get<CreateRoomHandler>();

      await createRoomHandler.createRoom(server, socket, data);
      await onLobbyChangeHandler.handle(socket, server);
    });

    socket.on("joinRoom", (data) async {
      final onLobbyChangeHandler = getIt.get<OnLobbyChangeHandler>();
      final joinRoomHandler = getIt.get<JoinRoomHandler>();

      await joinRoomHandler.joinRoom(server, socket, data);
      await onLobbyChangeHandler.handle(socket, server);
    });

    socket.on("disconnect", (data) async {
      final onLobbyChangeHandler = getIt.get<OnLobbyChangeHandler>();
      final disconnectHandler = getIt.get<DisconnectHandler>();

      await disconnectHandler.handler(server, socket);
      await onLobbyChangeHandler.handle(socket, server);
    });

    socket.on("leaveRoom", (data) async {
      final leaveRoomHandler = getIt.get<LeaveRoomHandler>();

      final onLobbyChangeHandler = getIt.get<OnLobbyChangeHandler>();
      await leaveRoomHandler.handle(server, socket, data);
      await onLobbyChangeHandler.handle(socket, server);
    });

    socket.on("changeAdmin", (data) async {
      await getIt.get<ChangeAdminHandler>().handle(server, socket, data);
    });

    socket.on("playerReady", (data) {
      String? roomId = data['roomId'];
      String? playerId = data['playerId'];
      if (roomId != null && playerId != null) {
        server.to(roomId).emit("playerReady", {
          'playerId': playerId,
        });
      }
    });

    socket.on("playerCancelReady", (data) {
      String? roomId = data['roomId'];
      String? playerId = data['playerId'];
      if (roomId != null && playerId != null) {
        server.to(roomId).emit("playerCancelReady", {
          'playerId': playerId,
        });
      }
    });
  });
  server.listen(8082);
}
