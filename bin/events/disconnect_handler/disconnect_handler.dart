import 'package:mongo_dart/mongo_dart.dart';
import 'package:socket_io/socket_io.dart';

class DisconnectHandler {
  final Db db;

  DisconnectHandler({
    required this.db,
  });

  Future<void> handler(Server server, Socket client) async {
    var collection = db.collection("room");
    final Map<String, dynamic>? room =
        await _getCurrentRoom(client, collection);

    if (room != null) {
      var selector = {};
      var update = {
        '\$pull': {
          'players': {'socketId': client.id}
        }
      };

      final player = room['players']
          .firstWhere((p) => p['socketId'] == client.id, orElse: () => null);

      await collection.update(selector, update);
      server.to(room['roomId']).emit(
            'userLeave',
            player,
          );
      client.leave(room['roomId'], null);
      final emptyFilter = where
          .eq('roomId', room['roomId'])
          .and(where.eq('players', []).or(where.eq('players', null)));
      await collection.deleteOne(emptyFilter);
    }
  }

  Future<Map<String, dynamic>?> _getCurrentRoom(
      Socket client, DbCollection collection) async {
    var selectorRoom = {
      'players': {
        '\$elemMatch': {"socketId": client.id}
      }
    };
    return collection.findOne(selectorRoom);
  }
}
