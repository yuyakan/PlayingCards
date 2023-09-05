import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:high_and_low/InterstialAd.dart';

class PlayingCards extends StatefulWidget {
  const PlayingCards({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<PlayingCards> createState() => _PlayingCardsState();
}

var joker = false;

class CardsDeck {
  var _cards;
  var hasJoker = false;

  CardsDeck() {
    _cards = new List.generate(52, (i) => i);
  }

  bool isEmpty() {
    return _cards.isEmpty;
  }

  void addJoker() {
    _cards.add(53);
    _cards.add(54);
  }

  int drow() {
    return _cards.removeLast();
  }

  void stackOnTop(int card) {
    _cards.add(card);
  }

  void shuffle() {
    _cards.shuffle();
  }
}

class FieldCards {
  var _cards = []; //backcardsnum
  var _topCard = "white_card.png"; //card_img

  void add(int card) {
    _cards.add(card);
  }

  bool isEmpty() {
    return _cards.isEmpty;
  }

  int removeTop() {
    return _cards.removeLast();
  }

  // String topCard() {
  //   if (_cards.isEmpty) {
  //     return "white_card.png";
  //   }
  // }
}

class Card {
  final int num;
  final String cardImageName;

  Card(this.num, this.cardImageName);
}

class _PlayingCardsState extends State<PlayingCards> {
  final String EMPTY_CARD = "img/cards/white_card.png";
  final String EMPTY_CARDS = "img/cards/white_cards.png";
  final String BACK_OF_CARDS = "img/backs.png";

  CardsDeck cardsDeck = CardsDeck();
  FieldCards fieldCards = FieldCards();

  // 広告の制御変数
  var reset_num = 0;
  var back_num = 0;

  var card_img = "white_card.png";
  var back_first = false;
  var next_first = false;
  var back_counter = 0;

  var hasJoker = false;

  // setState(() {
  //     cards = [];
  //     cards = new List.generate(52, (i) => i);

  //     cardsDeck.isEmpty = false;

  //     back_juddge = true;
  //     card_img = "white_card.png";
  //     back_card_num = null;
  //     back_cards_num = [];
  //     card_num = null;
  //     back_first = false;
  //     next_first = false;
  //     back_counter = 0;

  //     if (hasJoker) {
  //       Joker();
  //     }
  //     cards.shuffle();
  //   });

  String open() {
    if (back_counter != 0) {
      back_counter -= 1;
    }
    next_first = false;
    back_first = true;

    var _card = cardsDeck.drow();
    fieldCards.add(_card);

    var mark = "D";
    switch ((_card ~/ 13) + 1) {
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
    var card_num_convert = _card % 13 + 1;
    var card = "$mark$card_num_convert.png";
    return card;
  }

  String back() {
    back_counter += 1;
    next_first = true;
    back_first = false;
    var _card = fieldCards.removeTop();
    cardsDeck.stackOnTop(_card);

    var mark = "D";
    switch ((_card ~/ 13) + 1) {
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
    var back_card_num_convert = _card % 13 + 1;
    var card = "$mark$back_card_num_convert.png";
    return card;
  }

  void gameReset() {
    setState(() {
      cardsDeck = CardsDeck();
      fieldCards = FieldCards();
      back_first = false;
      next_first = false;
      back_counter = 0;
      if (hasJoker) {
        cardsDeck.addJoker();
      }
      cardsDeck.shuffle();
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
                  gameReset();
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
                  visible: !fieldCards.isEmpty(),
                  maintainSize: true,
                  maintainState: true,
                  maintainAnimation: true,
                  child: MaterialButton(
                    onPressed: () {
                      if (back_first) {
                        setState(() {
                          card_img = back();
                        });
                      }
                      setState(() {
                        card_img = back();
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
                EMPTY_CARDS,
                width: size.width * 0.25,
              ),
              Visibility(
                visible: !cardsDeck.isEmpty(),
                maintainSize: true,
                maintainState: true,
                maintainAnimation: true,
                child: Image.asset(
                  BACK_OF_CARDS,
                  width: size.width * 0.25,
                ),
              ),
            ]),
            SizedBox(
              width: size.width * 0.04,
            ),
            Stack(children: [
              Image.asset(
                EMPTY_CARD,
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
                    value: hasJoker,
                    onChanged: (e) {
                      setState(() {
                        hasJoker = e;
                        gameReset();
                      });
                    },
                  ),
                ],
              ),
              (() {
                // 即時関数を使う
                if (back_counter == 0) {
                  return Visibility(
                      visible: !cardsDeck.isEmpty(),
                      maintainSize: true,
                      maintainState: true,
                      maintainAnimation: true,
                      child: MaterialButton(
                        onPressed: () {
                          if (next_first) {
                            setState(() {
                              card_img = open();
                            });
                          }
                          setState(() {
                            card_img = open();
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
                      visible: !cardsDeck.isEmpty(),
                      maintainSize: true,
                      maintainState: true,
                      maintainAnimation: true,
                      child: MaterialButton(
                        onPressed: () {
                          if (next_first) {
                            setState(() {
                              card_img = open();
                            });
                          }
                          setState(() {
                            card_img = open();
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
    cardsDeck.shuffle();
  }
}
