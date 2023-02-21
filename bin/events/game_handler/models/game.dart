import 'package:equatable/equatable.dart';

import '../../../common/object_parse_ext.dart';
import '../../../common/poker_card.dart';
import 'package:enum_to_string/enum_to_string.dart';

class Game extends Equatable {
  final String? gameId;
  final String? roomId;
  final List<PlayerDetail>? playerDetail;

  Game({
    this.gameId,
    this.roomId,
    this.playerDetail,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      gameId: json.parseString('gameId'),
      roomId: json.parseString('roomId'),
      playerDetail: json.parseListObject('playerDetail', PlayerDetail.fromJson),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['gameId'] = gameId;
    data['roomId'] = roomId;
    if (playerDetail != null) {
      data['playerDetail'] = playerDetail?.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List<Object?> get props => [
        gameId,
        roomId,
        playerDetail,
      ];
}

class PlayerDetail extends Equatable {
  final String? playerId;
  final String? socketId;
  final int? index;
  final List<PokerCard> cards;

  PlayerDetail({
    this.playerId,
    this.socketId,
    this.index,
    this.cards = const [],
  });

  factory PlayerDetail.fromJson(Map<String, dynamic> json) {
    List<PokerCard?> fromList = EnumToString.fromList<PokerCard?>(
        PokerCard.values,
        (json.parseListString('cards', defaultValue: '') ?? []));
    return PlayerDetail(
      playerId: json.parseString('playerId'),
      socketId: json.parseString('socketId'),
      index: json.parseInt('index'),
      cards: List<PokerCard>.from(fromList.where((e) => e != null).toList()),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['playerId'] = playerId;
    data['socketId'] = socketId;
    data['index'] = index;
    data['cards'] = cards.map((e) => e.name).toList();
    return data;
  }

  @override
  List<Object?> get props => [
        playerId,
        socketId,
        index,
        cards,
      ];
}
