import 'package:get_it/get_it.dart';

import 'next_turn_handler.dart';

void nextTurnInjector(GetIt injector) {
  injector.registerFactory<NextTurnHandler>(
    () => NextTurnHandler(
      db: injector.get(),
    ),
  );
}
