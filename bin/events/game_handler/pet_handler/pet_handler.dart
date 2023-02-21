import 'package:mongo_dart/mongo_dart.dart';
import 'package:socket_io/socket_io.dart' as io;

import '../../../utils/extensions.dart';

class PetHandler {
  final Db db;

  Future<void> handle(
    io.Server server,
    io.Socket socket,
    dynamic data,
  ) async {
    try {
      final rooms = db.collection("room");
      String? roomId = data['roomId'];
      String? playerId = data['playerId'];
      int? pet = data['pet'];

      if (roomId == null) {
        throw ("Room not found");
      }
      if (playerId == null) {
        throw ("Player not found");
      }
      if (pet == null) {
        throw ("pet not found");
      }

      final query = {
        'roomId': roomId,
        'players.playerId': playerId,
      };

      final update = modify.set('players.\$.pet', pet);

      final result = await rooms.updateOne(query, update);

      if (result.isSuccess) {
        server.to(roomId).emit("playerPet", {
          "playerId": playerId,
          "pet": pet,
        });
      } else {
        socket.error(result.errmsg ?? "Something went wrong!");
      }
    } catch (e) {
      socket.emitError(e.toString());
    }
  }

  PetHandler({
    required this.db,
  });
}
