import 'package:get_it/get_it.dart';
import 'package:socket_io/socket_io.dart';

import 'di.dart';
import 'events/create_room/create_room_handler.dart';
import 'events/join_to_lobby/join_to_lobby_handler.dart';

final getIt = GetIt.instance;

void main(List<String> args) async {
  await _systemInit(getIt);
}

Future<void> _systemInit(GetIt injector) async {
  await appDI(injector);
  Server server = Server();
  server.on("connection", (socket) {
    socket.on("joinToLobby", (data) {
      getIt.get<JoinToLobbyHandler>().joinToLobby(server, socket, data);
    });

    socket.on("createRoom",(data){
      getIt.get<CreateRoomHandler>().createRoom(server, socket, data);
    });
  });
  server.listen(8082);
}
