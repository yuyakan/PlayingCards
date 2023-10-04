import 'package:high_and_low/PlayingCardsPage/Model/CardsDeck/CardsDeckProvider.dart';
import 'package:high_and_low/PlayingCardsPage/Model/FieldsCards/FieldCardsProvider.dart';
import 'package:high_and_low/PlayingCardsPage/Model/GameState/GameStateProvider.dart';
import 'package:high_and_low/PlayingCardsPage/Model/TimesOfBack/TimesOfBackProvider.dart';
import 'package:high_and_low/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class GameViewOperation {
  void reset() {}
  void flip() {}
  void back() {}
  void settingJoker(bool isUsedJoker) {}
}

class GameAction implements GameViewOperation {
  final WidgetRef _ref;
  GameAction(this._ref);

  //山札を準備し直す. Game時の設定もジョーカーの有無に合わせてリセットする.
  void reset() {
    _resetCards();
    _resetGameState();
  }

  void _resetCards() {
    _ref.read(fieldCardsProvider.notifier).reset();
    _ref.read(cardsDeckProvider.notifier).reset();
    _ref.read(cardImageProvider.notifier).state = EMPTY_CARD;
    _ref
        .read(cardsDeckProvider.notifier)
        .insertJoker(_ref.read(isUsedJokerProvider.notifier).state);
  }

  void _resetGameState() {
    _ref.read(timesOfBackProvider.notifier).reset();
    _ref.read(isVisibleBackButtonProvider.notifier).state = false;
    _ref.read(isVisibleOpenButtonProvider.notifier).state = true;
  }

  //山札からカードをめくる.
  void flip() {
    _subtractBackTimes();
    _putCardOnField();
    _updateGameState();
  }

  void _subtractBackTimes() {
    _ref.read(timesOfBackProvider.notifier).subtract();
  }

  void _putCardOnDeck() {
    _ref
        .read(cardsDeckProvider.notifier)
        .stackOnTop(_ref.read(fieldCardsProvider.notifier).removeTop());
  }

  void _updateGameState() {
    _ref.read(cardImageProvider.notifier).state =
        _ref.read(fieldCardsProvider.notifier).topCard();
    _ref.read(isVisibleOpenButtonProvider.notifier).state =
        !_ref.read(cardsDeckProvider).isEmpty;
    _ref.read(isVisibleBackButtonProvider.notifier).state =
        !_ref.read(fieldCardsProvider).isEmpty;
  }

  //場のカードを一枚戻す.
  void back() {
    _addBackTimes();
    _putCardOnDeck();
    _updateGameState();
  }

  void _addBackTimes() {
    _ref.read(timesOfBackProvider.notifier).add();
  }

  void _putCardOnField() {
    _ref
        .read(fieldCardsProvider.notifier)
        .add(_ref.read(cardsDeckProvider.notifier).drow());
  }

  //ジョーカーの有無を設定する.
  void settingJoker(bool isUsedJoker) {
    _ref.read(isUsedJokerProvider.notifier).state = isUsedJoker;
  }
}
