import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_core/common_widgets/action_button.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Action Button', () {
    testWidgets('Action Button Loading', (tester) async {
      await tester.pumpApp(
        ActionButton(
          isLoading: true,
          onPress: () {},
          color: Colors.blue,
          text: 'Hello',
          textStyle: const TextStyle(fontSize: 22),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });
    testWidgets('Action Button', (tester) async {
      await tester.pumpApp(
        ActionButton(
          isLoading: false,
          onPress: () {},
          color: Colors.blue,
          text: 'Hello',
          textStyle: const TextStyle(fontSize: 22),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(Text), findsOneWidget);
    });
    // testWidgets('Action Button onPress', (tester) async {
    //   var pressed = false;
    //   await tester.pumpApp(
    //     ActionButton(
    //       onPress: (_) {
    //         pressed = true;
    //       },
    //       isInitialState: true,
    //     ),
    //   );
    //   await tester.tap(find.text('Action'));
    //   expect(pressed, isTrue);
    // });
  });
}
