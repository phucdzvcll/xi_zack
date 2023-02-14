import 'package:get_it/get_it.dart';

import 'on_lobby_change_handler.dart';

void onLobbyChangeDi(GetIt injector) {
  injector.registerFactory<OnLobbyChangeHandler>(
    () => OnLobbyChangeHandler(
      db: injector.get(),
    ),
  );
}
