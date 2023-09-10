import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'CardsDeckProvider.g.dart';

@riverpod
class CardsDeck extends _$CardsDeck {
  @override
  List<int> build() {
    var _cards = List.generate(52, (i) => i);
    _cards.shuffle();
    return _cards;
  }

  void reset() {
    state = List.generate(52, (i) => i);
  }

  void insertJoker(bool isUsedJoker) {
    if (isUsedJoker) {
      state = [...state, 52, 53];
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
