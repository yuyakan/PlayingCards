import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// アプリ初回起動時刻を保存するキー（インストール後に一度だけ記録）。
const String _firstLaunchKey = 'firstLaunchAt';

/// 前回レビューをリクエストした時刻を保存するキー。
const String _lastReviewRequestKey = 'lastReviewRequestAt';

/// 初回起動からレビューを出せるようになるまでの最小経過時間。
const Duration _minElapsedSinceFirstLaunch = Duration(seconds: 60);

/// 前回リクエストから次にリクエストできるようになるまでの最小間隔。
const Duration _minIntervalBetweenRequests = Duration(minutes: 30);

/// アプリの初回起動時刻を記録する（未記録のときだけ保存）。
/// アプリ起動時（main）に呼ぶことで、「インストール後に初めて起動した瞬間」を起点にする。
Future<void> recordFirstLaunchIfNeeded() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getInt(_firstLaunchKey) == null) {
    await prefs.setInt(_firstLaunchKey, DateTime.now().millisecondsSinceEpoch);
  }
}

void showDialog() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final int nowMillis = DateTime.now().millisecondsSinceEpoch;

  // ガード1: 初回起動から 60 秒以上経過しているか。
  // （初回起動時刻は main の recordFirstLaunchIfNeeded() で記録済みの想定）
  final int? firstLaunchMillis = prefs.getInt(_firstLaunchKey);
  if (firstLaunchMillis == null ||
      nowMillis - firstLaunchMillis <
          _minElapsedSinceFirstLaunch.inMilliseconds) {
    return;
  }

  // ガード2: 前回リクエストから 30 分以上経過しているか。
  final int? lastRequestMillis = prefs.getInt(_lastReviewRequestKey);
  if (lastRequestMillis != null &&
      nowMillis - lastRequestMillis <
          _minIntervalBetweenRequests.inMilliseconds) {
    return;
  }

  final InAppReview inAppReview = InAppReview.instance;
  if (await inAppReview.isAvailable()) {
    inAppReview.requestReview();
    await prefs.setInt(_lastReviewRequestKey, nowMillis);
  }
}
