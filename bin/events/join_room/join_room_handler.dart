import 'package:mongo_dart/mongo_dart.dart';
import 'package:socket_io/socket_io.dart';
import '../join_to_lobby/join_to_lobby_handler.dart';
import 'join_room_param.dart';

class JoinRoomHandler {
  final Db db;
  final JoinToLobbyHandler joinToLobbyHandler;

  JoinRoomHandler({
    required this.db,
    required this.joinToLobbyHandler,
  });

  Future<void> joinRoom(
      Server server, Socket socket, Map<String, dynamic> data) async {
    final JoinRoomParam roomParam = JoinRoomParam.fromJson(data);
    var collection = db.collection("room");
    var query = {'roomId': roomParam.roomId};
    print(query);
    var result = await collection.findOne(query);
    if (roomParam.socketId != null) {
      var update;
      if (result != null && result['players'] != null) {
        update = {
          '\$push': {
            'players': {
              "socketId": roomParam.socketId,
              "playerId": roomParam.playerId,
            }
          }
        };
      } else {
        update = {
          '\$set': {
            "players": [
              {
                "socketId": roomParam.socketId,
                "playerId": roomParam.playerId,
              }
            ]
          }
        };
      }
      await collection.update(result, update);
    }
  }
}
