import 'package:get_it/get_it.dart';

import 'leave_room_handler.dart';

void leaveRoomDi(GetIt injector) {
  injector.registerFactory<LeaveRoomHandler>(
      () => LeaveRoomHandler(db: injector.get()));
}
