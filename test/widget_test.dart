import "package:flutter_test/flutter_test.dart";
import "package:gakusei/app.dart";

void main() {
  testWidgets("App loads", (tester) async {
    await tester.pumpWidget(const App());
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
    expect(find.byType(App), findsOneWidget);
  });
}
