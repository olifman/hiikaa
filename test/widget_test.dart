import 'package:flutter_test/flutter_test.dart';
import 'package:hiikaa/main.dart';

void main() {
  testWidgets('Hiikaa app opens successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const HiikaaApp());
    await tester.pump();

    expect(find.byType(HiikaaApp), findsOneWidget);
  });
}
