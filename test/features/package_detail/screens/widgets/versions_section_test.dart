import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/app/theme.dart';
import 'package:pubdev_viewer/core/strings/app_strings.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_detail_response.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_detail_version.dart';
import 'package:pubdev_viewer/features/package_detail/screens/widgets/versions_section.dart';

import '../../../../helpers/fixtures.dart';

List<PackageDetailVersion> _sortedVersions() {
  final detail = PackageDetailResponse.fromJson(
    Map<String, dynamic>.from(packageDetailResponseJson),
  );
  return [...detail.versions]
    ..sort((a, b) => b.published.compareTo(a.published));
}

void main() {
  Widget createTestWidget(List<PackageDetailVersion> versions) {
    return MaterialApp(
      theme: appLightTheme,
      home: Scaffold(
        body: SingleChildScrollView(
          child: VersionsSection(versions: versions),
        ),
      ),
    );
  }

  group('VersionsSection', () {
    testWidgets('Versions セクションヘッダーが表示される', (tester) async {
      await tester.pumpWidget(createTestWidget(_sortedVersions()));

      expect(find.text(AppStrings.sectionVersions), findsOneWidget);
    });

    testWidgets('全バージョン番号が表示される', (tester) async {
      await tester.pumpWidget(createTestWidget(_sortedVersions()));

      expect(find.text('1.6.0'), findsOneWidget);
      expect(find.text('1.5.0'), findsOneWidget);
    });

    testWidgets('最新バージョンに LATEST バッジが表示される', (tester) async {
      await tester.pumpWidget(createTestWidget(_sortedVersions()));

      expect(find.text(AppStrings.latestBadge), findsOneWidget);
    });

    testWidgets('公開日が表示される', (tester) async {
      await tester.pumpWidget(createTestWidget(_sortedVersions()));

      expect(find.text('2025-11-10'), findsOneWidget);
      expect(find.text('2025-06-01'), findsOneWidget);
    });

    testWidgets('Divider が表示される', (tester) async {
      await tester.pumpWidget(createTestWidget(_sortedVersions()));

      expect(find.byType(Divider), findsOneWidget);
    });
  });
}
