import 'package:mongo_dart/mongo_dart.dart';
import 'package:socket_io/socket_io.dart' as io;

import '../../../utils/extensions.dart';
import '../models/game.dart';

class NextTurnHandler {
  final Db db;

  Future<void> handle(
    io.Server server,
    io.Socket socket,
    dynamic data,
  ) async {
    try {
      final gameCollection = db.collection("game");
      String? playerId = data['playerId'];
      if (playerId == null) {
        throw ("Player not found");
      }
      var roomId = data['roomId'];
      if (roomId == null) {
        throw ("Room Not Found");
      }
      var gameId = data['gameId'];

      if (gameId == null) {
        throw ("Game Not Found");
      }
      Map<String, dynamic>? json =
          await gameCollection.findOne({"gameId": gameId, "roomId": roomId});
      if (json != null) {
        final Game game = Game.fromJson(json);
        List<PlayerDetail> players = game.playerDetail ?? [];

        PlayerDetail currentPlayer =
            players.firstWhere((p) => p.playerId == playerId);

        PlayerDetail minPlayer = players
            .where((p) => (p.index ?? 0) < (currentPlayer.index ?? 0))
            .reduce((a, b) => (a.index ?? 0) < (b.index ?? 0) ? a : b);
        server.to(roomId).emit(
              "nextTurn",
              minPlayer.toJson(),
            );
      } else {
        socket.emitError("Game Not Found");
      }
    } catch (e) {
      socket.emitError(e.toString());
    }
  }

  NextTurnHandler({
    required this.db,
  });
}
