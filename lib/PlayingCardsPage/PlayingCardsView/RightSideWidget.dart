import 'package:flutter/material.dart';
import 'package:high_and_low/Ad/ShowAdProvider/ShowAdByResetProvider.dart';
import 'package:high_and_low/PlayingCardsPage/Provider/CardsDeckProvider.dart';
import 'package:high_and_low/PlayingCardsPage/Provider/FieldCardsProvider.dart';
import 'package:high_and_low/PlayingCardsPage/Provider/GameStateProvider.dart';
import 'package:high_and_low/PlayingCardsPage/Provider/TimesOfBackProvider.dart';
import 'package:high_and_low/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RightSideWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _isUsedJokerState = ref.watch(isUsedJokerProvider);
    final _timesOfBackState = ref.watch(timesOfBackProvider);
    final _isVisibleOpenButtonState = ref.watch(isVisibleOpenButtonProvider);
    final _showAdByResetNotifier = ref.watch(showAdByResetProvider.notifier);
    final Size size = MediaQuery.of(context).size;
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
                ref.read(isUsedJokerProvider.notifier).state = e;
                ref.read(timesOfBackProvider.notifier).reset();
                ref.read(fieldCardsProvider.notifier).reset();
                ref.read(cardsDeckProvider.notifier).reset();
                ref.read(isVisibleBackButtonProvider.notifier).state = false;
                ref.read(isVisibleOpenButtonProvider.notifier).state = true;
                ref.read(cardsDeckProvider.notifier).insertJoker(e);
                ref.read(cardImageProvider.notifier).state = EMPTY_CARD;
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
                ref.read(timesOfBackProvider.notifier).subtract();
                ref
                    .read(fieldCardsProvider.notifier)
                    .add(ref.read(cardsDeckProvider.notifier).drow());
                ref.read(cardImageProvider.notifier).state =
                    ref.read(fieldCardsProvider.notifier).topCard();

                ref.read(isVisibleOpenButtonProvider.notifier).state =
                    !ref.read(cardsDeckProvider).isEmpty;
                ref.read(isVisibleBackButtonProvider.notifier).state =
                    !ref.read(fieldCardsProvider).isEmpty;
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
