import 'package:high_and_low/Ad/InterstitialAd.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ShowAdByBackProvider.g.dart';

@riverpod
class ShowAdByBack extends _$ShowAdByBack {
  @override
  int build() {
    return 0;
  }

  void showAdByBack() {
    _addTimesOfBack();
    if (state > 9) {
      _showInterstitialAd();
      state = 0;
    }
  }

  void _addTimesOfBack() {
    state += 1;
  }

  void _showInterstitialAd() {
    InterstitialAd.instance.show();
  }
}
