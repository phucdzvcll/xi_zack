import 'package:mongo_dart/mongo_dart.dart';
import 'package:socket_io/socket_io.dart' as io;

class OnLobbyChangeHandler {
  final Db db;

  OnLobbyChangeHandler({
    required this.db,
  });

  Future<void> handle(
    io.Socket socket,
    io.Server server,
  ) async {
    final room = db.collection("room");
    final romDBO = await room.find(where.sortBy('dateTime')).toList();
    server.emit("joinToLobbySuccess", romDBO);
  }
}
