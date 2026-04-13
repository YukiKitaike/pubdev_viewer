---
name: flutter-tips
description: >
  Flutter/Dart 実践 Tips とコーディング規約。Dart 3.10+ dot shorthand・
  switch パターンマッチング・専用ウィジェット・マジックナンバー排除・
  宣言的リスト・テスト品質・lint 設定・型プロモーションのためのローカル変数化・
  String index アクセス回避など 23 項目。
  コード追加・レビュー・リファクタリング時に参照。
---

# Flutter / Dart 実践 Tips

> 原典: `docs/flutter_tips.md`（Lean Flutter Hacks by LeanCode ベース）
> このプロジェクトは Dart ^3.11.4 / Flutter 3.x を使用。全機能が利用可能。

---

## Dart 言語機能

### 1. switch パターンマッチング

if/else チェーンの代わりに switch 式を使う。

```dart
// NG
if (user is Admin) {
  return AdminPage();
} else if (user is User && user.verified) {
  return HomePage();
} else {
  return WelcomePage();
}

// OK
return switch (user) {
  Admin() => AdminPage(),
  User(verified: true) => HomePage(),
  _ => WelcomePage(),
};
```

**このプロジェクトでの適用例:**
```dart
// lib/core/widgets/error_view.dart
String get _title => switch (error) {
  NetworkException() => AppStrings.networkErrorTitle,
  ServerException() => AppStrings.serverErrorTitle,
  _ => AppStrings.unexpectedErrorTitle,
};
```

### 2. null チェックの `case final` パターン

`!= null` + `!` の代わりに `case final` を使うと安全かつ簡潔。

```dart
// Before
if (userData != null) {
  sendEvent(userData!.name);
}

// After
if (userData case final user?) {
  sendEvent(user.name);
}
```

### 3. Dart 3 デストラクチャリング

```dart
// Record destructuring
final (detail, publisher) = await (
  repository.getPackageDetail(name),
  repository.getPackagePublisher(name),
).wait;

// Object destructuring
final Point(:x, :y) = point;

// indexed + destructuring
...versions.indexed.map((entry) {
  final (index, v) = entry;
  return _VersionTimelineItem(version: v, isLatest: index == 0);
});
```

### 4. Dot Shorthand（Dart 3.10+）

コンテキストから型が推論できる場合に型名を省略して `.foo` と書ける。

```dart
// Enum 値
mainAxisSize: .min,          // MainAxisSize.min
crossAxisAlignment: .start,  // CrossAxisAlignment.start
shape: .circle,              // BoxShape.circle
overflow: .ellipsis,         // TextOverflow.ellipsis
fontWeight: .w700,           // FontWeight.w700

// Switch case
switch (e.type) {
  .connectionError: // DioExceptionType.connectionError
  .connectionTimeout:
  ...
}

// 等値比較（右辺のみ OK）
if (brightness == .dark) { }  // Brightness.dark
if (.dark == brightness) { }  // NG: 左辺は不可
```

**適用可能な型:** enum パラメータ、`FontWeight`、`DioExceptionType`、
`Brightness`、`ThemeMode`、`LaunchMode` 等。

**適用不可:** `EdgeInsets`（パラメータ型が `EdgeInsetsGeometry`）、
`BorderRadius`（`BorderRadiusGeometry`）、`Colors`（`Color` ではない）、
`Icons`（`IconData` ではない）、`Curves`（`Curve` ではない）。

### 5. 宣言的リストリテラル

命令的な `add`/`addAll` ではなく collection-if/for + spread で構築。

```dart
final output = [
  welcomeMessage,
  ?optionalMessage,  // Dart SDK >= 3.8: null-aware element
  if (encryptMessages)
    for (final m in messages) EncryptedMessage(m)
  else
    ...messages,
];
```

### 6. スプレッド演算子

```dart
packages: [
  ...current.packages,
  ...response.packages,
],
```

### 7. Extension Types

既存型にタイプセーフなアクセサを追加。Freezed モデルがある場合は不要。

```dart
extension type MessagePayload._(Map<String, dynamic> _payload)
    implements Map<String, dynamic> {
  String get sender => _payload['sender'] as String;
}
```

### 8. `let()` 拡張

null チェーンやメソッドチェーンを簡潔に書ける（必要な場合のみ導入）。

```dart
extension Let<T extends Object> on T {
  R let<R>(R Function(T) f) => f(this);
}

return AppAPI()
    .getAmountFor(id)
    ?.let(AppFormatters.currency)
    .toUpperCase()
    .let(PaymentLog.new);
```

---

## コード品質

### 9. 冗長な async/await を排除

単に Future を返すだけなら async/await は不要。

```dart
// NG
Future<User> getUser() async {
  return await repository.getUserDetails();
}

// OK
Future<User> getUser() => repository.getUserDetails();
```

### 10. ignore コメントには理由を添える

```dart
// NG
// ignore: cascade_invocations

// OK
// throw 式を含むアロー関数では cascade が使えないため個別代入する
// ignore: cascade_invocations
```

### 11. Logger の構造化パラメータ

エラーは文字列補間ではなく専用パラメータに渡す。

```dart
// NG
logger.severe('GET $url failed: $e');

// OK
logger.severe('GET $url failed', e);
```

### 12. マジックナンバーを名前付き定数に

```dart
// NG
scale: _pressed ? 0.97 : 1.0,
duration: const Duration(milliseconds: 150),

// OK
static const _pressedScale = 0.97;
static const _animationDuration = Duration(milliseconds: 150);

scale: _pressed ? _pressedScale : 1.0,
duration: _animationDuration,
```

### 13. ネスト三項演算子を switch 式に

```dart
// NG
return isBlocked
    ? BlockedWidget()
    : status == .foo1
        ? Foo1Widget()
        : LoadingWidget();

// OK
if (isBlocked) return BlockedWidget();
return switch (status) {
  .foo1 => Foo1Widget(),
  .foo2 when data != null => Foo2Widget(data),
  _ => LoadingWidget(),
};
```

### 14. 型プロモーションのためのローカル変数化

`widget.xxx.yyy` や `this.field` のような **getter 経由のアクセスは Dart の flow analysis で型プロモーションされない**。繰り返し書くと getter が毎回呼ばれ、nullable フィールドでは `!` アンラップが必須になる。冒頭で `final` 変数に束縛すれば以降の null チェックで非 null にプロモートされ、`!` が不要になる。

```dart
// NG: widget.xxx / this.xxx のまま使うと型プロモーションされず ! が必要
if (publisher.publisherId != null) {
  Text(publisher.publisherId!, ...); // ← ! 強制アンラップ
}

final url = this.url;  // NG: こう書かない
if (!isHttpsUrl(this.url)) return ...;
Uri.parse(this.url!);  // ← ! 強制アンラップ

// OK: ローカル変数化して null チェック → 型プロモーション
final publisherId = publisher.publisherId;
if (publisherId != null) {
  Text(publisherId, ...); // ← ! 不要
}

final url = this.url;
if (url == null || !isHttpsUrl(url)) return const SizedBox.shrink();
Uri.parse(url); // ← ! 不要（非 null に型プロモーション済み）
```

**このプロジェクトでの適用例:**

```dart
// package_list_tile.dart: build 冒頭で deep chain を分解
final package = widget.package;
final name = package.name;
final latest = package.latest;
final version = latest.version;
final description = latest.pubspec.description;
// 以降 name / version / description を直接参照
```

**適用が特に重要な箇所:**
- `widget.xxx.yyy.zzz` が同一 build 内で 2 回以上出る場合
- nullable フィールドの null チェック後に使用する場合（`!` を消せる）
- `asyncState.value` / `asyncState.requireValue.xxx` を繰り返す場合
- `final x = this.x;` で外部 getter を stable なローカルに束縛したい場合

**注意:** 通常関数の戻り値（例: `isHttpsUrl(url)`）は flow analysis の対象外。`x == null` のような **言語が解釈できる null 比較** を明示する必要がある。

### 15. 文字列への整数 index アクセスを避ける

`String[0]` は空文字列で `RangeError`、Unicode 合字・絵文字では壊れた表示になる。`core/utils/string_utils.dart` の `firstGrapheme()` ヘルパーを使う。

```dart
// NG: 空文字・合字・絵文字で壊れる
widget.package.name[0].toUpperCase()

// OK: 空文字はフォールバック、絵文字は合字単位で 1 グラフィム
import 'package:pubdev_viewer/core/utils/string_utils.dart';
firstGrapheme(name).toUpperCase()
```

### 16. Lint 設定

```yaml
# analysis_options.yaml
analyzer:
  plugins:
    - custom_lint  # riverpod_lint を有効化

# pubspec.yaml dev_dependencies
dev_dependencies:
  riverpod_lint: ^3.1.0
  custom_lint: ^0.8.1
```

---

## Flutter / Widget

### 17. 専用ウィジェットを使う

`Container` の代わりに目的に合ったウィジェットを選ぶ。

```dart
// NG → OK
Container(padding: p, child: c)          → Padding(padding: p, child: c)
Container(color: color, child: c)        → ColoredBox(color: color, child: c)
Container(decoration: d, child: c)       → DecoratedBox(decoration: d, child: c)
Container(width: w, height: h, child: c) → SizedBox(width: w, height: h, child: c)
Container(alignment: center, child: c)   → Center(child: c)

// decoration + padding の組み合わせ
Container(decoration: d, padding: p, child: c)
→ DecoratedBox(decoration: d, child: Padding(padding: p, child: c))

// width/height + decoration
Container(width: w, height: h, decoration: d)
→ SizedBox(width: w, height: h, child: DecoratedBox(decoration: d))
```

**例外:** `decoration` + `padding` + `width` の複合使用は `Container` 維持も可。

### 18. Sliver プレフィックス

Sliver を返すウィジェットには `Sliver` プレフィックスを付ける。

### 19. Widget クラス分離

ウィジェットを返すメソッド (`buildXxx()`) ではなく専用クラスに切り出す。

### 20. build() 内で重い計算をしない

`initState` / `didUpdateWidget` / notifier で事前計算する。

### 21. `compute()` で重い処理を別 Isolate に逃がす

UI フリーズ防止。

---

## テスト

### 22. マッチャーを活用

```dart
// NG → OK
expect(list, [])                    → expect(list, isEmpty)
expect(result.runtimeType == T, true) → expect(result, isA<T>())
expect(str.startsWith('Hi'), true)  → expect(str, startsWith('Hi'))
```

**このプロジェクトでは `package:checks` を優先:**
```dart
check(state.packages).length.equals(2);
check(state.packages[0].name).equals('http');
```

### 23. テストで不要な依存を排除

テスト対象以外のアプリ固有ウィジェットは使わない。

```dart
// NG: アプリ固有ウィジェットを使用
final testBody = AppText('Hello world');

// OK: シンプルな Flutter ウィジェット
final testBody = Text('Hello world');
```

---

## Dart 3.7+ 追加構文

### Wildcard Variables（Dart 3.7）

`_` を複数の同名変数として使える。値を束縛しないプレースホルダー。

```dart
var (_, _, value) = triple;

switch (point) {
  case (_, int y): print(y);
}

button.onPressed = (_) => doSomething();
```

### Dot Shorthand 制限事項まとめ

```dart
// NG: 式文の先頭
.log('Hello');

// OK: 変数代入・パラメータ・return・switch case
Status s = .running;
mainAxisSize: .min,
return .system;
case .dark:
```
