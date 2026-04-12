@Tags(['widget'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/strings/app_strings.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_detail_response.dart';
import 'package:pubdev_viewer/features/package_detail/screens/widgets/overview_section.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  Widget createTestWidget(PackageDetailResponse detail) {
    return createTestApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: OverviewSection(detail: detail),
        ),
      ),
    );
  }

  group('OverviewSection', () {
    testWidgets('Overview セクションヘッダーが表示される', (tester) async {
      await tester.pumpWidget(createTestWidget(detailResponse()));

      expect(find.text(AppStrings.sectionOverview), findsOneWidget);
    });

    testWidgets('パッケージの説明文が表示される', (tester) async {
      await tester.pumpWidget(createTestWidget(detailResponse()));

      expect(
        find.text('A composable API for HTTP requests.'),
        findsOneWidget,
      );
    });

    testWidgets('Divider が表示される', (tester) async {
      await tester.pumpWidget(createTestWidget(detailResponse()));

      expect(find.byType(Divider), findsOneWidget);
    });
  });
}
