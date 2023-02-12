import 'package:mongo_dart/mongo_dart.dart';
import 'package:socket_io/socket_io.dart';

import '../join_to_lobby/join_to_lobby_handler.dart';
import 'room_param.dart';

class CreateRoomHandler {
  final Db db;
  final Uuid uuid;
  final JoinToLobbyHandler joinToLobbyHandler;

  CreateRoomHandler({
    required this.db,
    required this.uuid,
    required this.joinToLobbyHandler,
  });

  Future<void> createRoom(
      Server server, Socket socket, Map<String, dynamic> data) async {
    final RoomParam room = RoomParam.fromJson(data);
    var roomId = uuid.v4();
    final roomColl = db.collection("room");
    var roomCreated = {
      "roomId": roomId,
      "roomName": room.roomName,
      "dateTime": DateTime.now().millisecondsSinceEpoch,
      "players": [
        {
          'socketId': socket.id,
          'playerId': room.playerId,
        }
      ]
    };
    await roomColl.insertOne(roomCreated);
    server.sockets.rooms.add(roomId);
    socket.emit("createRoomSuccess", {
      "roomId": roomId,
    });
  }
}
