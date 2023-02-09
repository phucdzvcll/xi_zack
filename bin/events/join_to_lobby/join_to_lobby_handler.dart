import 'package:mongo_dart/mongo_dart.dart';
import 'package:socket_io/socket_io.dart';

class JoinToLobbyHandler {
  final Db db;

  JoinToLobbyHandler({
    required this.db,
  });

  Future<void> joinToLobby(
      Server io, Socket client, Map<String, dynamic> data) async {

    final room = db.collection("room");
    final romDBO = await room.find(where.sortBy('dateTime')).toList();
    client.emit("joinToLobbySuccess", romDBO);
  }
}
