import 'package:flutter/material.dart';
import 'package:high_and_low/constants.dart';

class GameFieldWidget extends StatefulWidget {
  final String cardImage;
  final bool isEmptyCardsDeck;

  GameFieldWidget({required this.cardImage, required this.isEmptyCardsDeck});
  @override
  _GameFieldState createState() => _GameFieldState();
}

class _GameFieldState extends State<GameFieldWidget> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        Stack(children: [
          Image.asset(
            EMPTY_CARDS,
            width: size.width * 0.25,
          ),
          Visibility(
            visible: !widget.isEmptyCardsDeck,
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
            widget.cardImage,
            width: size.width * 0.25,
          ),
        ]),
      ],
    );
  }
}
