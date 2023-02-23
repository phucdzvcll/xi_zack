import 'package:get_it/get_it.dart';

import 'pull_card_handler.dart';

void pullCardInjector(GetIt injector) {
  injector.registerFactory<PullCardHandler>(
    () => PullCardHandler(
      db: injector.get(),
    ),
  );
}
