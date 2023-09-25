import 'package:flutter/material.dart';
import 'package:high_and_low/Ad/ShowAdProvider/ShowAdByResetProvider.dart';
import 'package:high_and_low/PlayingCardsPage/Provider/GameStateProvider.dart';
import 'package:high_and_low/PlayingCardsPage/Provider/TimesOfBackProvider.dart';
import 'package:high_and_low/PlayingCardsPage/ViewModel/GameViewModel.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RightSideWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _gameViewModel = GameViewModel(ref);
    final Size size = MediaQuery.of(context).size;

    final _isUsedJokerState = ref.watch(isUsedJokerProvider);
    final _timesOfBackState = ref.watch(timesOfBackProvider);
    final _isVisibleOpenButtonState = ref.watch(isVisibleOpenButtonProvider);
    final _showAdByResetNotifier = ref.watch(showAdByResetProvider.notifier);
    return SizedBox(
      width: size.width * 0.2,
      child:
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
              value: _isUsedJokerState,
              onChanged: (e) {
                _gameViewModel.insertJoker(e);
                _gameViewModel.reset();
                _showAdByResetNotifier.showAdByReset();
              },
            ),
          ],
        ),
        Visibility(
            visible: _isVisibleOpenButtonState,
            maintainSize: true,
            maintainState: true,
            maintainAnimation: true,
            child: MaterialButton(
              onPressed: () {
                _gameViewModel.flip();
              },
              child: Text(_timesOfBackState == 0 ? "Open" : "Next",
                  style: TextStyle(fontSize: size.width * 0.03)),
              padding: EdgeInsets.all(size.width * 0.03),
              color: _timesOfBackState == 0
                  ? Color.fromARGB(255, 6, 221, 221)
                  : Color.fromARGB(255, 162, 255, 75),
              textColor: Colors.white,
              shape: CircleBorder(),
            ))
      ]),
    );
  }
}
