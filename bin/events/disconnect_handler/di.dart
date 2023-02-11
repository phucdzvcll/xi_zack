import 'package:get_it/get_it.dart';

import 'disconnect_handler.dart';

void disconnectHandlerDi(GetIt injector) {
  injector.registerFactory(() => DisconnectHandler(db: injector.get()));
}
