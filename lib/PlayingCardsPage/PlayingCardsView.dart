import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:high_and_low/Ad/AdManager.dart';
import 'package:high_and_low/PlayingCardsPage/CardsDeck.dart';
import 'package:high_and_low/PlayingCardsPage/FieldCards.dart';
import 'package:high_and_low/PlayingCardsPage/TimesOfBack.dart';

class PlayingCards extends StatefulWidget {
  const PlayingCards({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<PlayingCards> createState() => _PlayingCardsState();
}

class _PlayingCardsState extends State<PlayingCards> {
  final String EMPTY_CARD = "img/cards/white_card.png";
  final String EMPTY_CARDS = "img/cards/white_cards.png";
  final String BACK_OF_CARDS = "img/backs.png";

  CardsDeck cardsDeck = CardsDeck(false);
  FieldCards fieldCards = FieldCards();
  TimesOfBack timesOfBack = TimesOfBack();
  AdManager adManager = AdManager();

  String cardImage = "white_card.png";
  bool isUsedJoker = false;

  void open() {
    timesOfBack.subtract();
    fieldCards.add(cardsDeck.drow());

    setState(() {
      cardImage = fieldCards.topCard();
    });
  }

  void back() {
    timesOfBack.add();
    cardsDeck.stackOnTop(fieldCards.removeTop());
    setState(() {
      cardImage = fieldCards.topCard();
    });

    adManager.showAdByBack();
  }

  void gameReset() {
    cardsDeck = CardsDeck(isUsedJoker);
    fieldCards = FieldCards();
    timesOfBack = TimesOfBack();
    setState(() {
      cardImage = "white_card.png";
    });

    adManager.showAdByReset();
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
                },
                child: Text("Reset",
                    style: TextStyle(fontSize: size.width * 0.03)),
                padding: EdgeInsets.all(size.width * 0.03),
                color: Color.fromARGB(255, 6, 221, 221),
                textColor: Colors.white,
                shape: CircleBorder(),
              ),
              Visibility(
                  visible: !fieldCards.isEmpty(),
                  maintainSize: true,
                  maintainState: true,
                  maintainAnimation: true,
                  child: MaterialButton(
                    onPressed: () {
                      back();
                    },
                    child: Text("Back",
                        style: TextStyle(fontSize: size.width * 0.03)),
                    padding: EdgeInsets.all(size.width * 0.03),
                    color: Color.fromARGB(255, 6, 221, 221),
                    textColor: Colors.white,
                    shape: CircleBorder(),
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
                'img/cards/$cardImage',
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
                    value: isUsedJoker,
                    onChanged: (e) {
                      setState(() {
                        isUsedJoker = e;
                        gameReset();
                      });
                    },
                  ),
                ],
              ),
              Visibility(
                  visible: !cardsDeck.isEmpty(),
                  maintainSize: true,
                  maintainState: true,
                  maintainAnimation: true,
                  child: MaterialButton(
                    onPressed: () {
                      open();
                    },
                    child: Text(timesOfBack.isZero() ? "Open" : "Next",
                        style: TextStyle(fontSize: size.width * 0.03)),
                    padding: EdgeInsets.all(size.width * 0.03),
                    color: timesOfBack.isZero()
                        ? Color.fromARGB(255, 6, 221, 221)
                        : Color.fromARGB(255, 162, 255, 75),
                    textColor: Colors.white,
                    shape: CircleBorder(),
                  ))
            ]),
            Spacer(),
          ],
        ),
      ),
    ));
  }
}
