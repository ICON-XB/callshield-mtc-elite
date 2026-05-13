import 'package:flutter_test/flutter_test.dart';
import 'package:callshield/main.dart';

void main() {
  testWidgets('App basic smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MTCApp());
    expect(find.byType(MTCApp), findsOneWidget);
  });
}
