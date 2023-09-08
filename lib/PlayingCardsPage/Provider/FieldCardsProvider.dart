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
    var mark = "D";
    switch ((state.last ~/ 13) + 1) {
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
    var number = state.last % 13 + 1;
    return "img/cards/$mark$number.png";
  }
}
