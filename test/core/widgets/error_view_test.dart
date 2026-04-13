@Tags(['widget'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/error/app_exception.dart';
import 'package:pubdev_viewer/core/strings/app_strings.dart';
import 'package:pubdev_viewer/core/widgets/error_view.dart';

import '../../helpers/pump_app.dart';

void main() {
  Widget buildSubject({
    required Object error,
    required VoidCallback onRetry,
  }) {
    return createTestApp(
      home: Scaffold(
        body: ErrorView(error: error, onRetry: onRetry),
      ),
    );
  }

  group('ErrorView', () {
    testWidgets('NetworkException でネットワークエラーのタイトルとメッセージが表示される', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(error: const NetworkException(), onRetry: () {}),
      );

      expect(find.text(AppStrings.networkErrorTitle), findsOneWidget);
      expect(find.text(AppStrings.networkErrorMessage), findsOneWidget);
    });

    testWidgets('ServerException でサーバーエラーのタイトルとメッセージが表示される', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(error: const ServerException(500), onRetry: () {}),
      );

      expect(find.text(AppStrings.serverErrorTitle), findsOneWidget);
      expect(find.text(AppStrings.serverErrorMessage), findsOneWidget);
    });

    testWidgets('未知の例外で予期しないエラーのタイトルとメッセージが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildSubject(error: Exception('unknown'), onRetry: () {}),
      );

      expect(find.text(AppStrings.unexpectedErrorTitle), findsOneWidget);
      expect(find.text(AppStrings.unexpectedErrorMessage), findsOneWidget);
    });

    testWidgets('リトライボタンをタップすると onRetry が呼ばれる', (WidgetTester tester) async {
      var retryCount = 0;

      await tester.pumpWidget(
        buildSubject(
          error: const NetworkException(),
          onRetry: () => retryCount++,
        ),
      );

      await tester.tap(find.text(AppStrings.retry));
      expect(retryCount, 1);
    });

    testWidgets('cloud_off_rounded アイコンが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildSubject(error: const NetworkException(), onRetry: () {}),
      );

      expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);
    });
  });

  group('ErrorView a11y', () {
    testWidgets('装飾アイコンはセマンティクスから除外される', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        buildSubject(error: const NetworkException(), onRetry: () {}),
      );

      // cloud_off_rounded アイコン自体は描画されているが、ExcludeSemantics
      // により Semantics ラベルとしては露出しない。タイトル・メッセージ・
      // リトライボタンでエラー状況は伝達される。
      expect(find.bySemanticsLabel('cloud off rounded'), findsNothing);
      handle.dispose();
    });

    testWidgets('リトライボタンが labeled タップターゲットガイドラインに適合する', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        buildSubject(error: const NetworkException(), onRetry: () {}),
      );

      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      handle.dispose();
    });
  });
}
