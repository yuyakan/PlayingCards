import 'package:flutter_test/flutter_test.dart';
import 'package:high_and_low/PlayingCardsPage/Model/TimesOfBack/TimesOfBackProvider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

class Listener extends Mock {
  void call(int? previous, int value);
}

void main() {
  test('add, subtract reset', () {
    final container = ProviderContainer();
    final listener = Listener();

    addTearDown(container.dispose);

    container.listen<int>(
      timesOfBackProvider,
      listener.call,
      fireImmediately: true,
    );

    // initial state
    expect(container.read(timesOfBackProvider), 0);

    // add
    container.read(timesOfBackProvider.notifier).add();
    container.read(timesOfBackProvider.notifier).add();
    expect(container.read(timesOfBackProvider), 2);

    // subtract
    container.read(timesOfBackProvider.notifier).subtract();
    expect(container.read(timesOfBackProvider), 1);
    container.read(timesOfBackProvider.notifier).subtract();
    container.read(timesOfBackProvider.notifier).subtract();
    container.read(timesOfBackProvider.notifier).subtract();
    expect(container.read(timesOfBackProvider), 0);

    // reset
    container.read(timesOfBackProvider.notifier).add();
    container.read(timesOfBackProvider.notifier).reset();
    expect(container.read(timesOfBackProvider), 0);
  });
}
