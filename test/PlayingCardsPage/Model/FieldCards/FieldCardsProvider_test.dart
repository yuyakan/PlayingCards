import 'package:flutter_test/flutter_test.dart';
import 'package:high_and_low/PlayingCardsPage/Model/Card.dart';
import 'package:high_and_low/PlayingCardsPage/Model/FieldsCards/FieldCardsProvider.dart';
import 'package:high_and_low/constants.dart';
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
      fieldCardsProvider,
      listener.call,
      fireImmediately: true,
    );

    //initial state
    expect(container.read(fieldCardsProvider), []);

    //reset
    container.read(fieldCardsProvider.notifier).add(1);
    expect(container.read(fieldCardsProvider), [1]);
    container.read(fieldCardsProvider.notifier).reset();
    expect(container.read(fieldCardsProvider), []);
  });

  test('add', () {
    final container = ProviderContainer();
    final listener = Listener();

    addTearDown(container.dispose);

    container.listen<List<int>>(
      fieldCardsProvider,
      listener.call,
      fireImmediately: true,
    );

    //initial state
    expect(container.read(fieldCardsProvider), []);

    //add 1
    container.read(fieldCardsProvider.notifier).add(1);
    expect(container.read(fieldCardsProvider), [1]);
  });

  test('remove top', () {
    final container = ProviderContainer();
    final listener = Listener();

    addTearDown(container.dispose);

    container.listen<List<int>>(
      fieldCardsProvider,
      listener.call,
      fireImmediately: true,
    );

    container.read(fieldCardsProvider.notifier).add(1);
    container.read(fieldCardsProvider.notifier).add(2);
    expect(container.read(fieldCardsProvider.notifier).removeTop(), 2);
    expect(container.read(fieldCardsProvider.notifier).removeTop(), 1);
    expect(() => container.read(fieldCardsProvider.notifier).removeTop(),
        throwsA(TypeMatcher<Error>()));
  });

  test('is Empty', () {
    final container = ProviderContainer();
    final listener = Listener();

    addTearDown(container.dispose);

    container.listen<List<int>>(
      fieldCardsProvider,
      listener.call,
      fireImmediately: true,
    );

    expect(container.read(fieldCardsProvider.notifier).isEmpty(), true);

    container.read(fieldCardsProvider.notifier).add(1);
    expect(container.read(fieldCardsProvider.notifier).isEmpty(), false);
  });

  test('top Card', () {
    final container = ProviderContainer();
    final listener = Listener();

    addTearDown(container.dispose);

    container.listen<List<int>>(
      fieldCardsProvider,
      listener.call,
      fireImmediately: true,
    );

    expect(container.read(fieldCardsProvider.notifier).topCard(), EMPTY_CARD);

    container.read(fieldCardsProvider.notifier).add(1);
    Card card = Card(1);
    expect(container.read(fieldCardsProvider.notifier).topCard(),
        "img/cards/${card.mark()}${card.number()}.png");
  });
}
