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

  /// 2回目以降の広告を表示するまでに必要な、前回表示からの最小間隔。
  static const Duration _minShowInterval = Duration(seconds: 90);

  /// 直近で広告を表示した時刻。アプリ起動中のみメモリに保持し、
  /// アプリを終了すると失われる（次回起動時は 1 回目として扱う）。
  DateTime? _lastShownAt;

  /// The interstitial ad
  admob.InterstitialAd? _interstitialAd;

  /// Returns true if interstitial ad is already loaded, otherwise false.
  bool get isLoaded => _interstitialAd != null;

  /// Returns true if interstitial ad is not loaded, otherwise false.
  bool get isNotLoaded => _interstitialAd == null;

  Future<void> load() async => await admob.InterstitialAd.load(
        // iOS・Android ともに本番広告を表示する。
        adUnitId: Platform.isAndroid ? ANDROID_AD_KEY : IOS_AD_KEY,

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
    // 2回目以降は、前回表示から _minShowInterval 経過していなければ表示しない。
    // （初回は _lastShownAt が null のため、このガードを通過する）
    final lastShownAt = _lastShownAt;
    if (lastShownAt != null &&
        DateTime.now().difference(lastShownAt) < _minShowInterval) {
      return;
    }

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

      // 表示時刻を記録してから表示する（次回以降の間隔ガードに使用）。
      _lastShownAt = DateTime.now();
      await _interstitialAd!.show();
    }
  }
}
