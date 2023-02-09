enum PokerCard {
  spaceA,
  space2,
  space3,
  space4,
  space5,
  space6,
  space7,
  space8,
  space9,
  space10,
  spaceJ,
  spaceQ,
  spaceK,
  clubA,
  club2,
  club3,
  club4,
  club5,
  club6,
  club7,
  club8,
  club9,
  club10,
  clubJ,
  clubQ,
  clubK,
  diamondA,
  diamond2,
  diamond3,
  diamond4,
  diamond5,
  diamond6,
  diamond7,
  diamond8,
  diamond9,
  diamond10,
  diamondJ,
  diamondQ,
  diamondK,
  heartA,
  heart2,
  heart3,
  heart4,
  heart5,
  heart6,
  heart7,
  heart8,
  heart9,
  heart10,
  heartJ,
  heartQ,
  heartK,
}

int _getAValue(int cardAmount, int currentValue) {
  if (cardAmount < 4) {
    if (currentValue > 12) {
      return 1;
    } else if (currentValue + 11 > 21) {
      return 10;
    } else {
      return 11;
    }
  } else {
    return 1;
  }
}

int getCardValue({
  required PokerCard cardId,
  required int cardAmount,
  required int currentValue,
}) {
  switch (cardId) {
    case PokerCard.spaceA:
    case PokerCard.diamondA:
    case PokerCard.heartA:
    case PokerCard.clubA:
      return _getAValue(cardAmount, currentValue);
    case PokerCard.space2:
    case PokerCard.space3:
    case PokerCard.space4:
    case PokerCard.space5:
    case PokerCard.space6:
    case PokerCard.space7:
    case PokerCard.space8:
    case PokerCard.space9:
    case PokerCard.space10:
    case PokerCard.club2:
    case PokerCard.club3:
    case PokerCard.club4:
    case PokerCard.club5:
    case PokerCard.club6:
    case PokerCard.club7:
    case PokerCard.club8:
    case PokerCard.club9:
    case PokerCard.club10:
    case PokerCard.diamond2:
    case PokerCard.diamond3:
    case PokerCard.diamond4:
    case PokerCard.diamond5:
    case PokerCard.diamond6:
    case PokerCard.diamond7:
    case PokerCard.diamond8:
    case PokerCard.diamond9:
    case PokerCard.diamond10:
    case PokerCard.heart2:
    case PokerCard.heart3:
    case PokerCard.heart4:
    case PokerCard.heart5:
    case PokerCard.heart6:
    case PokerCard.heart7:
    case PokerCard.heart8:
    case PokerCard.heart9:
    case PokerCard.heart10:
      var aStr = cardId.name.replaceAll(RegExp(r'[^0-9]'), '');
      return int.parse(aStr);
    case PokerCard.spaceJ:
    case PokerCard.spaceQ:
    case PokerCard.spaceK:
    case PokerCard.clubJ:
    case PokerCard.clubQ:
    case PokerCard.clubK:
    case PokerCard.diamondJ:
    case PokerCard.diamondQ:
    case PokerCard.diamondK:
    case PokerCard.heartJ:
    case PokerCard.heartQ:
    case PokerCard.heartK:
      return 10;
  }
}
