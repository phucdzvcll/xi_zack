
import '../common/poker_card.dart';

class Player {
  final String? name;
  final String? id;
  final int? timeToJoin;
  final List<PokerCard> cardIds = [];
  final String? socketId;
  bool inMatch = false;
  bool isAdminer = false;
  int pet = 0;

  Player({
    this.name,
    this.id,
    this.timeToJoin,
    this.socketId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['id'] = id;
    data['timeLogin'] = timeToJoin;
    data['socketId'] = socketId;
    data['isMatch'] = inMatch;
    data['isAdminer'] = isAdminer;
    data['pet'] = pet;
    return data;
  }
}
