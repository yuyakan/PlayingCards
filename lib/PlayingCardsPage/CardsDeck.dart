class CardsDeck {
  var _cards;

  CardsDeck(bool hasJoker) {
    _cards =
        hasJoker ? List.generate(54, (i) => i) : List.generate(52, (i) => i);
    _cards.shuffle();
  }

  bool isEmpty() {
    return _cards.isEmpty;
  }

  int drow() {
    return _cards.removeLast();
  }

  void stackOnTop(int card) {
    _cards.add(card);
  }
}
