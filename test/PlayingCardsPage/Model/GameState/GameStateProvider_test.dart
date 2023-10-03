import 'package:flutter_test/flutter_test.dart';
import 'package:high_and_low/PlayingCardsPage/Model/GameState/GameStateProvider.dart';
import 'package:high_and_low/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

class CardImageListener extends Mock {
  void call(String? previous, String value);
}

class IsUsedJokerListner extends Mock {
  void call(bool? previous, bool value);
}

class IsVisibleBackButtonListner extends Mock {
  void call(bool? previous, bool value);
}

class IsVisibleOpenButtonListner extends Mock {
  void call(bool? previous, bool value);
}

void main() {
  test('card image', () {
    final container = ProviderContainer();
    final listener = CardImageListener();

    addTearDown(container.dispose);

    container.listen<String>(
      cardImageProvider,
      listener.call,
      fireImmediately: true,
    );

    expect(container.read(cardImageProvider), EMPTY_CARD);

    container.read(cardImageProvider.notifier).state = "test";
    expect(container.read(cardImageProvider), "test");
  });

  test('is used joker', () {
    final container = ProviderContainer();
    final listener = IsUsedJokerListner();

    addTearDown(container.dispose);

    container.listen<bool>(
      isUsedJokerProvider,
      listener.call,
      fireImmediately: true,
    );

    expect(container.read(isUsedJokerProvider), false);

    container.read(isUsedJokerProvider.notifier).state = true;
    expect(container.read(isUsedJokerProvider), true);
  });

  test('is visible back button', () {
    final container = ProviderContainer();
    final listener = IsVisibleBackButtonListner();

    addTearDown(container.dispose);

    container.listen<bool>(
      isVisibleBackButtonProvider,
      listener.call,
      fireImmediately: true,
    );

    expect(container.read(isVisibleBackButtonProvider), false);

    container.read(isVisibleBackButtonProvider.notifier).state = true;
    expect(container.read(isVisibleBackButtonProvider), true);
  });

  test('is visible open button', () {
    final container = ProviderContainer();
    final listener = IsVisibleOpenButtonListner();

    addTearDown(container.dispose);

    container.listen<bool>(
      isVisibleOpenButtonProvider,
      listener.call,
      fireImmediately: true,
    );

    expect(container.read(isVisibleOpenButtonProvider), true);

    container.read(isVisibleOpenButtonProvider.notifier).state = false;
    expect(container.read(isVisibleOpenButtonProvider), false);
  });
}
