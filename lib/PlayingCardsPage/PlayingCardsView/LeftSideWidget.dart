import 'package:flutter/material.dart';
import 'package:high_and_low/PlayingCardsPage/FieldCards.dart';

class LeftSideWidget extends StatefulWidget {
  final Function() gameReset;
  final Function() back;
  final FieldCards fieldCards;

  LeftSideWidget(
      {required this.gameReset, required this.back, required this.fieldCards});
  @override
  _LeftSideState createState() => _LeftSideState();
}

class _LeftSideState extends State<LeftSideWidget> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      MaterialButton(
        onPressed: () {
          widget.gameReset();
        },
        child: Text("Reset", style: TextStyle(fontSize: size.width * 0.03)),
        padding: EdgeInsets.all(size.width * 0.03),
        color: Color.fromARGB(255, 6, 221, 221),
        textColor: Colors.white,
        shape: CircleBorder(),
      ),
      Visibility(
          visible: !widget.fieldCards.isEmpty(),
          maintainSize: true,
          maintainState: true,
          maintainAnimation: true,
          child: MaterialButton(
            onPressed: () {
              widget.back();
            },
            child: Text("Back", style: TextStyle(fontSize: size.width * 0.03)),
            padding: EdgeInsets.all(size.width * 0.03),
            color: Color.fromARGB(255, 6, 221, 221),
            textColor: Colors.white,
            shape: CircleBorder(),
          )),
    ]);
  }
}
