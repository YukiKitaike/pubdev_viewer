# ルーティング・ナビゲーション

> 対象セクション: ルーティング
> レビュー日: 2026-04-11

## サマリー

| 重要度 | 件数 |
|--------|------|
| Critical | 0 |
| Important | 0 |
| Minor | 2 |
| Good | 3 |

ルーティングは flutter.md のガイドラインに高い水準で準拠。`go_router` + `go_router_builder` による型安全なルーティングが正しく実装されている。

## 指摘事項

### [Minor] router がグローバル変数として定義されている

- **対象ファイル:** `lib/app/router.dart:30-34`
- **ガイドライン参照:** flutter.md > 状態管理 > 依存性の注入（Riverpod の Ref をサービスロケーターとして使用）
- **現状:**
  ```dart
  final router = GoRouter(
    initialLocation: '/',
    routes: $appRoutes,
  );
  ```
  `router` がトップレベル変数として定義されている。プロジェクト内の他のインフラ（API クライアント、Repository 等）は全て Riverpod Provider で管理されており、`router` だけが例外。
- **リスク:** テスト時にルーターの差し替えが困難。アプリ全体の DI 一貫性が損なわれる。ただし `GoRouter` は `MaterialApp.router` に直接渡す設計のため、実用上の問題は軽微。
- **推奨対応:** Riverpod Provider として定義することで一貫性を向上できる。ただし、`GoRouter` のライフサイクル管理を考慮すると、現状のグローバル変数でも実用上は問題ない。
  ```dart
  @riverpod
  GoRouter router(Ref ref) {
    return GoRouter(
      initialLocation: '/',
      routes: $appRoutes,
    );
  }
  ```

### [Minor] ダイアログ関連パッケージの未導入

- **対象ファイル:** `pubspec.yaml`
- **ガイドライン参照:** flutter.md > ルーティング > Navigator（`animations` パッケージの `showModal` / `adaptive_dialog` パッケージ）
- **現状:** flutter.md で推奨されている以下のパッケージが未導入:
  - `animations` パッケージ（`showModal` によるダイアログ表示）
  - `adaptive_dialog` パッケージ（シンプルなシステムダイアログ）
- **リスク:** 現状ダイアログ機能がないため即座の問題はない。将来ダイアログ追加時の参照情報として記録。
- **推奨対応:** ダイアログ機能の実装時に導入を検討する。

### [Good] go_router + go_router_builder による型安全ルーティング

- **説明:** `@TypedGoRoute` アノテーションでルート定義が型安全に生成されている。`PackageDetailRoute(name: package.name).go(context)` のように、型安全なナビゲーションが全箇所で使用されている。

### [Good] ルートパラメータの型安全な受け渡し

- **説明:** `PackageDetailRoute` の `name` パラメータが `String` 型として定義され、URL パスパラメータ `:name` と自動的にマッピングされている。ランタイムでの文字列操作やキャストが不要。

### [Good] @immutable アノテーションの適用

- **説明:** `PackageListRoute` と `PackageDetailRoute` の両方に `@immutable` アノテーションが付与されており、ルートデータの不変性が保証されている。

## 次のアクション

- [ ] （優先度低）`router` を Riverpod Provider に移行することを検討
