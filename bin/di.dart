import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:mysql1/mysql1.dart';

import 'events/change_admin_handler/di.dart';
import 'events/create_room/di.dart';
import 'events/disconnect_handler/di.dart';
import 'events/game_handler/next_turn/di.dart';
import 'events/game_handler/pet_handler/di.dart';
import 'events/game_handler/pull_card/di.dart';
import 'events/game_handler/start_game/di.dart';
import 'events/join_room/di.dart';
import 'events/join_to_lobby/di.dart';
import 'events/leave_room/di.dart';
import 'events/on_lobby_change/di.dart';

Future<void> appDI(GetIt injector) async {
  injector.registerLazySingleton<Uuid>(() => Uuid());

  String host =
      Platform.environment['MONGO_DART_DRIVER_HOST'] ?? '35.240.138.79';
  // String port = Platform.environment['MONGO_DART_DRIVER_PORT'] ?? '27017';
  // String userName =
  //     Platform.environment['MONGO_INITDB_ROOT_USERNAME'] ?? 'root';
  // String password =
  //     Platform.environment['MONGO_INITDB_ROOT_PASSWORD'] ?? 'example';
  final db = Db("mongodb://35.240.138.79:27017/xi_dach");
  await db.open();
  Map<String, String> envVars = Platform.environment;

  var sqlPort = int.parse(envVars['MYSQL_PORT'] ?? '3306');
  var dbPassword = envVars['MYSQL_PASS'] ?? '1';
  var dbName = envVars['MYSQL_DB_NAME'] ?? 'mydb';
  var dbUser = envVars['MYSQL_USER'] ?? 'root';
  final settings = ConnectionSettings(
    port: sqlPort,
    password: dbPassword,
    db: dbName,
    user: dbUser,
    host: host,
  );
  MySqlConnection connection = await MySqlConnection.connect(settings);

  injector.registerLazySingleton(() => connection);

  injector.registerSingleton<Db>(db);
  onLobbyChangeDi(injector);
  joinToLobbyDi(injector);
  createRoomDi(injector);
  joinRoomDi(injector);
  disconnectHandlerDi(injector);
  leaveRoomDi(injector);
  onChangeAdminDi(injector);
  startNewGameInjector(injector);
  petInjector(injector);
  pullCardInjector(injector);
  nextTurnInjector(injector);
}
