---
name: pubdev-testing
description: >
  pubdev_viewer のテストパターン。ユニットテスト（notifier・repository）・
  ウィジェットテストを書く際に使用。「テストを書いて」「テスト追加」
  「Fake」「ProviderContainer」「check()」と言われたときに参照。
  Fake パターン・フィクスチャビルダー・Completer・package:checks・テストタグを提供する。
---

# テストパターン（pubdev_viewer）

## 基本ルール

- **Mock 禁止** — `Fake implements XxxRepository` パターンを使う。理由は [Test Doubles ガイド](references/test_doubles_guide.md) 参照
- **`check()` 優先** — 値検証は `package:checks`。finder 系（`find.*`）のみ `expect`
- **テスト名は日本語** — `test('build が初期パッケージを取得する', ...)`。`group()` はクラス名のまま英語
- **`@Tags` 必須** — `@Tags(['unit'])` or `@Tags(['widget'])` をファイル先頭に付与

---

## 新しい Fake の統一パターン

```dart
class FakeXxxRepository extends Fake implements XxxRepository {
  // 1. コールバック — テストごとに挙動を差し替え
  Future<XxxResponse> Function(String name)? onGetXxx;
  // 2. 呼び出し記録 — Spy 機能（verify 不要）
  int getXxxCallCount = 0;
  // 3. Completer（任意）— ローディング状態テスト用
  Completer<XxxResponse>? getXxxCompleter;

  @override
  Future<XxxResponse> getXxx(String name) {
    getXxxCallCount++;
    if (getXxxCompleter != null) return getXxxCompleter!.future;
    return onGetXxx!(name);
  }
}
```

既存 Fake: [test/helpers/fakes.dart](test/helpers/fakes.dart)

---

## アサーション早見表

```dart
// 値検証 → check()
check(state.packages).length.equals(2);
check(state.packages[0].name).equals('http');
check(fakeRepository.getPackagesCallCount).equals(1);
check(fakeDio.getCalls).deepEquals(['https://pub.dev/api/packages']);

// finder 系 → expect
expect(find.text('http'), findsOneWidget);

// async throws → check
await check(repository.getPackages()).throws<NetworkException>();

// throwsA + having → expect
expect(() => apiClient.getPackages(),
  throwsA(isA<ServerException>().having((e) => e.statusCode, 'statusCode', 404)));
```

---

## フィクスチャビルダー

`test/helpers/fixtures.dart` のビルダー関数を使い、テスト内にインライン JSON を書かない:

```dart
// ✅ ビルダー関数
fakeRepository.onGetPackages = ({String? pageUrl}) async => firstPageResponse();

// ❌ インライン JSON
fakeRepository.onGetPackages = ({String? pageUrl}) async =>
    PackageListResponse.fromJson(Map<String, dynamic>.from(packageListResponseJson));
```

---

## 共有テストヘルパー

| ファイル | 役割 |
|---|---|
| [test/helpers/fakes.dart](test/helpers/fakes.dart) | Fake クラス群 |
| [test/helpers/fixtures.dart](test/helpers/fixtures.dart) | const JSON + ビルダー関数 |
| [test/helpers/pump_app.dart](test/helpers/pump_app.dart) | `createTestApp()` ウィジェットヘルパー |

---

## よくある間違い

```dart
// ❌ @GenerateMocks（Fake で対応）
// ❌ ProviderContainer() 直接使用（ProviderContainer.test() を使う）
// ❌ テスト内にインライン JSON（fixtures のビルダーを使う）
// ❌ @Tags を書かない
// ❌ 値検証に expect（check() を使う）
// ❌ ローカル createTestWidget（createTestApp を使う）
// ❌ mockito の when/verify（Fake の呼び出し記録で代替）
// ❌ Fake に呼び出し記録なし（xxxCallCount / xxxCalls を必ず追加）
```

---

## テスト実装例

| トピック | 参照 |
|---|---|
| Test Doubles 5分類・Fake vs Mock | [test_doubles_guide.md](references/test_doubles_guide.md) |
| Notifier / Repository ユニットテスト | [unit_test_examples.md](references/unit_test_examples.md) |
| Widget テスト（Completer / createTestApp） | [widget_test_examples.md](references/widget_test_examples.md) |
