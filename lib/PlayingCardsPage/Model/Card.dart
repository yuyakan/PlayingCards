class Card {
  static const int _TOTAL_OF_ONE_MARK = 13;
  static const String _DIAMOND = "D";
  static const String _HEART = "H";
  static const String _CLUB = "K";
  static const String _SPADE = "S";
  static const String _JOKER = "JOKER";
  final int id;

  const Card(this.id);

  String mark() {
    switch ((id ~/ _TOTAL_OF_ONE_MARK) + 1) {
      case 1:
        return _DIAMOND;
      case 2:
        return _HEART;
      case 3:
        return _CLUB;
      case 4:
        return _SPADE;
      case 5:
        return _JOKER;
    }
    throw Error();
  }

  int number() {
    return id % _TOTAL_OF_ONE_MARK + 1;
  }
}
