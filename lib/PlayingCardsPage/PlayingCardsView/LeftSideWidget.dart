import 'package:flutter/material.dart';
import 'package:high_and_low/Ad/ShowAdProvider/ShowAdByBackProvider.dart';
import 'package:high_and_low/Ad/ShowAdProvider/ShowAdByResetProvider.dart';
import 'package:high_and_low/PlayingCardsPage/Provider/CardsDeckProvider.dart';
import 'package:high_and_low/PlayingCardsPage/Provider/FieldCardsProvider.dart';
import 'package:high_and_low/PlayingCardsPage/Provider/GameStateProvider.dart';
import 'package:high_and_low/PlayingCardsPage/Provider/TimesOfBackProvider.dart';
import 'package:high_and_low/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LeftSideWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _isVisibleBackButtonState = ref.watch(isVisibleBackButtonProvider);
    final _fieldCardsState = ref.watch(fieldCardsProvider);
    final _showAdByResetNotifier = ref.watch(showAdByResetProvider.notifier);
    final _showAdByBackNotifier = ref.watch(showAdByBackProvider.notifier);
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.2,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        MaterialButton(
          onPressed: () {
            ref.read(timesOfBackProvider.notifier).reset();
            ref.read(fieldCardsProvider.notifier).reset();
            ref.read(cardsDeckProvider.notifier).reset();
            ref.read(isVisibleBackButtonProvider.notifier).state = false;
            ref.read(isVisibleOpenButtonProvider.notifier).state = true;
            ref
                .read(cardsDeckProvider.notifier)
                .insertJoker(ref.read(isUsedJokerProvider.notifier).state);
            ref.read(cardImageProvider.notifier).state = EMPTY_CARD;

            _showAdByResetNotifier.showAdByReset();
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
                ref.read(timesOfBackProvider.notifier).add();
                ref.read(cardsDeckProvider.notifier).stackOnTop(
                    ref.read(fieldCardsProvider.notifier).removeTop());
                ref.read(cardImageProvider.notifier).state =
                    ref.read(fieldCardsProvider.notifier).topCard();

                ref.read(isVisibleBackButtonProvider.notifier).state =
                    !_fieldCardsState.isEmpty;
                ref.read(isVisibleOpenButtonProvider.notifier).state =
                    !ref.read(cardsDeckProvider).isEmpty;

                _showAdByBackNotifier.showAdByBack();
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
