import 'package:mongo_dart/mongo_dart.dart';
import 'package:socket_io/socket_io.dart';

class DisconnectHandler {
  final Db db;

  DisconnectHandler({
    required this.db,
  });

  Future<void> handler(Server server, Socket client) async {
    var collection = db.collection("room");
    var selector = {};
    var update = {
      '\$pull': {
        'players': {'socketId': client.id}
      }
    };
    final rooms = await _getCurrentRoom(client, collection);

    for (Map<String, dynamic> element in rooms) {
      try {
        final socketId = client.id;
        final player = element['players']
            .firstWhere((p) => p['socketId'] == socketId, orElse: () => null);

        print(player);
        server.to(element['roomId']).emit(
              'userLeave',
              player,
            ); // {playerId: 1, socketId: a1bfedd0ac4e11eda39ab7a704ed848c, isAdmin: false}
        client.leave(element['roomId'], null);
      } catch (e) {
        print(e);
      }
    }

    await collection.update(selector, update);
  }

  Future<List<Map<String, dynamic>>> _getCurrentRoom(
      Socket client, DbCollection collection) async {
    var selectorRoom = {
      'players': {
        '\$elemMatch': {"socketId": client.id}
      }
    };
    return await collection.find(selectorRoom).toList();
  }
}
