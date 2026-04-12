# Lean Flutter Hacks by LeanCode

Flutter / Dart の実践的な Tips 集。

---

## Dart 言語機能

### 1. Pattern matching with `switch`

if/else チェーンの代わりに switch パターンマッチングを使うと簡潔になる。

```dart
// IF/ELSE BLOCKS
if (user is Admin) {
  return AdminPage();
} else if (user is User && user.verified) {
  return HomePage();
} else {
  return WelcomePage();
}

// SWITCH WITH PATTERN MATCHING
return switch (user) {
  Admin() => AdminPage(),
  User(verified: true) => HomePage(),
  _ => WelcomePage(),
};
```

### 2. Checking null in conditions

`!= null` チェック + `!` 演算子の代わりに `case final` パターンを使うと安全かつ簡潔。

```dart
// BEFORE
if (userData != null) {
  sendEvent(userData!.name);
}

// AFTER
if (userData case final user?) {
  sendEvent(user.name);
}
```

### 3. Quick unpack with Dart 3 destructuring

Dart 3 のデストラクチャリングでオブジェクト・Record・List を一行で展開できる。

```dart
final point = Point(x: 4, y: 5);

// Old way: Access properties individually
final x = point.x;
final y = point.y;

// With destructuring - unpack in one line!
final Point(:x, :y) = point;

// Record destructuring
final coordinates = (4, 5);
final (x, y) = coordinates;

// List destructuring with rest pattern
final pointList = [4, 5, 6, 7];
final [x, y, ...] = pointList;

// Now you can use:
print('coordinates: ($x, $y)'); // "coordinates: (4, 5)"
```

### 4. Cleaner code with Dart 3.10 dot shorthand feature

Dart 3.10 の dot shorthand で型名を省略し、コードを短くできる。

```dart
// Traditional way
AppScaffold(
  padding: const EdgeInsets.all(16),
  header: const AppHeader(
    icon: AppIcon.home,
    title: 'Dashboard page',
  ),
  backgroundColor: switch (brightness) {
    Brightness.dark => AppColor.black,
    Brightness.light => AppColor.white,
  },
  body: Column(
    mainAxisSize: MainAxisSize.min,
    children: [],
  ),
);

// With Dart 3.10 dot shorthand feature
AppScaffold(
  padding: const .all(16),
  header: const .new(
    icon: .home,
    title: 'Dashboard page',
  ),
  backgroundColor: switch (brightness) {
    .dark => .black,
    .light => .white,
  },
  body: Column(
    mainAxisSize: .min,
    children: [],
  ),
);
```

### 5. Use declarative list literals

命令的な `add` / `addAll` の代わりに、collection-if / collection-for を使って宣言的にリストを構築する。

```dart
// INSTEAD OF:
final output = <Message>[];
output.add(welcomeMessage);
if (optionalMessage != null) {
  output.add(optionalMessage!);
}
if (encryptMessages) {
  output.addAll(messages.map((m) => EncryptedMessage(m)));
} else {
  output.addAll(messages);
}

// USE:
final output = [
  welcomeMessage,
  ?optionalMessage, // Only Dart SDK >= 3.8.0
  if (encryptMessages)
    for (final m in messages) EncryptedMessage(m)
  else
    ...messages,
];
```

### 6. Use Dart spread operator to compose lists

スプレッド演算子 `...` でリストを合成すると、命令的な追加処理よりも読みやすい。

```dart
// Implicit list composition
final data = api.fetchProfile();
body: GetProfileResponse(
  headers: [
    ...AppHttpHeader.defaultHeaders,
    AppHttpHeader.account(accountId),
    AppHttpHeader.user(userId),
    ...?AppHttpHeader.optionalHeaders(config) ?? [],
    ...AppHttpHeader.serviceHeaders(),
    if (productId != null) AppHttpHeader.product(productId),
  ],
);

// Explicit list composition (spread operator)
final data = api.fetchProfile();
body: GetProfileResponse(
  headers: [
    ...AppHttpHeader.defaultHeaders,
    AppHttpHeader.account(accountId),
    AppHttpHeader.user(userId),
    ...?AppHttpHeader.optionalHeaders(config),
    ...AppHttpHeader.serviceHeaders(),
    if (productId != null) AppHttpHeader.product(productId),
  ],
);
```

### 7. Composition over inheritance with Dart Extension Types

Extension Types を使うと、Map などの既存型にタイプセーフなアクセサを追加でき、継承よりも柔軟。

```dart
final messagePayload = {
  'sender': 'Alice',
  'text': 'Hello world!',
  'timestamp': 1721000000,
};

extension type MessagePayload._(Map<String, dynamic> _payload)
    implements Map<String, dynamic> {
  // This "implements" allows using Message also as a Map

  String get sender => _payload['sender'] as String;
  String get text => _payload['text'] as String;
  int get timestamp => _payload['timestamp'] as int;

  bool get isLong => text.length > 100;
}

void onMessageReceived(Map<String, dynamic> payload) {
  final message = MessagePayload(payload);
  print(message.text); // "Hello world!"
}
```

### 8. Use `let()` extension to reduce boilerplate

Kotlin スタイルの `let()` 拡張で null チェーンやメソッドチェーンを簡潔に書ける。

```dart
// Copy-paste this extension into your workspace
extension Let<T extends Object> on T {
  R let<R>(R Function(T) f) => f(this);
}

// Unnecessarily long
final amount = AppAPI().getAmountFor(id);

String? formattedAmount;
if (amount != null) {
  formattedAmount = AppFormatters
      .currency(amount)
      .toUpperCase();
}

return formattedAmount == null
    ? null
    : PaymentLog(formattedAmount);

// Simple and short with .let() extension
return AppAPI()
    .getAmountFor(id)
    ?.let(AppFormatters.currency)
    .toUpperCase()
    .let(PaymentLog.new);
```

---

## コード品質

### 9. Avoid redundant async/await

単に Future を返すだけなら `async` / `await` は不要。そのまま Future を返せばオーバーヘッドが減る。

```dart
// Redundant async/await
Future<User> getUser() async {
  return await repository.getUserDetails();
}

// Remove async/await
Future<User> getUser() {
  return repository.getUserDetails();
}

// Even shorter with arrow syntax
Future<User> getUser() => repository.getUserDetails();
```

### 10. Explain code analysis ignores

`// ignore:` コメントを書くときは、なぜ無視するのか理由を添える。

```dart
// BAD: No explanation
// ignore: use_design_system_colors
color: Colors.black

// GOOD: Explanation added
// Solid black color required - doesn't depend on the theme
// ignore: use_design_system_colors
color: Colors.black
```

### 11. Let your logger do its job

エラーとスタックトレースは文字列補間ではなく、logger の専用パラメータに渡す。

```dart
// INSTEAD OF:
logger.warning('Something went wrong! $error $stackTrace');

// DO:
logger.warning('Something went wrong!', error, stackTrace);
```

### 12. Replace "magic numbers" with named constants

マジックナンバーを名前付き定数に置き換えると、意図が明確になり保守性が上がる。

```dart
// Magic numbers
@override
Widget build(BuildContext context) {
  final scaleFactor = MediaQuery.textScaleFactorOf(context).scaleFontSize;

  return Text(
    text,
    maxLines: scaleFactor > 1.4 ? 1 : 3,
  );
}

// Extracted const values
static const _accessibilityScaleThreshold = 1.4;
static const _largeScaleMaxLines = 1;
static const _defaultMaxLines = 3;

@override
Widget build(BuildContext context) {
  final scaleFactor = MediaQuery.textScaleFactorOf(context).scaleFontSize;

  return Text(
    text,
    maxLines: scaleFactor > _accessibilityScaleThreshold
        ? _largeScaleMaxLines
        : _defaultMaxLines,
  );
}
```

### 13. Readable alternatives to nested ternary operators

ネストした三項演算子は可読性が低い。if 文 + switch 式に分割すると明快。

```dart
// Overloaded ternary operator
return isBlocked
    ? BlockedWidget()
    : status == .foo1
        ? Foo1Widget()
        : status == .foo2 && data != null
            ? Foo2Widget(data)
            : status == .foo3
                ? Foo3Widget()
                : LoadingWidget();

// Complex conditions handled better
if (isBlocked) {
  return BlockedWidget();
}

return switch (status) {
  .foo1 => Foo1Widget(),
  .foo2 when data != null => Foo2Widget(data),
  .foo3 => Foo3Widget(),
  _ => LoadingWidget(),
};
```

### 14. Solid code analysis setup matters more than you think

lint パッケージを適切にセットアップし、チームの品質基準を自動で維持する。

```yaml
dev_dependencies:
  # Enhanced lint rules based on `flutter_lints`, extended with custom rules and
  # quick fixes by LeanCode team, targeting issues like enforcing proper Design
  # System adaptation. Requires additional `custom_lint` dependency to run but
  # will be migrated to Dart analysis server plugin soon.
  leancode_lints: ^x.y.z
  custom_lint: ^x.y.z

  # Recommended baseline lints for Flutter apps if `leancode_lints` can't be used
  flutter_lints: ^x.y.z

  # Must-have if you're using Riverpod. Helps avoid subtle and poorly documented
  # pitfalls.
  riverpod_lint: ^x.y.z
```

---

## Flutter / Widget Tips

### 15. Use dedicated widgets

汎用の `Container` の代わりに、目的に合った専用ウィジェットを使う。

```dart
// Before:
return Container(padding: EdgeInsets.all(24), child: ...);
return Container(color: Colors.white, child: ...);
return Container(decoration: decoration, ..., child: ...);
return Container(alignment: Alignment.center, child: ...);
return Container(width: ..., height: ..., child: ...);

// After:
return Padding(padding: EdgeInsets.all(24), child: ...);
return ColoredBox(color: Colors.white, child: ...);
return DecoratedBox(decoration: decoration, ..., child: ...);
return Center(child: ...);
return SizedBox(width: ..., height: ..., child: ...);
```

### 16. Prefix your slivers to avoid mix-ups

Sliver を返すウィジェットには `Sliver` プレフィックスを付け、通常ウィジェットとの混同を防ぐ。

```dart
// INSTEAD OF:
class DashboardAppBar extends StatelessWidget {
  const DashboardAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(...);
  }
}

// USE:
class SliverDashboardAppBar extends StatelessWidget {
  const SliverDashboardAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(...);
  }
}
```

### 17. Prefer widget classes over widget-returning methods

ウィジェットを返すメソッドではなく、専用のウィジェットクラスを作る。Flutter の再構築最適化が効く。

```dart
// Don't use widget-returning methods
Widget buildHeader() => Padding(
  padding: const EdgeInsets.all(16),
  child: Text('Hello world!', style: AppTextStyle.header),
);

// Declare a dedicated widget class instead
class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text('Hello world!', style: AppTextStyle.header),
    );
  }
}
```

### 18. Avoid heavy computations in `build()` method

`build()` メソッド内で重い計算をしない。`initState` や `didUpdateWidget` で事前計算する。

```dart
// BAD: Heavy computation in build() method
// Runs on every rebuild!
@override
Widget build(BuildContext context) {
  final data = expensiveOperation(widget.inputData);
  return DataChart(data: data);
}

// GOOD: Heavy computation outside of build()
@override
void initState() {
  super.initState();
  processedData = expensiveOperation(widget.inputData);
}

@override
void didUpdateWidget(MyWidget oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (widget.inputData != oldWidget.inputData) {
    processedData = expensiveOperation(widget.inputData);
  }
}

@override
Widget build(BuildContext context) {
  return DataChart(data: processedData);
}
```

### 19. Use `compute()` function for heavy operations

重い計算は `compute()` で別 Isolate に逃がし、UI フリーズを防ぐ。

```dart
int calculateFibonacci(int n) {
  if (n <= 1) return n;
  return calculateFibonacci(n - 1) + calculateFibonacci(n - 2);
}

AppButton(
  text: 'Run',
  onPressed: () async {
    // Will cause UI freeze (runs in main isolate)
    final result = calculateFibonacci(50);
    // Won't cause UI freeze (runs in different isolate)
    final isolatedResult = await compute(calculateFibonacci, 50);
  },
);
```

---

## テスト

### 20. More readable test expectations

テストの expect ではマッチャーを活用し、可読性を高める。

```dart
// INSTEAD OF:
expect(list, []);
expect(result.runtimeType == MyClass, true);
expect('Hello world'.startsWith('Hello'), true);
expect(await myFutureFunction(), 42);
expect(duration.inMilliseconds < 1000, true);

// USE:
expect(list, isEmpty);
expect(result, isA<MyClass>());
expect('Hello world', startsWith('Hello'));
expect(myFutureFunction(), completion(42));
expect(duration.inMilliseconds, lessThan(1000));
```

### 21. Drop unnecessary dependencies in tests

テストではウィジェットツリーの不要な依存を排除し、テスト対象だけに集中する。

```dart
// INSTEAD OF:
testWidgets('Body of AppScaffold is visible', (tester) async {
  final testBody = AppText('Hello world'); // Unnecessary!

  await tester.pumpWidget(AppScaffold(body: testBody));
  expect(find.text('Hello world'), findsOneWidget);
});

// DO:
testWidgets('Body of AppScaffold is visible', (tester) async {
  final testBody = Text('Hello world'); // Simple and clean!

  await tester.pumpWidget(AppScaffold(body: testBody));
  expect(find.text('Hello world'), findsOneWidget);
});
```
