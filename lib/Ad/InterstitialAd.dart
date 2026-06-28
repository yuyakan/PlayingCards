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

  /// 取得失敗時にリトライする最大回数。
  static const int _maxLoadAttempt = 5;

  /// 指数バックオフの待機時間の上限（秒）。
  static const int _maxBackoffSeconds = 32;

  /// 2 の [exponent] 乗を返す（指数バックオフの待機秒数の計算に使用）。
  int _pow2(final int exponent) => 1 << exponent;

  /// The interstitial ad
  admob.InterstitialAd? _interstitialAd;

  /// Returns true if interstitial ad is already loaded, otherwise false.
  bool get isLoaded => _interstitialAd != null;

  /// Returns true if interstitial ad is not loaded, otherwise false.
  bool get isNotLoaded => _interstitialAd == null;

  Future<void> load() async => await admob.InterstitialAd.load(
        // テスト広告を表示（現在有効）
        adUnitId: Platform.isAndroid ? ANDROID_TEST_AD_KEY : IOS_TEST_AD_KEY,
        // 本番広告を表示する場合は上をコメントアウトし、下を有効化する
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

            if (_countLoadAttempt <= _maxLoadAttempt) {
              // 指数バックオフ: 2^n 秒（上限あり）待ってから再取得する。
              final waitSeconds =
                  _pow2(_countLoadAttempt).clamp(1, _maxBackoffSeconds);
              await Future<void>.delayed(Duration(seconds: waitSeconds));
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
        onAdDismissedFullScreenContent: (final interstitialAd) async {
          await interstitialAd.dispose();
          _interstitialAd = null;

          /// Load next ad.
          await load();
        },
        onAdFailedToShowFullScreenContent:
            (final interstitialAd, final adError) async {
          await interstitialAd.dispose();
          _interstitialAd = null;

          /// Load next ad.
          await load();
        },
      );

      await _interstitialAd!.show();
    }
  }
}
