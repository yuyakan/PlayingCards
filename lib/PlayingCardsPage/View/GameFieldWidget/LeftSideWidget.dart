import 'package:flutter/material.dart';
import 'package:high_and_low/PlayingCardsPage/Model/FieldsCards/FieldCardsProvider.dart';
import 'package:high_and_low/PlayingCardsPage/Model/GameState/GameStateProvider.dart';
import 'package:high_and_low/PlayingCardsPage/ViewModel/GameViewModel.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LeftSideWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _gameViewModel = GameViewModel(ref);
    final Size size = MediaQuery.of(context).size;

    final _ = ref.watch(fieldCardsProvider);
    final _isVisibleBackButtonState = ref.watch(isVisibleBackButtonProvider);

    return SizedBox(
      width: size.width * 0.2,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        MaterialButton(
          onPressed: () {
            _gameViewModel.reset();
          },
          child: Text("Reset", style: TextStyle(fontSize: size.width * 0.03)),
          padding: EdgeInsets.all(size.width * 0.03),
          color: Color.fromARGB(255, 6, 221, 221),
          textColor: Colors.white,
          shape: CircleBorder(),
        ),
        Visibility(
            visible: _isVisibleBackButtonState,
            maintainSize: true,
            maintainState: true,
            maintainAnimation: true,
            child: MaterialButton(
              onPressed: () {
                _gameViewModel.back();
              },
              child:
                  Text("Back", style: TextStyle(fontSize: size.width * 0.03)),
              padding: EdgeInsets.all(size.width * 0.03),
              color: Color.fromARGB(255, 6, 221, 221),
              textColor: Colors.white,
              shape: CircleBorder(),
            )),
      ]),
    );
  }
}
