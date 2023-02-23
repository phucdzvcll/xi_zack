import 'package:mongo_dart/mongo_dart.dart';
import 'package:socket_io/socket_io.dart' as io;

import '../../../common/poker_card.dart';
import '../../../utils/extensions.dart';
import '../models/game.dart';

class PullCardHandler {
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
      final query = where
          .eq('roomId', roomId)
          .eq("gameId", gameId)
          .eq("playerDetail.playerId", playerId);

      final query1 = where.eq('roomId', roomId).eq("gameId", gameId);
      Map<String, dynamic>? json = await gameCollection.findOne(query);
      if (json != null) {
        final Game game = Game.fromJson(json);
        List<PlayerDetail> players = game.playerDetail ?? [];

        PlayerDetail currentPlayer =
            players.firstWhere((p) => p.playerId == playerId);
        List<PokerCard> cards = game.currentCards ?? [];
        PokerCard pokerCard = cards.removeLast();
        currentPlayer.cards.add(pokerCard);

        final result = await gameCollection.updateOne({
          'gameId': gameId,
          'roomId': roomId,
          'playerDetail.playerId': playerId
        }, {
          r'$pull': {'currentCars': pokerCard.name},
          r'$push': {'playerDetail.\$.cards': pokerCard.name}
        });

        if (result.isSuccess) {
          server.to(roomId).emit(
            "cardPull",
            {
              "playerId": playerId,
              "card": pokerCard.name,
            },
          );
        } else {
          socket.emitError("Something went wrong!");
        }
      } else {
        socket.emitError("Game Not Found");
      }
    } catch (e) {
      socket.emitError(e.toString());
    }
  }

  PullCardHandler({
    required this.db,
  });
}
