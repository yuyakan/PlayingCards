import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'CardsDeckProvider.g.dart';

@riverpod
class CardsDeck extends _$CardsDeck {
  static const int _TOTAL_NUMBER = 52;
  static const List<int> _JOKERS = [52, 53];

  @override
  List<int> build() {
    var _cards = List.generate(_TOTAL_NUMBER, (i) => i);
    _cards.shuffle();
    return _cards;
  }

  void reset() {
    state = List.generate(_TOTAL_NUMBER, (i) => i);
  }

  void insertJoker(bool isUsedJoker) {
    if (isUsedJoker) {
      state = [...state, ..._JOKERS];
    }
    state.shuffle();
  }

  int drow() {
    return state.removeLast();
  }

  bool isEmpty() {
    return state.isEmpty;
  }

  void stackOnTop(int card) {
    state = [...state, card];
  }
}
