import 'package:high_and_low/Ad/InterstitialAd.dart';

class AdManager {
  int _numberOfReset = 0;
  int _numberOfBack = 0;

  void showAdByReset() {
    _addTimesOfReset();
    if (_numberOfReset > 1) {
      _showInterstitialAd();
      _numberOfReset = 0;
    }
  }

  void showAdByBack() {
    _addTimesOfBack();
    if (_numberOfBack > 9) {
      _showInterstitialAd();
      _numberOfBack = 0;
    }
  }

  void _addTimesOfReset() {
    _numberOfReset += 1;
  }

  void _addTimesOfBack() {
    _numberOfBack += 1;
  }

  void _showInterstitialAd() {
    InterstitialAd.instance.show();
  }
}
