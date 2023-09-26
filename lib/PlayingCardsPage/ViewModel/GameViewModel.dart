import 'package:high_and_low/PlayingCardsPage/Provider/CardsDeckProvider.dart';
import 'package:high_and_low/PlayingCardsPage/Provider/FieldCardsProvider.dart';
import 'package:high_and_low/PlayingCardsPage/Provider/GameStateProvider.dart';
import 'package:high_and_low/PlayingCardsPage/Provider/TimesOfBackProvider.dart';
import 'package:high_and_low/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GameViewModel {
  final WidgetRef _ref;
  GameViewModel(this._ref);

  void reset() {
    _resetCards();
    _resetGameState();
  }

  void flip() {
    _subtractBackTimes();
    _putCardOnField();
    _updateGameState();
  }

  void back() {
    _addBackTimes();
    _putCardOnDeck();
    _updateGameState();
  }

  void insertJoker(bool isUsedJoker) {
    _ref.read(isUsedJokerProvider.notifier).state = isUsedJoker;
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

  void _updateGameState() {
    _ref.read(cardImageProvider.notifier).state =
        _ref.read(fieldCardsProvider.notifier).topCard();
    _ref.read(isVisibleOpenButtonProvider.notifier).state =
        !_ref.read(cardsDeckProvider).isEmpty;
    _ref.read(isVisibleBackButtonProvider.notifier).state =
        !_ref.read(fieldCardsProvider).isEmpty;
  }

  void _subtractBackTimes() {
    _ref.read(timesOfBackProvider.notifier).subtract();
  }

  void _addBackTimes() {
    _ref.read(timesOfBackProvider.notifier).add();
  }

  void _putCardOnField() {
    _ref
        .read(fieldCardsProvider.notifier)
        .add(_ref.read(cardsDeckProvider.notifier).drow());
  }

  void _putCardOnDeck() {
    _ref
        .read(cardsDeckProvider.notifier)
        .stackOnTop(_ref.read(fieldCardsProvider.notifier).removeTop());
  }
}
