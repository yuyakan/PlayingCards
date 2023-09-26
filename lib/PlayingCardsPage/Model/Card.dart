class Card {
  final int id;

  const Card(this.id);

  String mark() {
    switch ((id ~/ 13) + 1) {
      case 1:
        return "D";
      case 2:
        return "H";
      case 3:
        return "K";
      case 4:
        return "S";
      case 5:
        return "JOKER";
    }
    throw Error();
  }

  int number() {
    return id % 13 + 1;
  }
}
