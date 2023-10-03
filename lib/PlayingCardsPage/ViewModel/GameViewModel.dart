import 'package:high_and_low/PlayingCardsPage/Model/GameOperation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GameViewModel {
  final GameOperation _gameOperation;

  GameViewModel(WidgetRef ref) : _gameOperation = GameOperation(ref);

  void reset() {
    _gameOperation.reset();
  }

  void openAndNext() {
    _gameOperation.flip();
  }

  void back() {
    _gameOperation.back();
  }

  void jokerTogle(bool isUsedJoker) {
    _gameOperation.settingJoker(isUsedJoker);
    _gameOperation.reset();
  }
}
