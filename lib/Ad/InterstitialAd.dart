import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart' as admob;
import 'package:high_and_low/config.dart';

class InterstitialAd {
  /// The internal constructor.
  InterstitialAd._internal();

  /// Returns the singleton instance of [InterstitialAd].
  static InterstitialAd get instance => _singletonInstance;

  /// The singleton instance of this [InterstitialAd].
  static final _singletonInstance = InterstitialAd._internal();

  /// The count of load attempt
  int _countLoadAttempt = 0;

  /// The interstitial ad
  admob.InterstitialAd? _interstitialAd;

  /// Returns true if interstitial ad is already loaded, otherwise false.
  bool get isLoaded => _interstitialAd != null;

  /// Returns true if interstitial ad is not loaded, otherwise false.
  bool get isNotLoaded => _interstitialAd == null;

  Future<void> load() async => await admob.InterstitialAd.load(
        // test用
        adUnitId: Platform.isAndroid ? ANDROID_TEST_AD_KEY : IOS_TEST_AD_KEY,
        // 本番用
        // adUnitId: Platform.isAndroid ? ANDROID_AD_KEY : IOS_AD_KEY,

        request: const admob.AdRequest(),
        adLoadCallback: admob.InterstitialAdLoadCallback(
          onAdLoaded: (final admob.InterstitialAd interstitialAd) {
            _interstitialAd = interstitialAd;
            _countLoadAttempt = 0;
          },
          onAdFailedToLoad: (final admob.LoadAdError loadAdError) async {
            _interstitialAd = null;
            _countLoadAttempt++;

            if (_countLoadAttempt <= 5) {
              await load();
            }
          },
        ),
      );

  Future<void> show() async {
    if (isNotLoaded) {
      await load();
    }

    if (isLoaded) {
      _interstitialAd!.fullScreenContentCallback =
          admob.FullScreenContentCallback(
        onAdShowedFullScreenContent: (final interstitialAd) {},
        onAdDismissedFullScreenContent: (final interstitialAd) async {
          await interstitialAd.dispose();
        },
        onAdFailedToShowFullScreenContent:
            (final interstitialAd, final adError) async {
          await interstitialAd.dispose();
        },
      );

      await _interstitialAd!.show();
      _interstitialAd = null;

      /// Load next ad.
      await load();
    }
  }
}
