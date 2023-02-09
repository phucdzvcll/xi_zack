import 'package:get_it/get_it.dart';

import 'join_to_lobby_handler.dart';

void joinToLobbyDi(GetIt injector) {
  injector.registerFactory<JoinToLobbyHandler>(() => JoinToLobbyHandler(db: injector.get()));
}
