import 'package:get_it/get_it.dart';

import 'pet_handler.dart';

void petInjector(GetIt injector) {
  injector.registerFactory<PetHandler>(
    () => PetHandler(
      db: injector.get(),
    ),
  );
}
