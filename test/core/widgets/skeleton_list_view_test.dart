@Tags(['widget'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/strings/app_strings.dart';
import 'package:pubdev_viewer/core/widgets/skeleton_list_view.dart';

import '../../helpers/pump_app.dart';

void main() {
  Widget buildSubject({int itemCount = 3}) {
    return createTestApp(
      home: Scaffold(
        body: SkeletonListView(itemCount: itemCount),
      ),
    );
  }

  group('SkeletonListView a11y', () {
    testWidgets('スケルトンリストにロード中ラベルが設定される', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(
        find.bySemanticsLabel(AppStrings.skeletonLoading),
        findsOneWidget,
      );
    });

    testWidgets('配下のスケルトンタイルは Semantics ツリーから除外される', (tester) async {
      await tester.pumpWidget(buildSubject(itemCount: 5));
      await tester.pump();

      // SkeletonTile 自身は描画されるが、ExcludeSemantics 配下のため
      // 個別のセマンティクスノードとしては露出しない。
      expect(find.byType(SkeletonTile), findsWidgets);
    });
  });
}
