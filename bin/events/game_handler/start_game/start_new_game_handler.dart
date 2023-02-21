import 'package:mongo_dart/mongo_dart.dart';
import 'package:socket_io/socket_io.dart' as io;

import '../../../common/poker_card.dart';
import '../../../utils/extensions.dart';
import '../models/game.dart';

class StartNewGameHandler {
  final Db db;
  final Uuid uuid;

  Future<void> handle(
    io.Server server,
    io.Socket socket,
    dynamic data,
  ) async {
    try {
      final List<PokerCard> pokerCards = List<PokerCard>.from(PokerCard.values)
        ..shuffle();
      final String? roomId = data['roomId'];
      if (roomId == null) {
        throw "room not found";
      }
      final gameCollection = db.collection("game");
      final roomCollection = db.collection("room");

      final room = await roomCollection.findOne({'roomId': roomId});

      if (room != null) {
        List<PlayerDetail> playerDetails = ((room['players'] ?? []) as List)
            .map((e) => PlayerDetail.fromJson(e))
            .toList();

        for (var element in playerDetails) {
          final PokerCard pokerCard = pokerCards.removeAt(0);
          element.cards.add(pokerCard);
        }
        for (var element in playerDetails) {
          final PokerCard pokerCard = pokerCards.removeAt(0);
          element.cards.add(pokerCard);
        }

        Game newGame = Game(
          gameId: uuid.v4(),
          roomId: roomId,
          playerDetail: playerDetails,
        );
        await gameCollection.insertOne(newGame.toJson());

        server.to(roomId).emit("newGame", newGame.toJson());
      } else {
        throw "room not found";
      }
    } catch (e) {
      socket.emitError(e.toString());
    }
  }

  StartNewGameHandler({
    required this.db,
    required this.uuid,
  });
}
