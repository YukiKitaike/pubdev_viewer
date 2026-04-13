@Tags(['widget'])
library;

import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/strings/app_strings.dart';
import 'package:pubdev_viewer/core/widgets/loading_view.dart';

import '../../helpers/pump_app.dart';

void main() {
  Widget buildSubject() {
    return createTestApp(
      home: const Scaffold(body: LoadingView()),
    );
  }

  group('LoadingView a11y', () {
    testWidgets('CircularProgressIndicator に読み込み中の semanticsLabel が設定される', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.bySemanticsLabel(AppStrings.loading), findsOneWidget);
    });

    testWidgets('semanticsLabel が AppStrings.loading と一致する', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      check(indicator.semanticsLabel).equals(AppStrings.loading);
    });

    testWidgets('テキストコントラストガイドラインに適合する', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });
  });
}
