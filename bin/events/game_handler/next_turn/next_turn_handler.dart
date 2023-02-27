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

        int currentIndex = currentPlayer.index ?? -1;

        List<PlayerDetail> indexMoreThan = players
            .where((element) => (element.index ?? -1) > (currentIndex))
            .toList();
        if (indexMoreThan.isNotEmpty) {
          PlayerDetail playerDetail = indexMoreThan.reduce((PlayerDetail value,
                  PlayerDetail element) =>
              (value.index ?? -1) < (element.index ?? -1) ? value : element);
          server.to(roomId).emit(
                "nextTurn",
                playerDetail.toJson(),
              );
        } else {
          socket.emitError("Player Not Found");
        }
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
