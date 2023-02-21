import 'package:get_it/get_it.dart';

import '../start_game/start_new_game_handler.dart';

void startNewGameInjector(GetIt injector) {
  injector.registerFactory<StartNewGameHandler>(
    () => StartNewGameHandler(
      db: injector.get(),
      uuid: injector.get(),
    ),
  );
}
