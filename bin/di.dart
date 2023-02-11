import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'events/create_room/di.dart';
import 'events/join_to_lobby/di.dart';

Future<void> appDI(GetIt injector) async {
  injector.registerLazySingleton<Uuid>(() => Uuid());

  String host = Platform.environment['MONGO_DART_DRIVER_HOST'] ?? '127.0.0.1';
  String port = Platform.environment['MONGO_DART_DRIVER_PORT'] ?? '27017';
  // String userName =
  //     Platform.environment['MONGO_INITDB_ROOT_USERNAME'] ?? 'root';
  // String password =
  //     Platform.environment['MONGO_INITDB_ROOT_PASSWORD'] ?? 'example';
  Db db = Db("mongodb://$host:$port/xi_dach");
  await db.open();
  injector.registerLazySingleton<Db>(() => db);
  joinToLobbyDi(injector);
  createRoomDi(injector);
}
