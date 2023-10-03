import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:high_and_low/constants.dart';
import 'package:high_and_low/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  //　指定のpathを表示しているAssetImageを見つける
  Finder findByAssetImage(String path) {
    return find.byWidgetPredicate((Widget widget) {
      if (!(widget is Image)) return false;
      if (!(widget.image is AssetImage)) return false;

      final assetImage = widget.image as AssetImage;
      return assetImage.keyName == path;
    });
  }

  testWidgets('initial Game Field', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    await tester.pumpWidget(ProviderScope(child: const MyApp()));

    expect(findByAssetImage(BACK_OF_CARDS), findsOneWidget);
    expect(findByAssetImage(EMPTY_CARD), findsOneWidget);

    expect(find.text("Open"), findsOneWidget);
    expect(find.text("Next"), findsNothing);
  });

  testWidgets('two click open and one click back',
      ((WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    await tester.pumpWidget(ProviderScope(child: const MyApp()));

    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.tap(find.text('Back'));
    await tester.pump();

    expect(findByAssetImage(BACK_OF_CARDS), findsOneWidget);
    expect(findByAssetImage(EMPTY_CARD), findsNothing);

    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Open'), findsNothing);
  }));
}
