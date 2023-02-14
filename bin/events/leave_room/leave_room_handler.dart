import 'package:mongo_dart/mongo_dart.dart';
import 'package:socket_io/socket_io.dart';

class LeaveRoomHandler {
  final Db db;

  const LeaveRoomHandler({
    required this.db,
  });

  Future<void> handle(
      Server server, Socket client, Map<String, dynamic> data) async {
    final String? roomId = data["roomId"];
    final String? playerId = data["playerId"];
    final bool? isAdmin = data["isAdmin"];
    var collection = db.collection("room");
    if (roomId != null) {
      var selector = {};
      var update = {
        '\$pull': {
          'players': {'socketId': client.id}
        }
      };
      var query = {'roomId': roomId};
      Map<String, dynamic>? result = await collection.findOne(query);
      if (result != null && playerId != null) {
        await collection.update(selector, update);
        client.broadcast.to(roomId).emit('userLeave', {
          "socketId": client.id,
          "playerId": playerId,
          "isAdmin": isAdmin ?? false,
        });
        client.leave(roomId, null);
      }
    }
  }
}
