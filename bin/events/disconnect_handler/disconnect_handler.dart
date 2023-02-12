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
    final room = await _getCurrentRoom(client, collection);
    List<String> roomIds = room.map((e) => e['roomId'] as String).toList();
    for (String element in roomIds) {
      client.leave(element, (data) {
        client.broadcast.to(element).emit('userLeave', {"socketId": client.id});
      });
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
