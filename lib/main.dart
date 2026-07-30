import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as admob;
import 'package:high_and_low/Ad/InterstitialAd.dart';
import 'package:high_and_low/Ad/TrackingConsent.dart';
import 'package:high_and_low/ReviewDialog/ShowDialog.dart';
import 'package:high_and_low/PlayingCardsPage/View/PlayingCardsView.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // 先に UI を起動してフォーカス可能なウィンドウを即座に確立する。
  // 同意フローや広告初期化を待ってから runApp すると、その間ウィンドウが
  // 存在せず「Input dispatching timed out (No focused window)」による
  // ANR を招くため、重い初期化は UI 表示後にバックグラウンドで行う。
  runApp(ProviderScope(child: const MyApp()));

  await _initializeAds();
}

/// 同意フローと広告の初期化を行う。
///
/// 順序は「UMP同意フロー → ATT → AdMob初期化 → 広告ロード」を守ること。
/// この順序を崩すと ATT の許諾状態が広告リクエストに反映されない。
/// UI 表示をブロックしないよう、[main] では runApp の後に呼び出す。
Future<void> _initializeAds() async {
  await TrackingConsent.instance.request();
  await admob.MobileAds.instance.initialize();
  await InterstitialAd.instance.load();
  await recordFirstLaunchIfNeeded();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Playing cards',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlayingCards(),
    );
  }
}
