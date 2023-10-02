import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'TimesOfBackProvider.g.dart';

@riverpod
class TimesOfBack extends _$TimesOfBack {
  static const _INITIAL_VALUE = 0;
  @override
  int build() {
    return _INITIAL_VALUE;
  }

  void reset() {
    state = _INITIAL_VALUE;
  }

  void add() {
    state++;
  }

  void subtract() {
    if (state != _INITIAL_VALUE) {
      state--;
    }
  }
}
