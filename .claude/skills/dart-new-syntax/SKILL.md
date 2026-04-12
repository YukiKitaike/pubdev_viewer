---
name: dart-new-syntax
description: >
  Dart 3.7+ の新機能リファレンス。AI のトレーニングデータに反映されていない
  可能性のある Dot Shorthands（3.10+）と Wildcard Variables（3.7）を提供。
  Dart 3.0〜3.6 の機能は `/dart-modern-features` グローバルスキル参照。
---

# Dart 新構文リファレンス（Dart 3.7+）

> **Dart SDK バージョン確認**: `fvm dart --version`
> このプロジェクトは Dart ^3.11.4 を使用。全機能が利用可能。
> Dart 3.0〜3.6 の機能（Records・Patterns・Switch式・Extension Types・Class modifiers 等）は
> `/dart-modern-features` グローバルスキル参照。

---

## Dart 3.10 / 3.11 — Dot Shorthands（ドットショートハンド）

**最も新しい機能。AI が知らない可能性が高い。**

コンテキストから型が推論できる場合に型名を省略して `.foo` と書ける。

### 列挙型（Enum）

```dart
// Before
Status current = Status.running;
setState(() => _status = Status.stopped);

// After
Status current = .running;
setState(() => _status = .stopped);
```

### 名前付きコンストラクタ

```dart
// Before
Point origin = Point.origin();
Widget w = Container.empty();

// After
Point origin = .origin();
Widget w = .empty();
```

### デフォルトコンストラクタ（`.new()`）

```dart
// Before
ScrollController controller = ScrollController();
List<int> list = List.filled(5, 0);

// After
ScrollController controller = .new();
List<int> list = .filled(5, 0);
```

### 静的メンバー・静的メソッド

```dart
// Before
int port = int.parse('8080');
BigInt zero = BigInt.zero;

// After
int port = .parse('8080');
BigInt zero = .zero;
```

### チェーン操作（メソッドチェーン可能）

```dart
String result = .fromCharCode(72).toLowerCase();
// ↑ String.fromCharCode(72).toLowerCase() と同じ
```

### Switch 式・if-case での使用

```dart
Status s = switch (input) {
  'run' => .running,   // Status.running
  'stop' => .stopped,  // Status.stopped
  _ => .unknown,
};

if (color case .red || .orange) {
  print('warm color');
}
```

### 制限事項

```dart
// ❌ 等値比較の左辺には使えない
if (.green == color) { }   // コンパイルエラー
if (color == .green) { }   // ✅ 右辺ならOK

// ❌ 式文の先頭には使えない
.log('Hello');  // NG（文の先頭）

// ✅ 変数代入なら OK
final _ = .log('Hello');
```

**Language version requirement:** Dart 3.10 以上

---

## Dart 3.7 — Wildcard Variables（ワイルドカード変数）

`_` を複数の同名変数として使える。値を束縛しないプレースホルダー。

```dart
// Before: 変数名が衝突するため使えなかった
var (_, value) = record;

// Dart 3.7: 複数の _ が同スコープに存在できる
var (_, _, value) = triple;

// パターンの未使用フィールドを無視
switch (point) {
  case (_, int y):  // x は不要
    print(y);
}

// 関数の未使用パラメータ
button.onPressed = (_) => doSomething();  // 引数を無視

// for ループのインデックス不要時
for (final _ in list) { count++; }
```

---

## プロジェクトでの活用例

このアプリで実際に Dot Shorthand が使われている箇所:

```dart
// lib/features/package_list/screens/package_list_screen.dart
// テーマモード切り替えアイコンの選択
icon: Icon(
  switch (themeMode) {
    .dark => Icons.light_mode_outlined,
    _ => Icons.dark_mode_outlined,
  },
),
```

```dart
// lib/features/package_detail/screens/package_detail_screen.dart
// プラットフォーム別の ScrollPhysics 切り替え
physics: switch (Theme.of(context).platform) {
  .iOS => const BouncingScrollPhysics(
    parent: AlwaysScrollableScrollPhysics(),
  ),
  _ => const ClampingScrollPhysics(
    parent: AlwaysScrollableScrollPhysics(),
  ),
},
```

---

## バージョン別機能マトリクス

| 機能 | 導入バージョン | 概要 |
|------|--------------|------|
| Dot shorthands | **3.10** | `.foo` で型名省略 |
| Wildcard variables | **3.7** | `_` を複数使用可能 |
