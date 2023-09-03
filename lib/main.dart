import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //これ入れないとダメだったと思います。
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await admob.MobileAds.instance.initialize();
  await InterstitialAd.instance.load();

  runApp(const MyApp());
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
      home: const MyHomePage(title: 'Playing cards'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

var joker = false;

class _MyHomePageState extends State<MyHomePage> {
  var reset_num = 0;
  var back_num = 0;

  var cards = new List.generate(52, (i) => i);
  var juddge = false;
  var back_juddge = true;
  var card_img = "white_card.png";
  var back_card_num = null;
  var back_cards_num = [];
  var card_num = null;

  var back_first = false;
  var next_first = false;

  var back_counter = 0;

  var joker = false;

  void Joker() {
    cards.add(53);
    cards.add(54);
  }

  String open() {
    if (back_counter != 0) {
      back_counter -= 1;
    }
    next_first = false;
    back_first = true;
    back_juddge = false;
    if (back_cards_num.isEmpty) {
      print(back_cards_num);
      back_juddge = true;
    }
    card_num = cards.removeLast();
    back_cards_num.add(card_num);
    print(card_num);
    var mark = "D";
    switch ((card_num ~/ 13) + 1) {
      case 1:
        mark = "D";
        break;
      case 2:
        mark = "H";
        break;
      case 3:
        mark = "K";
        break;
      case 4:
        mark = "S";
        break;
      case 5:
        mark = "JOKER";
        break;
    }
    var card_num_convert = card_num % 13 + 1;
    var card = "$mark$card_num_convert.png";
    return card;
  }

  String back() {
    setState(() {
      juddge = false;
    });
    back_counter += 1;
    next_first = true;
    back_first = false;
    cards.add(back_cards_num.last);
    back_card_num = back_cards_num.removeLast();
    print(back_card_num);
    var mark = "D";
    switch ((back_card_num ~/ 13) + 1) {
      case 1:
        mark = "D";
        break;
      case 2:
        mark = "H";
        break;
      case 3:
        mark = "K";
        break;
      case 4:
        mark = "S";
        break;
      case 5:
        mark = "JOKER";
        break;
    }
    var back_card_num_convert = back_card_num % 13 + 1;
    var card = "$mark$back_card_num_convert.png";
    return card;
  }

  void reset() {
    setState(() {
      cards = [];
      cards = new List.generate(52, (i) => i);
      juddge = false;
      back_juddge = true;
      card_img = "white_card.png";
      back_card_num = null;
      back_cards_num = [];
      card_num = null;
      back_first = false;
      next_first = false;
      back_counter = 0;
      if (joker) {
        Joker();
      }
      cards.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('img/white.png'),
        fit: BoxFit.cover,
      )),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Spacer(),
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              MaterialButton(
                onPressed: () {
                  reset();
                  reset_num += 1;
                  if (reset_num > 1) {
                    InterstitialAd.instance.show();
                    reset_num = 0;
                  }
                },
                child: Text("Reset",
                    style: TextStyle(fontSize: size.width * 0.03)),
                padding: EdgeInsets.all(size.width * 0.03), //パディング
                color: Color.fromARGB(255, 6, 221, 221), //背景色
                textColor: Colors.white, //アイコンの色
                shape: CircleBorder(), //丸
              ),
              Visibility(
                  visible: !back_juddge,
                  maintainSize: true,
                  maintainState: true,
                  maintainAnimation: true,
                  child: MaterialButton(
                    onPressed: () {
                      if (back_first) {
                        setState(() {
                          card_img = back();
                          back_juddge = back_cards_num.isEmpty;
                        });
                      }
                      setState(() {
                        card_img = back();
                        back_juddge = back_cards_num.isEmpty;
                      });
                      back_num += 1;
                      if (back_num > 9) {
                        InterstitialAd.instance.show();
                        back_num = 0;
                      }
                    },
                    child: Text("Back",
                        style: TextStyle(fontSize: size.width * 0.03)),
                    padding: EdgeInsets.all(size.width * 0.03), //パディング
                    color: Color.fromARGB(255, 6, 221, 221), //背景色
                    textColor: Colors.white, //アイコンの色
                    shape: CircleBorder(), //丸
                  )),
            ]),
            Spacer(),
            Stack(children: [
              Image.asset(
                'img/cards/white_cards.png',
                width: size.width * 0.25,
              ),
              Visibility(
                visible: !juddge,
                maintainSize: true,
                maintainState: true,
                maintainAnimation: true,
                child: Image.asset(
                  'img/back2_.png',
                  width: size.width * 0.25,
                ),
              ),
            ]),
            SizedBox(
              width: size.width * 0.04,
            ),
            Stack(children: [
              Image.asset(
                'img/cards/white_card.png',
                width: size.width * 0.25,
              ),
              Image.asset(
                'img/cards/$card_img',
                width: size.width * 0.25,
              ),
            ]),
            Spacer(),
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Column(
                children: [
                  Text("Joker",
                      style: TextStyle(
                          fontSize: size.width * 0.04,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cursive')),
                  Switch(
                    value: joker,
                    onChanged: (e) {
                      setState(() {
                        joker = e;
                        print(joker);
                        reset();
                      });
                    },
                  ),
                ],
              ),
              (() {
                // 即時関数を使う
                if (back_counter == 0) {
                  return Visibility(
                      visible: !juddge,
                      maintainSize: true,
                      maintainState: true,
                      maintainAnimation: true,
                      child: MaterialButton(
                        onPressed: () {
                          if (next_first) {
                            setState(() {
                              card_img = open();
                              juddge = cards.isEmpty;
                            });
                          }
                          setState(() {
                            card_img = open();
                            juddge = cards.isEmpty;
                          });
                        },
                        child: Text("Open",
                            style: TextStyle(fontSize: size.width * 0.03)),
                        padding: EdgeInsets.all(size.width * 0.03), //パディング
                        color: Color.fromARGB(255, 6, 221, 221), //背景色
                        textColor: Colors.white, //アイコンの色
                        shape: CircleBorder(), //丸
                      ));
                } else {
                  return Visibility(
                      visible: !juddge,
                      maintainSize: true,
                      maintainState: true,
                      maintainAnimation: true,
                      child: MaterialButton(
                        onPressed: () {
                          if (next_first) {
                            setState(() {
                              card_img = open();
                              juddge = cards.isEmpty;
                            });
                          }
                          setState(() {
                            card_img = open();
                            juddge = cards.isEmpty;
                          });
                        },
                        child: Text("Next",
                            style: TextStyle(fontSize: size.width * 0.03)),
                        padding: EdgeInsets.all(size.width * 0.03), //パディング
                        color: Color.fromARGB(255, 162, 255, 75), //背景色
                        textColor: Colors.white, //アイコンの色
                        shape: CircleBorder(), //丸
                      ));
                }
              })(),
            ]),
            Spacer(),
          ],
        ),
      ),
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("${this} didChangeDependencies() _StateLifecycle.initialized");
    cards.shuffle();
  }
}
