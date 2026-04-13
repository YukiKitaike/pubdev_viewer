@Tags(['widget'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/strings/app_strings.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_detail_version.dart';
import 'package:pubdev_viewer/features/package_detail/screens/widgets/versions_section.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  Widget createTestWidget(List<PackageDetailVersion> versions) {
    return createTestApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: VersionsSection(versions: versions),
        ),
      ),
    );
  }

  group('VersionsSection', () {
    testWidgets('Versions セクションヘッダーが表示される', (tester) async {
      await tester.pumpWidget(createTestWidget(sortedVersions()));

      expect(find.text(AppStrings.sectionVersions), findsOneWidget);
    });

    testWidgets('全バージョン番号が表示される', (tester) async {
      await tester.pumpWidget(createTestWidget(sortedVersions()));

      expect(find.text('1.6.0'), findsOneWidget);
      expect(find.text('1.5.0'), findsOneWidget);
    });

    testWidgets('最新バージョンに LATEST バッジが表示される', (tester) async {
      await tester.pumpWidget(createTestWidget(sortedVersions()));

      expect(find.text(AppStrings.latestBadge), findsOneWidget);
    });

    testWidgets('公開日が表示される', (tester) async {
      await tester.pumpWidget(createTestWidget(sortedVersions()));

      expect(find.text('2025-11-10'), findsOneWidget);
      expect(find.text('2025-06-01'), findsOneWidget);
    });

    testWidgets('Divider が表示される', (tester) async {
      await tester.pumpWidget(createTestWidget(sortedVersions()));

      expect(find.byType(Divider), findsOneWidget);
    });
  });

  group('VersionsSection a11y', () {
    testWidgets('最新バージョンの Semantics label に「最新バージョン」が含まれる', (tester) async {
      await tester.pumpWidget(createTestWidget(sortedVersions()));
      await tester.pump();

      expect(
        find.bySemanticsLabel(
          RegExp('${AppStrings.latestVersionLabel} 1\\.6\\.0、公開日 2025-11-10'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('過去バージョンの Semantics label は「バージョン」で読み上げられる', (tester) async {
      await tester.pumpWidget(createTestWidget(sortedVersions()));
      await tester.pump();

      expect(
        find.bySemanticsLabel(
          RegExp(r'^バージョン 1\.5\.0、公開日 2025-06-01$'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('タイムラインドット・バージョン番号などの装飾要素はセマンティクスから除外される', (tester) async {
      await tester.pumpWidget(createTestWidget(sortedVersions()));
      await tester.pump();

      // 個別のバージョン文字列テキストは ExcludeSemantics で除外され、
      // 親 Semantics の統合 label としてのみ読み上げられる。
      expect(find.bySemanticsLabel('1.6.0'), findsNothing);
      expect(find.bySemanticsLabel('1.5.0'), findsNothing);
    });
  });
}
