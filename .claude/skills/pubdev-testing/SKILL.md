---
name: pubdev-testing
description: >
  pubdev_viewer のテストパターン。ユニットテスト（notifier・repository）・
  ウィジェットテストを書く際に使用。「テストを書いて」「テスト追加」
  「Fake」「ProviderContainer」「check()」と言われたときに参照。
  Fake パターン・フィクスチャビルダー・Completer・package:checks・テストタグを提供する。
---

# テストパターン（pubdev_viewer）

## Test Doubles: 分類と判断フレームワーク

### 5 分類

| 種類 | 説明 | このプロジェクトでの使い方 |
|------|------|--------------------------|
| **Dummy** | 引数を埋めるだけで実際には未使用 | 使用場面なし（インターフェースが小さいため） |
| **Stub** | 固定値を返すだけ | Fake のコールバックで固定値を返す形で実現 |
| **Fake** | 簡易ロジックを持つ代替実装 | **主力** — `test/helpers/fakes.dart` の全クラス |
| **Mock** | 呼び出しの期待値を設定し verify する | **使用禁止**（正当な例外は下記参照） |
| **Spy** | 呼び出しを記録して後から検証 | Fake が兼務（`xxxCalls` / `xxxCallCount`） |

### 判断フレームワーク

- **「何が起きるか」を検証** → Fake/Stub（状態・戻り値の検証）
- **「どう呼ばれるか」を検証** → 本プロジェクトでは Fake の呼び出し記録で対応

### なぜ Mock より Fake を優先するか

1. **リファクタリング耐性** — Mock は内部実装（呼び出し順序・回数）と密結合する。Fake は結果のみ検証するため、実装変更でテストが壊れにくい
2. **可読性** — `when().thenReturn()` + `verify()` のボイラープレートがなく、テストの意図が明確
3. **再利用性** — Fake は `test/helpers/fakes.dart` に一度定義すれば全テストで共有できる
4. **実行速度** — コード生成（`build_runner`）が不要

### Mock が正当化される場面（将来の拡張時の参考）

| 場面 | 理由 |
|------|------|
| Analytics / ログ送信 | 副作用の発生自体が検証対象 |
| 外部 API への送信内容 | リクエストボディの構造が正しいか |
| キャッシュ invalidation | 正しいキーで invalidate が呼ばれたか |
| サードパーティ SDK（Firebase 等） | Fake を書くコストが現実的でない |

ただし本プロジェクトでは Fake の呼び出し記録パターンで相互作用の検証もカバーしているため、Mock が必要になる場面は極めて限定的。詳細は [Test Doubles ガイド](references/test_doubles_guide.md) を参照。

---

## テストケース名は日本語で記述する

`test()` / `testWidgets()` の説明文字列は **すべて日本語** で書く。
`group()` はクラス名をそのまま使うため英語のまま。

```dart
// ✅ 正しい例
group('PackageListNotifier', () {
  test('build が初期パッケージを取得する', () async { ... });
  test('loadMore がパッケージを追加する', () async { ... });
});

// ❌ 英語で書かない
group('PackageListNotifier', () {
  test('build fetches initial packages', () async { ... });
});
```

---

## テストタグ

全テストファイルに `@Tags` を付与し、選択実行を可能にする。
`dart_test.yaml` でタグ定義済み。

```dart
// ユニットテスト（models, repositories, notifiers, utils）
@Tags(['unit'])
library;

import 'package:flutter_test/flutter_test.dart';
// ...
```

```dart
// ウィジェットテスト（screens, components）
@Tags(['widget'])
library;

import 'package:flutter_test/flutter_test.dart';
// ...
```

選択実行:
```bash
fvm flutter test -t unit    # ユニットテストのみ
fvm flutter test -t widget   # ウィジェットテストのみ
```

---

## アサーション: package:checks 優先

値アサーションは `package:checks` の `check()` を使う。
Flutter の finder 系アサーション（`find.*` / `findsOneWidget`）のみ `expect` を維持。

```dart
import 'package:checks/checks.dart';

// ✅ 値アサーション → check()
check(state.packages).length.equals(2);
check(state.packages[0].name).equals('http');
check(state.nextUrl).isNotNull();
check(response.publisherId).isNull();
check(asyncValue.hasError).isTrue();
check(asyncValue.error).isA<NetworkException>();
check(fakeRepository.getPackagesCallCount).equals(1);
check(fakeDio.getCalls).deepEquals(['https://pub.dev/api/packages']);

// ✅ finder 系 → expect（package:checks 非対応）
expect(find.text('http'), findsOneWidget);
expect(find.byType(CircularProgressIndicator), findsOneWidget);
expect(find.byIcon(Icons.share), findsOneWidget);

// ✅ async throws → await check(future).throws<T>()
await check(repository.getPackages()).throws<NetworkException>();

// ✅ throwsA + having → expect 維持（async Future + プロパティ検証）
expect(
  () => apiClient.getPackages(),
  throwsA(
    isA<ServerException>().having((e) => e.statusCode, 'statusCode', 404),
  ),
);
```

---

## ファイル配置ルール

`lib/` の構造を `test/` 配下にそのまま鏡像する:

```
lib/features/package_list/notifiers/package_list_notifier.dart
→ test/features/package_list/notifiers/package_list_notifier_test.dart
```

---

## 共有テストヘルパー

`test/helpers/` に 3 ファイルが存在する:

- `test/helpers/fakes.dart` — Fake クラスの定義（FakeDio, FakePubDevApiClient, FakePackageListRepository, FakePackageDetailRepository, FakeUrlLauncher）
- `test/helpers/fixtures.dart` — const JSON マップ + 型付きビルダー関数
- `test/helpers/pump_app.dart` — `createTestApp()` ウィジェットテストヘルパー

テストファイル内にインラインで JSON やヘルパー関数を書かない。必ず共有ヘルパーを使う。

---

## Fake の Spy 機能（呼び出し記録パターン）

本プロジェクトの Fake は Test Doubles 分類における **Spy** 機能を兼ねている。
各 Fake は呼び出し記録を持ち、「何回呼ばれたか」「どの引数で呼ばれたか」を検証できる。

```dart
// 呼び出し回数の検証
check(fakeRepository.getPackagesCallCount).equals(1);

// 呼び出し引数の検証
check(fakeApiClient.getPackagesCalls).deepEquals([url]);

// URL リストの検証
check(fakeDio.getCalls).deepEquals(['https://pub.dev/api/packages']);
```

この設計により、`mockito` の `verify()` が不要になる。Mock の `verify(mock.method()).called(1)` と同等の検証を、型安全かつ `package:checks` のアサーションで実現している。

### 新しい Fake の統一パターン

新しい Fake を追加する場合は以下の 3 要素を備える:

1. **コールバックプロパティ** (`onXxx`) — テストごとに挙動を差し替え
2. **呼び出し記録** (`xxxCalls: List<T>` or `xxxCallCount: int`) — 相互作用の検証
3. **Completer** (`xxxCompleter`) — 非同期制御（ローディング状態テスト用、必要な場合のみ）

---

## フィクスチャビルダー

`test/helpers/fixtures.dart` には const JSON マップに加え、型付きビルダー関数がある:

```dart
// const JSON マップ（パース前のデータ）
packageListResponseJson
packageListResponseLastPageJson
packageDetailResponseJson
packageDetailResponseNoHomepageJson
packageDetailResponseNoUrlJson
packagePublisherResponseJson
packagePublisherNullResponseJson

// 型付きビルダー関数（パース済みモデルを返す）
PackageListResponse firstPageResponse()
PackageListResponse lastPageResponse()
PackageDetailResponse detailResponse()
PackageDetailResponse detailResponseNoHomepage()
PackageDetailResponse detailResponseNoUrl()
PackagePublisherResponse publisherResponse()
PackagePublisherResponse publisherNullResponse()
PackageListItem httpPackageItem()
PackageListItem dioPackageItem()
List<PackageDetailVersion> sortedVersions()
```

```dart
// ✅ ビルダー関数を使う
fakeRepository.onGetPackages = ({String? pageUrl}) async => firstPageResponse();

// ❌ 各テストで Map.from + fromJson を書かない
fakeRepository.onGetPackages = ({String? pageUrl}) async =>
    PackageListResponse.fromJson(Map<String, dynamic>.from(packageListResponseJson));
```

---

## よくある間違い

```dart
// ❌ @GenerateMocks を使う（Fake パターンで対応できる）
@GenerateMocks([PackageListRepository])
void main() { ... }

// ❌ ProviderContainer() を直接使う（ProviderContainer.test() を使う）
container = ProviderContainer(overrides: [...]); // → ProviderContainer.test() で自動 dispose

// ❌ テストごとにインラインで JSON を定義する（fixtures のビルダーを使う）
fakeRepository.onGetPackages = ({_}) async =>
    PackageListResponse.fromJson({'next_url': null, 'packages': []});

// ❌ @Tags を書かない（選択実行が効かない）
// ファイル先頭に @Tags(['unit']) または @Tags(['widget']) を必ず付ける

// ❌ 値アサーションに expect を使う（package:checks 優先）
expect(state.packages, hasLength(2)); // → check(state.packages).length.equals(2);

// ❌ ローカルに createTestWidget を定義する（createTestApp を使う）
Widget createTestWidget() => MaterialApp(theme: appLightTheme, home: ...);

// ❌ mockito の when/verify を使う（Fake の呼び出し記録で代替する）
when(mockRepo.getPackages(any)).thenReturn(response);
verify(mockRepo.getPackages(any)).called(1);
// → fakeRepo.onGetPackages = ...; + check(fakeRepo.getPackagesCallCount).equals(1);

// ❌ Fake に呼び出し記録を付けない（Spy 機能がないと相互作用を検証できない）
class FakeXxx extends Fake implements Xxx {
  @override
  Future<void> doSomething() async {} // xxxCallCount / xxxCalls がない
}
// → 呼び出し記録（xxxCallCount や xxxCalls）を必ず追加する
```

---

### WHY コメントの典型例

- `Map<String, dynamic>.from()` でコピーする理由（const マップを直接渡すと内部変換で UnmodifiableMapError）
- `ProviderContainer.test()` を使う理由（自動 dispose でリソースリーク防止）
- Completer でテスト終了前に `complete()` する理由（未完了 future が残ると dispose エラー）
- Fake にコールバックプロパティを使う理由（テストごとに挙動を差し替え可能にする）
- ダブル `pump()` の理由（Riverpod AsyncNotifier のマイクロタスク解決サイクル）

---

## テスト実装例

具体的なテストコードの実装例はトピック別に参照:

### [Test Doubles ガイド](references/test_doubles_guide.md)
- Test Doubles 5 分類の詳細
- Fake パターンの構造と使い分け
- Mock が正当化される場面の具体例
- リファクタリング耐性の具体例

### [ユニットテスト例](references/unit_test_examples.md)
- Fake パターンの定義方法
- Notifier ユニットテスト（ProviderContainer）
- AsyncError / loadMore エラーのテスト
- Repository ユニットテスト
- フィクスチャのコピーが必要な理由

### [ウィジェットテスト例](references/widget_test_examples.md)
- ローディング状態のテスト（Completer）
- ウィジェットテスト（createTestApp）
