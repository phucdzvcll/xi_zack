import 'package:get_it/get_it.dart';

import 'join_room_handler.dart';

void joinRoomDi(GetIt injector) {
  injector.registerFactory<JoinRoomHandler>(
    () => JoinRoomHandler(
      db: injector.get(),
    ),
  );
}
