import 'package:flutter/material.dart';
import 'package:high_and_low/PlayingCardsPage/PlayingCardsView/GameFieldWidget.dart';
import 'package:high_and_low/PlayingCardsPage/PlayingCardsView/LeftSideWidget.dart';
import 'package:high_and_low/PlayingCardsPage/PlayingCardsView/RightSideWidget.dart';
import 'package:high_and_low/constants.dart';

class PlayingCards extends StatelessWidget {
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
            LeftSideWidget(),
            Spacer(),
            GameFieldWidget(),
            Spacer(),
            RightSideWidget(),
            Spacer(),
          ],
        ),
      ),
    ));
  }
}
