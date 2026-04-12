import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/app/theme.dart';
import 'package:pubdev_viewer/core/strings/app_strings.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_detail_response.dart';
import 'package:pubdev_viewer/features/package_detail/screens/widgets/overview_section.dart';

import '../../../../helpers/fixtures.dart';

PackageDetailResponse _detail() => PackageDetailResponse.fromJson(
  Map<String, dynamic>.from(packageDetailResponseJson),
);

void main() {
  Widget createTestWidget(PackageDetailResponse detail) {
    return MaterialApp(
      theme: appLightTheme,
      home: Scaffold(
        body: SingleChildScrollView(
          child: OverviewSection(detail: detail),
        ),
      ),
    );
  }

  group('OverviewSection', () {
    testWidgets('Overview セクションヘッダーが表示される', (tester) async {
      await tester.pumpWidget(createTestWidget(_detail()));

      expect(find.text(AppStrings.sectionOverview), findsOneWidget);
    });

    testWidgets('パッケージの説明文が表示される', (tester) async {
      await tester.pumpWidget(createTestWidget(_detail()));

      expect(
        find.text('A composable API for HTTP requests.'),
        findsOneWidget,
      );
    });

    testWidgets('Divider が表示される', (tester) async {
      await tester.pumpWidget(createTestWidget(_detail()));

      expect(find.byType(Divider), findsOneWidget);
    });
  });
}
