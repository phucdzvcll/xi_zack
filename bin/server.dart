import 'package:get_it/get_it.dart';
import 'package:socket_io/socket_io.dart' as IO;

import 'di.dart';
import 'events/create_room/create_room_handler.dart';
import 'events/disconnect_handler/disconnect_handler.dart';
import 'events/join_room/join_room_handler.dart';
import 'events/join_to_lobby/join_to_lobby_handler.dart';
import 'events/on_lobby_change/on_lobby_change_handler.dart';

final getIt = GetIt.instance;

void main(List<String> args) async {
  await _systemInit(getIt);
}

Future<void> _systemInit(GetIt injector) async {
  await appDI(injector);
  var server = IO.Server();
  server.on("connection", (socket) {
    socket.on("joinToLobby", (data) async {
      await getIt.get<JoinToLobbyHandler>().joinToLobby(server, socket, data);
    });

    socket.on("createRoom", (data) async {
      await getIt.get<CreateRoomHandler>().createRoom(server, socket, data);
      await getIt.get<OnLobbyChangeHandler>().handle(socket);
    });

    socket.on("joinRoom", (data) async {
      await getIt.get<JoinRoomHandler>().joinRoom(server, socket, data);
      await getIt.get<OnLobbyChangeHandler>().handle(socket);
    });

    socket.on("disconnect", (data) async {
      await getIt.get<DisconnectHandler>().handler(server, socket);
      await getIt.get<OnLobbyChangeHandler>().handle(socket);
    });
  });
  server.listen(8082);
}
