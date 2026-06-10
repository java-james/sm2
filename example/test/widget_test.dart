import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('updates review state from selected quality', (tester) async {
    await tester.pumpWidget(const SpacedRepetitionExample());

    expect(find.text('Review result'), findsOneWidget);
    expect(find.text('0 days'), findsOneWidget);
    expect(find.text('Not reviewed'), findsOneWidget);

    await tester.tap(find.text('5'));
    await tester.pump();

    expect(find.text('1 days'), findsOneWidget);
    expect(find.text('1'), findsWidgets);
    expect(find.text('2.60'), findsOneWidget);
    expect(find.text('5'), findsWidgets);
  });
}
