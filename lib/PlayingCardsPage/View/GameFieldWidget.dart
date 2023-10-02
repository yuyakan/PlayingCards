import 'package:flutter/material.dart';
import 'package:high_and_low/PlayingCardsPage/Model/CardsDeck/CardsDeckProvider.dart';
import 'package:high_and_low/PlayingCardsPage/Model/GameState/GameStateProvider.dart';
import 'package:high_and_low/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GameFieldWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _cardImageState = ref.watch(cardImageProvider);
    final _cardsDeckState = ref.watch(cardsDeckProvider);
    final Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        Stack(children: [
          Image.asset(
            EMPTY_CARDS,
            width: size.width * 0.25,
          ),
          Visibility(
            visible: !_cardsDeckState.isEmpty,
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
            _cardImageState,
            width: size.width * 0.25,
          ),
        ]),
      ],
    );
  }
}
