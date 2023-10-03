import 'package:flutter_test/flutter_test.dart';
import 'package:high_and_low/PlayingCardsPage/Model/CardsDeck/CardsDeckProvider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

class Listener extends Mock {
  void call(List<int>? previous, List<int> value);
}

void main() {
  test('reset', () {
    final container = ProviderContainer();
    final listener = Listener();

    addTearDown(container.dispose);

    container.listen<List<int>>(
      cardsDeckProvider,
      listener.call,
      fireImmediately: true,
    );

    //initial state
    expect(container.read(cardsDeckProvider).length, 52);

    //after reset
    container.read(cardsDeckProvider.notifier).reset();
    expect(container.read(cardsDeckProvider), List.generate(52, (i) => i));
  });

  test('insert joker', () {
    final container = ProviderContainer();
    final listener = Listener();

    addTearDown(() {
      container.dispose;
    });

    container.listen<List<int>>(
      cardsDeckProvider,
      listener.call,
      fireImmediately: true,
    );

    //joker flag is true
    container.read(cardsDeckProvider.notifier).insertJoker(true);
    expect(container.read(cardsDeckProvider).length, 54);

    //joker flag is false
    container.read(cardsDeckProvider.notifier).reset();
    container.read(cardsDeckProvider.notifier).insertJoker(false);
    expect(container.read(cardsDeckProvider).length, 52);
  });

  test('drow', () {
    final container = ProviderContainer();
    final listener = Listener();

    addTearDown(() {
      container.dispose;
    });

    container.listen<List<int>>(
      cardsDeckProvider,
      listener.call,
      fireImmediately: true,
    );

    //drow a card
    container.read(cardsDeckProvider.notifier).drow();
    expect(container.read(cardsDeckProvider).length, 51);

    //drow all cards
    container.read(cardsDeckProvider.notifier).reset();
    for (int i = 0; i < 52; i++) {
      container.read(cardsDeckProvider.notifier).drow();
    }
    expect(() => container.read(cardsDeckProvider.notifier).drow(),
        throwsA(TypeMatcher<Error>()));
  });

  test('isEmpty', () {
    final container = ProviderContainer();
    final listener = Listener();

    addTearDown(() {
      container.dispose;
    });

    container.listen<List<int>>(
      cardsDeckProvider,
      listener.call,
      fireImmediately: true,
    );

    expect(container.read(cardsDeckProvider.notifier).isEmpty(), false);

    for (int i = 0; i < 52; i++) {
      container.read(cardsDeckProvider.notifier).drow();
    }
    expect(container.read(cardsDeckProvider.notifier).isEmpty(), true);
  });

  test('stack on top', () {
    final container = ProviderContainer();
    final listener = Listener();

    addTearDown(() {
      container.dispose;
    });

    container.listen<List<int>>(
      cardsDeckProvider,
      listener.call,
      fireImmediately: true,
    );

    container.read(cardsDeckProvider.notifier).drow();
    expect(container.read(cardsDeckProvider).length, 51);
    container.read(cardsDeckProvider.notifier).stackOnTop(1);
    expect(container.read(cardsDeckProvider).length, 52);
  });
}
