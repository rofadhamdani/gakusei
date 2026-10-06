import "package:flutter_test/flutter_test.dart";
import "package:flutter/services.dart";
import "package:gakusei/app.dart";
import "package:gakusei/core/router/app_router.dart";
import "package:supabase_flutter/supabase_flutter.dart";

void main() {
  setUpAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel("plugins.flutter.io/shared_preferences"),
          (call) async => <String, Object>{},
        );
    await Supabase.initialize(
      url: "https://example.supabase.co",
      publishableKey: "test-publishable-key",
    );
  });

  testWidgets("App loads", (tester) async {
    await tester.pumpWidget(const App());
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
    expect(find.byType(App), findsOneWidget);
  });

  testWidgets("Unauthenticated users are redirected to sign in", (
    tester,
  ) async {
    await tester.pumpWidget(const App());
    AppRouter.router.go("/");
    await tester.pumpAndSettle();
    expect(find.text("Selamat Datang Kembali"), findsOneWidget);
  });
}
