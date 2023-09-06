import 'package:flutter/material.dart';

class RightSideWidget extends StatefulWidget {
  final Function() gameReset;
  final Function() open;
  final Function(bool e) togleIsUsedJoker;
  final bool isUsedJoker;
  final bool isEmpytCardsDeck;
  final bool isZeroTimesOfBack;

  RightSideWidget(
      {required this.gameReset,
      required this.open,
      required this.togleIsUsedJoker,
      required this.isUsedJoker,
      required this.isEmpytCardsDeck,
      required this.isZeroTimesOfBack});
  @override
  _RightSideState createState() => _RightSideState();
}

class _RightSideState extends State<RightSideWidget> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Column(
        children: [
          Text("Joker",
              style: TextStyle(
                  fontSize: size.width * 0.04,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cursive')),
          Switch(
            value: widget.isUsedJoker,
            onChanged: (e) {
              widget.togleIsUsedJoker(e);
              widget.gameReset();
            },
          ),
        ],
      ),
      Visibility(
          visible: !widget.isEmpytCardsDeck,
          maintainSize: true,
          maintainState: true,
          maintainAnimation: true,
          child: MaterialButton(
            onPressed: () {
              widget.open();
            },
            child: Text(widget.isZeroTimesOfBack ? "Open" : "Next",
                style: TextStyle(fontSize: size.width * 0.03)),
            padding: EdgeInsets.all(size.width * 0.03),
            color: widget.isZeroTimesOfBack
                ? Color.fromARGB(255, 6, 221, 221)
                : Color.fromARGB(255, 162, 255, 75),
            textColor: Colors.white,
            shape: CircleBorder(),
          ))
    ]);
  }
}
