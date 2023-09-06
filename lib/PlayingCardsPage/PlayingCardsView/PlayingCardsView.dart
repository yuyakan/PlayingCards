import 'package:flutter/material.dart';
import 'package:high_and_low/Ad/AdManager.dart';
import 'package:high_and_low/PlayingCardsPage/CardsDeck.dart';
import 'package:high_and_low/PlayingCardsPage/FieldCards.dart';
import 'package:high_and_low/PlayingCardsPage/PlayingCardsView/GameFieldWidget.dart';
import 'package:high_and_low/PlayingCardsPage/PlayingCardsView/LeftSideWidget.dart';
import 'package:high_and_low/PlayingCardsPage/PlayingCardsView/RightSideWidget.dart';
import 'package:high_and_low/PlayingCardsPage/TimesOfBack.dart';
import 'package:high_and_low/constants.dart';

class PlayingCards extends StatefulWidget {
  const PlayingCards({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<PlayingCards> createState() => _PlayingCardsState();
}

class _PlayingCardsState extends State<PlayingCards> {
  CardsDeck cardsDeck = CardsDeck(false);
  FieldCards fieldCards = FieldCards();
  TimesOfBack timesOfBack = TimesOfBack();
  AdManager adManager = AdManager();

  String cardImage = EMPTY_CARD;
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
    setState(() {
      cardsDeck = CardsDeck(isUsedJoker);
      fieldCards = FieldCards();
      timesOfBack = TimesOfBack();
      cardImage = EMPTY_CARD;
    });

    adManager.showAdByReset();
  }

  void togleIsUsedJoker(bool _isUsedJoker) {
    setState(() {
      isUsedJoker = _isUsedJoker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage(GAME_FIELD),
        fit: BoxFit.cover,
      )),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Spacer(),
            LeftSideWidget(
                gameReset: gameReset, back: back, fieldCards: fieldCards),
            Spacer(),
            GameFieldWidget(
                cardImage: cardImage, isEmptyCardsDeck: cardsDeck.isEmpty()),
            Spacer(),
            RightSideWidget(
                gameReset: gameReset,
                open: open,
                togleIsUsedJoker: togleIsUsedJoker,
                isUsedJoker: isUsedJoker,
                isEmpytCardsDeck: cardsDeck.isEmpty(),
                isZeroTimesOfBack: timesOfBack.isZero()),
            Spacer(),
          ],
        ),
      ),
    ));
  }
}
