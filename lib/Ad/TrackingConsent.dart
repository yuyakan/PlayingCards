import 'dart:async';
import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as admob;

/// 広告表示前の同意取得（UMP同意フロー + ATT）をまとめて扱う。
///
/// AdMob を初期化する前に [request] を一度だけ呼ぶこと。
/// 呼び出し順は「UMP同意フォーム → ATTダイアログ → AdMob初期化」の順で、
/// この順序を守らないと ATT の許諾状態が広告リクエストに反映されない。
class TrackingConsent {
  /// The internal constructor.
  TrackingConsent._internal();

  /// Returns the singleton instance of [TrackingConsent].
  static TrackingConsent get instance => _singletonInstance;

  /// The singleton instance of this [TrackingConsent].
  static final _singletonInstance = TrackingConsent._internal();

  /// UMP の同意情報を更新し、必要なら同意フォームを表示したうえで、
  /// iOS では続けて ATT のダイアログを表示する。
  ///
  /// AdMob の `MobileAds.instance.initialize()` を呼ぶ前に実行すること。
  Future<void> request() async {
    await _requestUmpConsent();
    await _requestAppTrackingTransparency();
  }

  /// UMP（User Messaging Platform）の同意情報を更新し、
  /// 表示が必要な場合は同意フォームを提示する。
  ///
  /// EEA 等の対象地域以外では基本的にフォームは表示されない。
  /// 同意取得に失敗しても広告表示自体は継続できるため、例外は握りつぶす。
  Future<void> _requestUmpConsent() async {
    final completer = Completer<void>();
    admob.ConsentInformation.instance.requestConsentInfoUpdate(
      admob.ConsentRequestParameters(),
      () async {
        try {
          await admob.ConsentForm.loadAndShowConsentFormIfRequired((_) {});
        } catch (_) {
          // 同意フォームの取得・表示に失敗しても続行する。
        }
        if (!completer.isCompleted) completer.complete();
      },
      (admob.FormError error) {
        // 同意情報の更新に失敗しても続行する。
        if (!completer.isCompleted) completer.complete();
      },
    );
    await completer.future;
  }

  /// iOS で ATT のトラッキング許可ダイアログを表示する。
  ///
  /// まだ未確定（notDetermined）の場合のみ OS 標準ダイアログを表示し、
  /// すでに許可/拒否済みの場合は何もしない。iOS 以外では何もしない。
  Future<void> _requestAppTrackingTransparency() async {
    if (!Platform.isIOS) return;
    final status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }
}
