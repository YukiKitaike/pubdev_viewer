# コード品質 Tips

## 9. 冗長な async/await を排除

単に Future を返すだけなら async/await は不要。

```dart
// NG
Future<User> getUser() async {
  return await repository.getUserDetails();
}

// OK
Future<User> getUser() => repository.getUserDetails();
```

## 10. ignore コメントには理由を添える

```dart
// NG
// ignore: cascade_invocations

// OK
// throw 式を含むアロー関数では cascade が使えないため個別代入する
// ignore: cascade_invocations
```

## 11. Logger の構造化パラメータ

エラーは文字列補間ではなく専用パラメータに渡す。

```dart
// NG
logger.severe('GET $url failed: $e');

// OK
logger.severe('GET $url failed', e);
```

## 12. マジックナンバーを名前付き定数に

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

## 13. ネスト三項演算子を switch 式に

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

## 14. 型プロモーションのためのローカル変数化

`widget.xxx.yyy` や `this.field` のような **getter 経由のアクセスは Dart の flow analysis で型プロモーションされない**。冒頭で `final` 変数に束縛すれば `!` が不要になる。

```dart
// NG: widget.xxx / this.xxx のまま使うと型プロモーションされず ! が必要
if (publisher.publisherId != null) {
  Text(publisher.publisherId!, ...); // ← ! 強制アンラップ
}

// OK: ローカル変数化して null チェック → 型プロモーション
final publisherId = publisher.publisherId;
if (publisherId != null) {
  Text(publisherId, ...); // ← ! 不要
}
```

**このプロジェクトでの適用例:**

```dart
// package_list_tile.dart: build 冒頭で deep chain を分解
final package = widget.package;
final name = package.name;
final latest = package.latest;
final version = latest.version;
final description = latest.pubspec.description;
```

**適用が特に重要な箇所:**
- `widget.xxx.yyy.zzz` が同一 build 内で 2 回以上出る場合
- nullable フィールドの null チェック後に使用する場合（`!` を消せる）
- `asyncState.value` / `asyncState.requireValue.xxx` を繰り返す場合

## 15. 文字列への整数 index アクセスを避ける

`String[0]` は空文字列で `RangeError`、Unicode 合字・絵文字では壊れた表示になる。`core/utils/string_utils.dart` の `firstGrapheme()` ヘルパーを使う。

```dart
// NG: 空文字・合字・絵文字で壊れる
widget.package.name[0].toUpperCase()

// OK: 空文字はフォールバック、絵文字は合字単位で 1 グラフィム
import 'package:pubdev_viewer/core/utils/string_utils.dart';
firstGrapheme(name).toUpperCase()
```

## 16. Lint 設定

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
