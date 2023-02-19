import 'package:mongo_dart/mongo_dart.dart';
import 'package:mysql1/mysql1.dart';
import 'package:socket_io/socket_io.dart';
import '../../utils/extensions.dart';
import 'join_room_param.dart';
import 'model/player.dart';

class JoinRoomHandler {
  final Db db;
  final MySqlConnection sqlConnection;

  JoinRoomHandler({
    required this.db,
    required this.sqlConnection,
  });

  Future<void> joinRoom(
      Server server, Socket socket, Map<String, dynamic> data) async {
    final JoinRoomParam roomParam = JoinRoomParam.fromJson(data);
    var collection = db.collection("room");
    var query = {'roomId': roomParam.roomId};
    var result = await collection.findOne(query);
    PlayerInRoom player;
    if (result != null) {
      var update;
      if (result['players'] != null) {
        player = PlayerInRoom(
          socketId: roomParam.socketId ?? socket.id,
          playerId: roomParam.playerId ?? "",
        );
        update = {
          '\$push': {
            'players': player.toJson(),
          }
        };
      } else {
        player = PlayerInRoom(
          socketId: roomParam.socketId ?? socket.id,
          playerId: roomParam.playerId ?? "",
          isAdmin: true,
        );
        update = {
          '\$set': {
            "players": [
              player.toJson(),
            ]
          }
        };
      }
      await collection.update(result, update);

      final filter = where.eq('roomId', roomParam.roomId);

      final cursor = await collection.findOne(filter);

      List<PlayerInRoom> players = (((cursor ?? {})["players"] ?? []) as List)
          .map((e) => PlayerInRoom.fromJson(e))
          .toList();
      socket.emit("joinRoomSuccess", players.map((e) => e.toJson()).toList());
      socket.join(roomParam.roomId);
      socket.broadcast
          .to(roomParam.roomId ?? "")
          .emit("newPlayerJoined", player.toJson());
    } else {
      socket.emitError("room error");
    }
  }
}
