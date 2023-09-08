import 'package:high_and_low/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final cardImageProvider = StateProvider((ref) => EMPTY_CARD);

final isUsedJokerProvider = StateProvider((ref) => false);

final isVisibleBackButtonProvider = StateProvider((ref) => false);

final isVisibleOpenButtonProvider = StateProvider((ref) => true);
