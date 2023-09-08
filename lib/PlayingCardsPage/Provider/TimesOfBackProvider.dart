import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'TimesOfBackProvider.g.dart';

@riverpod
class TimesOfBack extends _$TimesOfBack {
  @override
  int build() {
    return 0;
  }

  void reset() {
    state = 0;
  }

  void add() {
    state += 1;
  }

  void subtract() {
    if (state != 0) {
      state -= 1;
    }
  }
}
