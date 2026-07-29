import UIKit
import Flutter
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Firebase はアプリ起動時に一度だけ構成する。
    // didInitializeImplicitFlutterEngine は複数回呼ばれ得るため、
    // ここに置かないと二重初期化で SIGABRT クラッシュする。
    FirebaseApp.configure()
    // UIScene ライフサイクル移行に伴い、プラグイン登録は
    // didInitializeImplicitFlutterEngine に移動した。
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
