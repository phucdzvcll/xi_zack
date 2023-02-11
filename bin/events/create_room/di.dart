import 'package:get_it/get_it.dart';

import 'create_room_handler.dart';

void createRoomDi(GetIt injector) {
  injector.registerFactory<CreateRoomHandler>(
    () => CreateRoomHandler(
      db: injector.get(),
      uuid: injector.get(),
      joinToLobbyHandler: injector.get(),
    ),
  );
}
