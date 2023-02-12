import 'package:mongo_dart/mongo_dart.dart';
import 'package:mysql1/mysql1.dart';
import 'package:socket_io/socket_io.dart';
import '../join_to_lobby/join_to_lobby_handler.dart';
import 'join_room_param.dart';
import 'model/player.dart';

class JoinRoomHandler {
  final Db db;
  final MySqlConnection sqlConnection;
  final JoinToLobbyHandler joinToLobbyHandler;

  JoinRoomHandler({
    required this.db,
    required this.joinToLobbyHandler,
    required this.sqlConnection,
  });

  Future<void> joinRoom(
      Server server, Socket socket, Map<String, dynamic> data) async {
    final JoinRoomParam roomParam = JoinRoomParam.fromJson(data);
    var collection = db.collection("room");
    var query = {'roomId': roomParam.roomId};
    print(query);
    var result = await collection.findOne(query);
    if (result != null && roomParam.socketId != null) {
      PlayerInRoom player = PlayerInRoom(
          socketId: roomParam.socketId ?? "",
          playerId: roomParam.playerId ?? "",
          isAdmin: false);
      var update;
      if (result['players'] != null) {
        update = {
          '\$push': {
            'players': player.toJson(),
          }
        };
      } else {
        player = PlayerInRoom(
            playerId: player.playerId,
            socketId: roomParam.socketId ?? socket.id,
            isAdmin: true);
        update = {
          '\$set': {
            "players": [
              player.toJson(),
            ]
          }
        };
      }
      await collection.update(result, update);
      List<PlayerInRoom> players = [];
      if (result['players'] != null) {
        final List<PlayerInRoom> s = (result['players'] as List)
            .map((e) => PlayerInRoom.fromJson(e))
            .toList();
        players.addAll(s);
      }

      players.add(player);

      socket.emit("joinRoomSuccess", players.map((e) => e.toJson()).toList());
      socket.join(roomParam.roomId);
      socket.broadcast.emit("newPlayerJoined", player.toJson());
    } else {
      socket.emit("socketError", {"mess": "room error"});
    }
  }
}
