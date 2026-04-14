# Dart 言語機能 Tips

## 1. switch パターンマッチング

if/else チェーンの代わりに switch 式を使う。

```dart
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

## 2. null チェックの `case final` パターン

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

## 3. Dart 3 デストラクチャリング

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

## 4. Dot Shorthand（Dart 3.10+）

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

**適用可能な型:** enum パラメータ、`FontWeight`、`DioExceptionType`、`Brightness`、`ThemeMode`、`LaunchMode` 等。

**適用不可:** `EdgeInsets`（パラメータ型が `EdgeInsetsGeometry`）、`BorderRadius`（`BorderRadiusGeometry`）、`Colors`（`Color` ではない）、`Icons`（`IconData` ではない）、`Curves`（`Curve` ではない）。

### Dot Shorthand 制限事項

```dart
// NG: 式文の先頭
.log('Hello');

// OK: 変数代入・パラメータ・return・switch case
Status s = .running;
mainAxisSize: .min,
return .system;
case .dark:
```

## 5. 宣言的リストリテラル

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

## 6. Wildcard Variables（Dart 3.7）

`_` を複数の同名変数として使える。値を束縛しないプレースホルダー。

```dart
var (_, _, value) = triple;

switch (point) {
  case (_, int y): print(y);
}

button.onPressed = (_) => doSomething();
```
