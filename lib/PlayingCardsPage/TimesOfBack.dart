class TimesOfBack {
  int _number = 0;

  bool isZero() {
    return _number == 0;
  }

  void add() {
    _number += 1;
  }

  void subtract() {
    if (_number != 0) {
      _number -= 1;
    }
  }
}
