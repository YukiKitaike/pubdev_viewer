# Test Doubles ガイド（pubdev_viewer）

## 背景: 古典派テスティング

本プロジェクトは「古典派 (Classical/Detroit School)」のテスト哲学を採用している。
テストは **状態（結果）** を検証し、内部実装の詳細には依存しない。

> テストが「**何が起きるか**」を検証しているなら Fake/Stub が適切。
> テストが「**どう呼ばれるか**」を検証しているなら Mock が必要。
> 後者が必要な場面は、前者より遥かに少ない。

---

## Test Doubles 5 分類

| 種類 | 説明 | このプロジェクトでの使い方 |
|------|------|--------------------------|
| **Dummy** | 引数を埋めるだけで実際には未使用 | 使用場面なし（インターフェースが小さいため） |
| **Stub** | 固定値を返すだけ | Fake のコールバックで固定値を返す形で実現 |
| **Fake** | 簡易ロジックを持つ代替実装 | **主力** — `test/helpers/fakes.dart` の全クラス |
| **Mock** | 呼び出しの期待値を設定し verify する | **使用禁止**（正当な例外は下記参照） |
| **Spy** | 呼び出しを記録して後から検証 | Fake が兼務（`xxxCalls` / `xxxCallCount`） |

---

## Fake 優先の理由

1. **リファクタリング耐性** — Mock は内部実装（呼び出し順序・回数）と密結合する。Fake は結果のみ検証するため、実装変更でテストが壊れにくい
2. **可読性** — `when().thenReturn()` + `verify()` のボイラープレートがなく、テストの意図が明確
3. **再利用性** — Fake は `test/helpers/fakes.dart` に一度定義すれば全テストで共有できる
4. **実行速度** — コード生成（`build_runner`）が不要

---

## Fake パターンの構造

新しい Fake を追加する場合は以下の 3 要素を備える:

```dart
class FakeXxxRepository extends Fake implements XxxRepository {
  // 1. コールバック: テストごとに挙動を差し替え
  Future<Response> Function(String arg)? onGetSomething;

  // 2. 呼び出し記録: Spy 機能
  int getSomethingCallCount = 0;           // 回数のみ
  final List<String> getSomethingCalls = []; // 引数も記録

  // 3. Completer: 非同期制御（オプション）
  Completer<Response>? getSomethingCompleter;

  @override
  Future<Response> getSomething(String arg) {
    getSomethingCallCount++;
    getSomethingCalls.add(arg);
    if (getSomethingCompleter != null) {
      return getSomethingCompleter!.future;
    }
    return onGetSomething!(arg);
  }
}
```

---

## 使い分け表

| 検証したいこと | 使う要素 | 例 |
|---------------|---------|-----|
| 正常系の戻り値 | `onXxx` コールバック | `fakeRepo.onGetPackages = (...) async => firstPageResponse();` |
| エラーハンドリング | `onXxx` で throw | `fakeRepo.onGetPackages = (...) => throw const NetworkException();` |
| 呼び出し回数 | `xxxCallCount` | `check(fakeRepo.getPackagesCallCount).equals(1);` |
| 呼び出し引数 | `xxxCalls` リスト | `check(fakeApiClient.getPackagesCalls).deepEquals([url]);` |
| ローディング状態 | `Completer` | `fakeRepo.getPackagesCompleter = Completer();` |
| N 回目で異なる挙動 | `onXxx` 内の callCount | `var c = 0; fakeRepo.onGetPackages = (...) { c++; if (c == 1) ...; }` |

---

## Mock が正当化される場面（将来の拡張時の参考）

| 場面 | 理由 |
|------|------|
| Analytics / ログ送信 | 副作用の発生自体が検証対象 |
| 外部 API への送信内容 | リクエストボディの構造が正しいか |
| キャッシュ invalidation | 正しいキーで invalidate が呼ばれたか |
| サードパーティ SDK（Firebase 等） | Fake を書くコストが現実的でない |

ただし本プロジェクトでは Fake の呼び出し記録パターンで相互作用の検証もカバーしているため、Mock が必要になる場面は極めて限定的。

### Analytics Fake の実装例

もし AnalyticsService を追加する場合でも、Fake の呼び出し記録パターンで対応できる:

```dart
class FakeAnalyticsService extends Fake implements AnalyticsService {
  final List<({String event, Map<String, dynamic>? properties})> trackedEvents = [];

  @override
  Future<void> track(String event, {Map<String, dynamic>? properties}) async {
    trackedEvents.add((event: event, properties: properties));
  }
}

// テスト:
check(fakeAnalytics.trackedEvents).length.equals(1);
check(fakeAnalytics.trackedEvents[0].event).equals('purchase_completed');
```

### サードパーティ SDK のハイブリッド例

`url_launcher` のような Platform Interface を持つパッケージでは、
`MockPlatformInterfaceMixin` が必要なため Fake + Mixin のハイブリッドを採用:

```dart
class FakeUrlLauncher extends Fake
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {
  final List<String> launchedUrls = [];
  bool shouldSucceed = true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launchedUrls.add(url);
    return shouldSucceed;
  }
}
```

---

## リファクタリング耐性の具体例

```dart
// ❌ Mock ベース: キャッシュ戦略を変更するとテストが壊れる
verifyInOrder([
  mockCache.get('user:1'),
  mockRepo.getUser('1'),
  mockCache.set('user:1', any),
]);

// ✅ Fake ベース: キャッシュ戦略をどう変更しても結果が正しければ合格
final profile = await service.loadProfile('1');
check(profile.name).equals('Test User');
```

Mock は呼び出し順序に依存するため、write-through → write-behind のような内部変更で偽陽性が発生する。
Fake は最終的な結果のみを検証するため、内部実装の変更に強い。
