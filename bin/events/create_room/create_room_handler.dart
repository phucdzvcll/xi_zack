import 'package:mongo_dart/mongo_dart.dart';
import 'package:socket_io/socket_io.dart';

import 'room_model.dart';

class CreateRoomHandler {
  final Db db;
  final Uuid uuid;

  CreateRoomHandler({
    required this.db,
    required this.uuid,
  });

  Future<void> createRoom(
      Server server, Socket socket, Map<String, dynamic> data) async {
    final Room room = Room.fromJson(data);

    //create a roomId with uuid v4
    var roomId = uuid.v4();
    server.sockets.rooms.add(roomId);
    //join to room after created a room
    socket.join(roomId);
    //save room to db
    final roomColl = db.collection("room");
    var roomCreated = {
      "roomId": roomId,
      "roomName": room.roomName,
      "dateTime": DateTime.now().millisecondsSinceEpoch
    };
    roomColl.insertOne(roomCreated);

    //emit mess notify create room success to client
    socket.emit("createRoomSuccess", roomCreated);

    //re-get all room and emit to players
    final romDBO = await roomColl.find(where.sortBy('dateTime')).toList();
    server.emit("newRoomCreated", romDBO);
  }
}
