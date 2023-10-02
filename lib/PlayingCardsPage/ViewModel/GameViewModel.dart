import 'package:high_and_low/Ad/ShowAdProvider/ShowAdByBackProvider.dart';
import 'package:high_and_low/Ad/ShowAdProvider/ShowAdByResetProvider.dart';
import 'package:high_and_low/PlayingCardsPage/Model/GameOperation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GameViewModel {
  final GameOperation _gameOperation;
  final ShowAdByReset _showAdByResetNotifier;
  final ShowAdByBack _showAdByBackNotifier;

  GameViewModel(WidgetRef ref)
      : _gameOperation = GameOperation(ref),
        _showAdByResetNotifier = ref.watch(showAdByResetProvider.notifier),
        _showAdByBackNotifier = ref.watch(showAdByBackProvider.notifier);

  void reset() {
    _gameOperation.reset();
    _showAdByResetNotifier.showAdByReset();
  }

  void openAndNext() {
    _gameOperation.flip();
  }

  void back() {
    _gameOperation.back();
    _showAdByBackNotifier.showAdByBack();
  }

  void jokerTogle(bool isUsedJoker) {
    _gameOperation.settingJoker(isUsedJoker);
    _gameOperation.reset();
    _showAdByResetNotifier.showAdByReset();
  }
}
