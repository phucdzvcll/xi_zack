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

      if (playerId != null) {
        await collection.update(selector, update);
        client.broadcast.to(roomId).emit('userLeave', {
          "socketId": client.id,
          "playerId": playerId,
          "isAdmin": isAdmin ?? false,
        });
        final filter = where.eq('roomId', roomId).eq(
              'admin.playerId',
              playerId,
            );

        final updateAdmin = modify.set('admin', null);

        await collection.updateOne(filter, updateAdmin);

        client.leave(roomId, null);
      }

      final emptyFilter = where
          .eq('roomId', roomId)
          .and(where.eq('players', []).or(where.eq('players', null)));
      final emptyDoc = await collection.findOne(emptyFilter);
      if (emptyDoc != null) {
        await collection.deleteOne(emptyFilter);
      }
    }
  }
}
