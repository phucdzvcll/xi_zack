import 'package:get_it/get_it.dart';

import 'change_admin_handler.dart';

void onChangeAdminDi(GetIt injector) {
  injector.registerFactory<ChangeAdminHandler>(
    () => ChangeAdminHandler(
      db: injector.get(),
    ),
  );
}
