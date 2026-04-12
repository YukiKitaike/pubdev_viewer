import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pubdev_viewer/app/theme.dart';
import 'package:pubdev_viewer/features/package_list/models/package_list_item.dart';
import 'package:pubdev_viewer/features/package_list/screens/widgets/package_list_tile.dart';

import '../../../../helpers/fixtures.dart';

PackageListItem _httpPackage() => PackageListItem.fromJson(
  Map<String, dynamic>.from(
    (packageListResponseJson['packages']! as List)[0] as Map,
  ),
);

PackageListItem _dioPackage() => PackageListItem.fromJson(
  Map<String, dynamic>.from(
    (packageListResponseJson['packages']! as List)[1] as Map,
  ),
);

/// タップ後のナビゲーション先を記録するテスト用 GoRouter を生成する。
GoRouter _createTestRouter(
  PackageListItem package, {
  required ValueChanged<String> onNavigate,
}) {
  return GoRouter(
    initialLocation: '/test',
    routes: [
      GoRoute(
        path: '/test',
        builder: (_, _) => Scaffold(
          body: PackageListTile(package: package),
        ),
      ),
      GoRoute(
        path: '/packages/:name',
        builder: (_, state) {
          onNavigate(state.pathParameters['name']!);
          return const SizedBox();
        },
      ),
    ],
  );
}

void main() {
  Widget createTestWidget(PackageListItem package) {
    return MaterialApp(
      theme: appLightTheme,
      home: Scaffold(
        body: PackageListTile(package: package),
      ),
    );
  }

  group('PackageListTile 表示', () {
    testWidgets('パッケージ名が表示される', (tester) async {
      await tester.pumpWidget(createTestWidget(_httpPackage()));
      await tester.pump();

      expect(find.text('http'), findsOneWidget);
    });

    testWidgets('バージョンバッジが v 接頭辞付きで表示される', (tester) async {
      await tester.pumpWidget(createTestWidget(_httpPackage()));
      await tester.pump();

      expect(find.text('v1.6.0'), findsOneWidget);
    });

    testWidgets('説明文が表示される', (tester) async {
      await tester.pumpWidget(createTestWidget(_httpPackage()));
      await tester.pump();

      expect(
        find.text('A composable API for HTTP requests.'),
        findsOneWidget,
      );
    });

    testWidgets('アバターにパッケージ名の先頭文字が大文字で表示される', (tester) async {
      await tester.pumpWidget(createTestWidget(_httpPackage()));
      await tester.pump();

      expect(find.text('H'), findsOneWidget);
    });

    testWidgets('シェブロンアイコンが表示される', (tester) async {
      await tester.pumpWidget(createTestWidget(_httpPackage()));
      await tester.pump();

      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });
  });

  group('PackageListTile アニメーション', () {
    testWidgets('押下時にスケールが 0.97 になる', (tester) async {
      await tester.pumpWidget(createTestWidget(_httpPackage()));
      await tester.pump();

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(InkWell)),
      );
      await tester.pump(const Duration(milliseconds: 200));

      final animatedScale = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );
      expect(animatedScale.scale, 0.97);

      // cancel でジェスチャーを終了し onTap（GoRouter 遷移）の発火を回避する。
      await gesture.cancel();
      await tester.pumpAndSettle();

      final restored = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );
      expect(restored.scale, 1.0);
    });
  });

  group('PackageListTile didUpdateWidget', () {
    testWidgets('異なるパッケージが割り当てられるとアバターの文字が更新される', (tester) async {
      await tester.pumpWidget(createTestWidget(_httpPackage()));
      await tester.pump();

      expect(find.text('H'), findsOneWidget);

      await tester.pumpWidget(createTestWidget(_dioPackage()));
      await tester.pump();

      expect(find.text('D'), findsOneWidget);
      expect(find.text('H'), findsNothing);
    });
  });

  group('PackageListTile タップ', () {
    testWidgets('タップでパッケージ詳細画面に遷移する', (tester) async {
      String? navigatedName;
      final testRouter = _createTestRouter(
        _httpPackage(),
        onNavigate: (name) => navigatedName = name,
      );

      await tester.pumpWidget(
        MaterialApp.router(
          theme: appLightTheme,
          routerConfig: testRouter,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(navigatedName, 'http');
    });
  });
}
