import 'package:flutter_test/flutter_test.dart';
import 'package:xo_game/main.dart';

void main() {
  testWidgets('XO Game app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const XoGameApp());

    // Verify title and game modes are rendered
    expect(find.text('TIC TAC TOE'), findsOneWidget);
    expect(find.text('Pass & Play'), findsOneWidget);
    expect(find.text('vs AI (Casual)'), findsOneWidget);
    expect(find.text('vs AI (Unbeatable)'), findsOneWidget);
    expect(find.text('START MATCH'), findsOneWidget);
  });
}
