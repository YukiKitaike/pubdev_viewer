import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pubdev_viewer/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('app launches and shows package list', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // パッケージ一覧画面が表示される
      expect(find.text('pub.dev Viewer'), findsOneWidget);
    });
  });
}
