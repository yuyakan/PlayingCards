class FieldCards {
  var _cards = [];

  void add(int card) {
    _cards.add(card);
  }

  bool isEmpty() {
    return _cards.isEmpty;
  }

  int removeTop() {
    return _cards.removeLast();
  }

  String topCard() {
    if (_cards.isEmpty) {
      return "white_card.png";
    }
    var mark = "D";
    switch ((_cards.last ~/ 13) + 1) {
      case 1:
        mark = "D";
        break;
      case 2:
        mark = "H";
        break;
      case 3:
        mark = "K";
        break;
      case 4:
        mark = "S";
        break;
      case 5:
        mark = "JOKER";
        break;
    }
    var number = _cards.last % 13 + 1;
    return "$mark$number.png";
  }
}
