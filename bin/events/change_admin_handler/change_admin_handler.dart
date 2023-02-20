import 'package:mongo_dart/mongo_dart.dart';
import 'package:socket_io/socket_io.dart' as io;

import '../../utils/extensions.dart';

class ChangeAdminHandler {
  final Db db;

  Future<void> handle(
    io.Server server,
    io.Socket socket,
    dynamic data,
  ) async {
    try {
      final roomId = data['roomId'];
      final playerId = data['playerId'];

      if (roomId == null) {
        throw ("Not found room");
      }
      if (playerId == null) {
        throw ("Not found player");
      }
      final DbCollection rooms = db.collection('room');

      final query = {
        'roomId': roomId,
        'players.playerId': playerId,
      };

      final update =
          modify.set('players.\$.isAdmin', true).set('players.\$.index', 0);

      final result = await rooms.updateOne(query, update);

      if (result.isSuccess) {
        socket.broadcast.to(roomId).emit("changeAdmin", {
          "playerId": playerId,
        });
        socket.emit("changeAdminSuccess", {});
      } else {
        socket.error(result.errmsg ?? "Something went wrong!");
      }
    } catch (e) {
      socket.emitError(e.toString());
    }
  }

  ChangeAdminHandler({
    required this.db,
  });
}
