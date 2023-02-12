import 'package:mongo_dart/mongo_dart.dart';
import 'package:socket_io/socket_io.dart';

class OnLobbyChangeHandler {
  final Db db;

  OnLobbyChangeHandler({
    required this.db,
  });

  Future<void> handle(Socket socket) async {
    final room = db.collection("room");
    final romDBO = await room.find(where.sortBy('dateTime')).toList();
    socket.broadcast.emit("joinToLobbySuccess", romDBO);
  }
}
