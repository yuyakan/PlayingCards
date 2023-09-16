import 'package:high_and_low/PlayingCardsPage/Card.dart';
import 'package:high_and_low/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'FieldCardsProvider.g.dart';

@riverpod
class FieldCards extends _$FieldCards {
  @override
  List<int> build() {
    return [];
  }

  void reset() {
    state = [];
  }

  void add(int card) {
    state = [...state, card];
  }

  int removeTop() {
    return state.removeLast();
  }

  bool isEmpty() {
    return state.isEmpty;
  }

  String topCard() {
    if (state.isEmpty) {
      return EMPTY_CARD;
    }
    Card card = Card(state.last);
    return "img/cards/${card.mark()}${card.number()}.png";
  }
}
