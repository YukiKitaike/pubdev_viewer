---
name: pubdev-navigation
description: >
  pubdev_viewer の GoRouter + go_router_builder による型安全ルーティング。
  新しい画面のルート追加・画面遷移の実装時に使用。
  TypedGoRoute・GoRouteData・パスパラメータ・ネストルートのパターンを提供する。
---

# ナビゲーション（pubdev_viewer）

## 構成

- `lib/app/router.dart` — ルート定義（TypedGoRoute + GoRouteData）
- `lib/app/router.g.dart` — go_router_builder が生成する `$appRoutes` と mixin
- `lib/app/app.dart` — `MaterialApp.router(routerConfig: router)` でアプリに接続

---

## ルート定義パターン

`@TypedGoRoute` アノテーションと `GoRouteData` サブクラスで型安全ルートを定義する。

```dart
// lib/app/router.dart
part 'router.g.dart';

// ネストルートは routes パラメータで親子関係を表現
@TypedGoRoute<PackageListRoute>(
  path: '/',
  routes: [
    TypedGoRoute<PackageDetailRoute>(
      path: 'packages/:name',
    ),
  ],
)
@immutable
class PackageListRoute extends GoRouteData with _$PackageListRoute {
  const PackageListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PackageListScreen();
  }
}

// パスパラメータは final フィールド + required コンストラクタ引数で受け取る
@immutable
class PackageDetailRoute extends GoRouteData with _$PackageDetailRoute {
  const PackageDetailRoute({required this.name});

  final String name;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PackageDetailScreen(packageName: name);
  }
}

final router = GoRouter(
  initialLocation: '/',
  routes: $appRoutes,
);
```

コード生成: `fvm dart run build_runner build -d`

---

## 新しいルートを追加する手順

1. `router.dart` に `GoRouteData` サブクラスを追加
2. 親ルートの `@TypedGoRoute` の `routes` リストにネスト定義を追加（トップレベルなら新しい `@TypedGoRoute` を追加）
3. `fvm dart run build_runner build -d` で `router.g.dart` を再生成
4. `with _$RouteName` mixin が自動生成される

```dart
// 例: 設定画面を追加する場合
@TypedGoRoute<SettingsRoute>(path: '/settings')
@immutable
class SettingsRoute extends GoRouteData with _$SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsScreen();
  }
}
```

---

## 画面遷移の方法

`go_router_builder` が生成する型安全メソッドを使う。URL 文字列は使わない。

```dart
// ✅ 型安全遷移（go_router_builder 生成メソッド）
PackageDetailRoute(name: 'http').go(context);

// ❌ URL 文字列を手書きしない
context.go('/packages/http');
```

---

## ウィジェットテストでの GoRouter

ウィジェット単体テストでは GoRouter は不要。`createTestApp()` で `MaterialApp` を使う。
GoRouter を含むナビゲーションテストのみ `GoRouter` + `MaterialApp.router` を使う。

```dart
// ナビゲーション先を検証するテスト用 GoRouter
GoRouter _createTestRouter(
  Widget home, {
  required ValueChanged<String> onNavigate,
}) {
  return GoRouter(
    initialLocation: '/test',
    routes: [
      GoRoute(
        path: '/test',
        builder: (_, _) => home,
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
```

---

## よくある間違い

```dart
// ❌ GoRouteData に mixin を忘れる（コード生成が効かない）
class MyRoute extends GoRouteData {
  // with _$MyRoute が必要
}

// ❌ パスパラメータ名とフィールド名が不一致
// path: 'packages/:packageName' なのに final String name; → 一致させる
```
