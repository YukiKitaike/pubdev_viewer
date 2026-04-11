---
name: dart-new-syntax
description: >
  Dart 3.x の新しい言語機能・構文リファレンス。AI のトレーニングデータに反映されていない
  可能性のある新機能（Dot shorthands・Records・Patterns・Extension Types・
  Class modifiers・Switch式・Wildcard variables 等）を使う際に参照。
  Dart 3.0〜3.11 の変更点を網羅。
---

# Dart 新構文リファレンス（Dart 3.0〜3.11）

> **Dart SDK バージョン確認**: `fvm dart --version`  
> このプロジェクトは Dart ^3.11.4 を使用。全機能が利用可能。

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

## Dart 3.6 — 数値リテラルの区切り文字

アンダースコアで数値を読みやすくする。

```dart
const int million = 1_000_000;
const double pi = 3.141_592_653;
const int hex = 0xFF_EC_D0_8A;
const int binary = 0b1010_0110;
```

---

## Dart 3.3 — Extension Types（拡張型）

ゼロコストのコンパイル時型ラッピング。実行時にオブジェクトは作成されない。

```dart
// 不透過型（独自インターフェースのみ公開）
extension type UserId(int id) {
  bool get isValid => id > 0;
  String format() => 'user_$id';
}

UserId id = UserId(42);
print(id.format());  // 'user_42'
print(id + 1);       // ❌ コンパイルエラー（int のメソッドは非公開）

// 透過型（元の型のインターフェースを継承）
extension type NumberT(int value) implements int {
  // int のすべてのメソッドが使える
}

NumberT n = NumberT(5);
print(n + 3);  // ✅ 8（int として振る舞う）
```

実行時は完全に消去される → `is` / `as` は元の型に対して動作:

```dart
UserId id = UserId(1);
print(id is int);    // true
print(id is UserId); // true（extension type の is チェックも可）
```

---

## Dart 3.2 — プライベート final フィールドの型昇格

```dart
class MyWidget extends StatefulWidget {
  final String? _title;  // プライベート final

  // Dart 3.2 以前: null チェック後も String? のまま
  // Dart 3.2 以降: null チェック後は String に昇格
  String get title => _title!;  // 不要になる場合がある

  void show() {
    if (_title != null) {
      print(_title.length);  // ✅ Dart 3.2+ では String に昇格
    }
  }
}
```

---

## Dart 3.0 — Records（レコード）

匿名・不変・値型の集約型。複数値を返す関数に最適。

```dart
// 定義と使用
(String, int) person = ('Alice', 30);

// 位置フィールドへのアクセス
print(person.$1);  // 'Alice'
print(person.$2);  // 30

// 名前付きフィールド
({String name, int age}) user = (name: 'Bob', age: 25);
print(user.name);

// 関数の複数値返却
(String, int) userInfo() => ('Alice', 30);
var (name, age) = userInfo();  // パターンで分解

// このプロジェクトでも使用中
// lib/features/package_detail/notifiers/package_detail_notifier.dart
final (detail, publisher) = await (
  repository.getPackageDetail(name),
  repository.getPackagePublisher(name),
).wait;
```

### Records の等値性

同じ形状・同じ値のレコードは等しい（`==` と `hashCode` は自動定義）:

```dart
(1, 2) == (1, 2)  // true
({name: 'Alice'}) == ({name: 'Alice'})  // true
```

---

## Dart 3.0 — Patterns（パターンマッチング）

### Switch 式（値を返す）

```dart
// 式として値を返す。ケース間は , で区切る（; ではない）
String result = switch (status) {
  Status.running => 'Running',
  Status.stopped => 'Stopped',
  _ => 'Unknown',  // デフォルト
};

// 型パターン
String describe(Object obj) => switch (obj) {
  int n when n < 0 => 'negative',    // ガード句
  int n => 'positive int: $n',
  String s => 'string: $s',
  _ => 'other',
};
```

### Switch 文（パターン対応）

```dart
switch (shape) {
  case Circle(radius: var r):
    print('Circle r=$r');
  case Rectangle(width: var w, height: var h):
    print('Rect ${w}x${h}');
}
```

### if-case 文

```dart
// 単一パターンでの条件分岐
if (response case {'status': 'ok', 'data': var data}) {
  process(data);
}

// ガード句付き
if (value case int n when n > 0) {
  print('positive: $n');
}
```

### パターンの種類一覧

```dart
// ① リストパターン
var [first, second, ...rest] = list;
var [a, _, b] = [1, 2, 3];  // _ でスキップ

// ② マップパターン
if (json case {'name': String name, 'age': int age}) { }

// ③ レコードパターン
var (x, y) = point;
var (:name, :age) = user;  // 短縮形（フィールド名と変数名が同じ）

// ④ オブジェクトパターン（型チェック + フィールド分解）
if (shape case Circle(radius: var r)) {
  print(r);
}

// ⑤ 型パターン
if (value case int n) { }    // 型チェック + 変数束縛
if (value case int _) { }    // 型チェックのみ（値不要）

// ⑥ null チェックパターン
if (value case String? s?) { }  // null 以外にマッチし String に昇格

// ⑦ 論理 OR パターン
switch (x) {
  case 1 || 2 || 3:  // 複数値をまとめる
    print('small');
}

// ⑧ 関係パターン
switch (score) {
  case >= 90: print('A');
  case >= 70: print('B');
  case _: print('C');
}

// ⑨ ガード句（when）
switch (point) {
  case (int x, int y) when x == y:  // 追加条件
    print('diagonal');
}
```

---

## Dart 3.0 — Class Modifiers（クラス修飾子）

```dart
// abstract: インスタンス化不可、拡張・実装は可能
abstract class Animal { void makeSound(); }

// base: 他ライブラリからの実装を禁止（extends のみ可）
base class Vehicle { }
// base class のサブクラスも base/final/sealed でなければならない
base class Car extends Vehicle { }

// interface: 他ライブラリからの継承を禁止（implements のみ可）
interface class Logger { void log(String msg) {} }
class MyLogger implements Logger { ... }  // ✅
class BetterLogger extends Logger { ... }  // ❌ 他ライブラリから

// final: 継承・実装の両方を禁止（外部ライブラリから）
final class Result<T> { }

// sealed: 同一ライブラリ内のみサブクラス化可能
// → switch 式での網羅性チェックが有効
sealed class Shape { }
class Circle extends Shape { }
class Rectangle extends Shape { }

// switch で網羅性チェック（sealed だから可能）
String describe(Shape s) => switch (s) {
  Circle() => 'circle',
  Rectangle() => 'rectangle',
  // _ 不要（全サブタイプをカバーしているためコンパイラが確認）
};

// mixin class: mixin としても class としても使える
mixin class Serializable {
  String toJson() => '{}';
}
class MyModel with Serializable { }
var s = Serializable();  // クラスとしてインスタンス化も可
```

---

## Dart 3.0 — 変数パターンによる代入

```dart
// 変数の交換（temp 変数不要）
int a = 1, b = 2;
(a, b) = (b, a);  // a=2, b=1

// 複数変数の同時宣言
var (x, y, z) = (1, 2, 3);

// 名前付きフィールドの短縮形
final (:name, :age) = getUser();
// ↑ final name = getUser().name; final age = getUser().age; と同じ
```

---

## Dart 2.17〜 — Super Parameters（スーパーパラメータ）

```dart
// Before: 冗長な super() 呼び出し
class ErrorView extends StatelessWidget {
  final String message;
  const ErrorView({super.key, required this.message});
}

// Dart 2.17+: super.xxx で直接転送
class ErrorView extends StatelessWidget {
  final String message;
  const ErrorView({super.key, required this.message});
  //              ↑ key: key を super(key: key) に転送
}
```

---

## Dart 2.15〜 — `>>>` 符号なし右シフト

```dart
int x = -1;           // 0xFFFFFFFF
print(x >> 1);        // -1（符号拡張）
print(x >>> 1);       // 2147483647（ゼロ埋め）
```

---

## バージョン別機能マトリクス

| 機能 | 導入バージョン | 概要 |
|------|--------------|------|
| Dot shorthands | **3.10** | `.foo` で型名省略 |
| Wildcard variables | **3.7** | `_` を複数使用可能 |
| 数値区切り文字 | **3.6** | `1_000_000` |
| Extension types | **3.3** | ゼロコスト型ラッピング |
| Private final 型昇格 | **3.2** | null チェックで昇格 |
| Records | **3.0** | 匿名集約型・複数値返却 |
| Patterns | **3.0** | マッチング・分解構文 |
| Switch 式 | **3.0** | 値を返す switch |
| if-case | **3.0** | パターン付き if |
| Class modifiers | **3.0** | base/final/interface/sealed |
| sealed クラス | **3.0** | 網羅性チェック付き継承 |
| mixin class | **3.0** | mixin + class 兼用 |
| Super parameters | **2.17** | `super.xxx` |
| `>>>` 演算子 | **2.15** | 符号なし右シフト |
