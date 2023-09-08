import 'package:high_and_low/Ad/InterstitialAd.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ShowAdByResetProvider.g.dart';

@riverpod
class ShowAdByReset extends _$ShowAdByReset {
  @override
  int build() {
    return 0;
  }

  void showAdByReset() {
    _addTimesOfReset();
    if (state > 1) {
      _showInterstitialAd();
      state = 0;
    }
  }

  void _addTimesOfReset() {
    state += 1;
  }

  void _showInterstitialAd() {
    InterstitialAd.instance.show();
  }
}
