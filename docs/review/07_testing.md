# Phase 7: テスト品質 レビュー結果

## 使用スキル
- `pubdev-testing` — Fake ベーステスト・ProviderContainer・ウィジェットテスト
- `dart-test-fundamentals` — グループ構造・lifecycle の正確性
- `dart-checks-migration` — `package:checks` への移行
- `dart-matcher-best-practices` — `expect/matcher` の可読性
- `flutter-dart-code-review` — ウィジェットテストの completeness

## テストカバレッジ概要

| ファイル | ユニットテスト | Widget テスト | 3状態カバー（loading/error/data） |
|--------|-------------|-------------|-------------------------------|
| `package_list_response` | ✅ | - | - |
| `package_detail_response` | ✅ | - | - |
| `pub_dev_api_client` | ✅ | - | - |
| `package_list_repository` | ✅ | - | - |
| `package_detail_repository` | ✅ | - | - |
| `package_list_notifier` | ✅ | - | - |
| `package_detail_notifier` | ✅ | - | - |
| `package_list_screen` | - | ✅ | ✅ |
| `package_detail_screen` | - | ✅ | loading ✅ / error ✅ / data ✅ |
| integration_test (e2e) | - | - | 最小限のみ |

## 発見事項

### Critical（修正必須）

- [ ] **`find.byIcon(Icons.error_outline)` がアイコンの実装と不一致** — `test/features/package_list/screens/package_list_screen_test.dart:85` — 実装 (`lib/core/widgets/error_view.dart:50`) では `Icons.cloud_off_rounded` を使用しているが、テストは `Icons.error_outline` を検索しているためテストが必ず失敗する。`find.byIcon(Icons.cloud_off_rounded)` に修正する。

  ```dart
  // 現在（バグ）
  expect(find.byIcon(Icons.error_outline), findsOneWidget);

  // 修正後
  expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);
  ```

### Major（強く推奨）

- [ ] **`package:checks` が `dev_dependencies` に宣言されているが全テストで未使用** — `pubspec.yaml:33` (`checks: ^0.3.1`) が存在するが、すべてのテストファイルで `package:checks` のインポートが一切なく、`expect/matcher` のみ使用されている。`package:checks` への移行を進めるか、使用しないなら `pubspec.yaml` から削除してdependencyの意図を明確にする。

  移行する場合の例（`package_list_response_test.dart`）:
  ```dart
  import 'package:checks/checks.dart';

  // 移行前
  expect(response.packages, hasLength(2));
  expect(response.packages[0].name, 'http');

  // 移行後
  check(response.packages).length.equals(2);
  check(response.packages[0].name).equals('http');
  ```

- [ ] **`package_detail_screen_test.dart` でエラー状態テストに `byIcon` 検証がない** — `test/features/package_detail/screens/package_detail_screen_test.dart:114-124` の `'shows error view on failure'` テストが `find.text('再試行')` のみ確認しており、`find.byIcon(Icons.cloud_off_rounded)` の検証がない。`package_list_screen_test.dart` と対称性が取れていない（ただし `package_list_screen_test.dart` の Icon検索自体がバグのため、両方を修正した上で対称にする）。

- [ ] **Widget テストに `MaterialApp(theme: appLightTheme)` が未設定** — `test/features/package_list/screens/package_list_screen_test.dart:22-30` および `test/features/package_detail/screens/package_detail_screen_test.dart:32-41` の `createTestWidget()` で `MaterialApp` にテーマが渡されていない。実装が `context.tokens`（`AppThemeTokens`）や `theme.colorScheme` を多用しているため、テスト環境でのフォールバック挙動に依存することになる。`MaterialApp(theme: appLightTheme, ...)` を設定することで、本番と同じテーマでのテストが可能になる。

  ```dart
  // 修正例
  import 'package:pubdev_viewer/app/theme.dart';

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [...],
      child: MaterialApp(
        theme: appLightTheme,  // 追加
        home: PackageListScreen(),
      ),
    );
  }
  ```

- [ ] **`receiveTimeout` 時の `NetworkException` テストが欠けている** — `test/core/api/pub_dev_api_client_test.dart` の `error handling` グループにて `DioExceptionType.connectionError`、`connectionTimeout`、`SocketException` の3ケースはテスト済みだが、`DioExceptionType.receiveTimeout` と `DioExceptionType.sendTimeout` に対するテストが存在しない。APIクライアントの実装でこれらが `NetworkException` にマッピングされているか未検証状態。

  ```dart
  test('throws NetworkException on receive timeout', () {
    fakeDio.onGet = <T>(url) {
      throw DioException(
        type: DioExceptionType.receiveTimeout,
        requestOptions: RequestOptions(),
      );
    };

    expect(
      () => apiClient.getPackages(),
      throwsA(isA<NetworkException>()),
    );
  });
  ```

- [ ] **`package_detail_notifier_test.dart` でエラー状態のバリエーションが不足** — `test/features/package_detail/notifiers/package_detail_notifier_test.dart:70-84` では `getPackageDetail` が例外を投げるケースのみテスト済みだが、`getPackagePublisher` が例外を投げるケース（`ServerException` 含む）がテストされていない。`package_list_notifier_test.dart` では `loadMoreError` を保持するテストがあり対称性が取れていない。

### Minor（改善提案）

- [ ] **`FakePackageListRepository` の `getPackagesCallCount` と `FakePackageDetailRepository` の対称性** — `fakes.dart:73` の `FakePackageListRepository` は `getPackagesCallCount: int` を持つが、`FakePackageDetailRepository`（`fakes.dart:88`）は `getPackageDetailCallCount` と `getPackagePublisherCallCount` を持つ。一方、`FakePackageListRepository` には `getPackagesCalls: List<String?>` のリスト記録がなく（`FakePubDevApiClient` は `getPackagesCalls` を持つ）、Fake の設計粒度に一貫性がない。`FakePackageListRepository` にも `List<String?>` 形式の呼び出し履歴を追加することを検討する。

- [ ] **`package_list_notifier_test.dart` の並列実行確認が不完全** — `test/features/package_detail/notifiers/package_detail_notifier_test.dart:40-53` の `'build fetches detail and publisher in parallel'` テストはコール数（`getPackageDetailCallCount == 1`、`getPackagePublisherCallCount == 1`）のみ確認しており、実際の並列実行（`Future.wait` 等）がテストできていない。`Completer` を2つ用いて片方がブロックされても両方が呼ばれることを確認するテストを追加することで実際の並列性を検証できる。

  ```dart
  test('fetches detail and publisher concurrently', () async {
    final detailCompleter = Completer<PackageDetailResponse>();
    final publisherCompleter = Completer<PackagePublisherResponse>();
    fakeRepository
      ..getPackageDetailCompleter = detailCompleter
      ..getPackagePublisherCompleter = publisherCompleter;

    final future = container.read(
      packageDetailNotifierProvider('http').future,
    );
    await Future.microtask(() {}); // microtask を消化

    // 両方が呼ばれた = 並列実行されている
    expect(fakeRepository.getPackageDetailCallCount, 1);
    expect(fakeRepository.getPackagePublisherCallCount, 1);

    detailCompleter.complete(...);
    publisherCompleter.complete(...);
    await future;
  });
  ```

- [ ] **Integration test が最小限すぎる** — `integration_test/app_test.dart` はアプリ起動と `'pub.dev Viewer'` テキスト確認のみで、実際の画面遷移（パッケージ詳細への遷移）や無限スクロール、リトライ操作のE2Eテストが存在しない。モックサーバー（`mockito` + `dio` interceptor）を使って主要フローをカバーすることを推奨。

- [ ] **`mockito` が `dev_dependencies` に存在するが実質未使用** — `pubspec.yaml:42` に `mockito: ^5.4.6` が宣言されており、`test/helpers/fakes.dart:4` でインポートされているが、実際には `Fake` ベースのテスト（`extends Fake implements ...`）のみが使用されており `Mock` は使用されていない。`mocks.dart` にコメントのみ存在（`// mockito はどうしても Mock が必要な場合のために dev_dependency に保持。`）。`mockito` のインポートは `fakes.dart` に残っているが、`Fake` クラスは `package:mockito/mockito.dart` からのインポートで提供されるため削除はできない。コメントの意図を明確にするか、`Fake` が `mockito` 由来である旨を `fakes.dart` のコメントに明示するとよい。

- [ ] **Golden test の CI 運用方針が未定義** — `test/features/package_list/screens/package_list_screen_test.dart:88-101` および `test/features/package_detail/screens/package_detail_screen_test.dart:102-112` に Golden test が存在し、`goldens/` ディレクトリに PNG ファイルも存在するが、`.github/` ディレクトリが存在しないため CI での扱いが未定義。Golden test は OS・フォント・Flutter バージョンでピクセルが変わるため、`--update-goldens` の実行タイミングや「CI で失敗した場合の対応方針」を `docs/` やコードコメントに明記することを推奨。

- [ ] **`package_list_screen_test.dart` の `'golden test for package list'`** — `test/features/package_list/screens/package_list_screen_test.dart:88-101` のGolden testでは `fakeRepository.onGetPackages` が1回の呼び出しで即座にデータを返すが、`FakePackageListRepository.getPackages` が `onGetPackages` を呼ぶ前に `getPackagesCompleter` を確認する実装になっている（`fakes.dart:78-81`）。`pumpAndSettle` の呼び出し後に次ページ取得が走り得るため、2ページ目を返す stub を設定していない点がリスク。

- [ ] **`tearDown` での `container.dispose()` の徹底** — `test/features/package_list/notifiers/package_list_notifier_test.dart:32-34` と `test/features/package_detail/notifiers/package_detail_notifier_test.dart:35-37` では正しく `tearDown` で `container.dispose()` を呼んでいる。一方、Widget テスト（`package_list_screen_test.dart`、`package_detail_screen_test.dart`）では `ProviderScope` を通じた `ProviderContainer` が `tester` に管理されるため明示的な dispose は不要。現状の実装は正しい。

- [ ] **`fakes.dart` に `mockito` パッケージへの依存が必要かどうかの明示** — `fakes.dart:4` で `import 'package:mockito/mockito.dart'` をしているのは `Fake` クラスのためであるが、`dart:test` の `Fake` を使う方法もある（Flutter テスト環境では `package:mockito` の `Fake` が一般的）。コメントで使い分けを明示すると保守性が上がる。

- [ ] **`widget_test.dart` のテスト内容が最小限** — `test/widget_test.dart:11-28` はアプリルートをレンダリングして `'pub.dev Viewer'` を確認するだけ。個別の Widget テストでカバーされているとはいえ、smoke test として不十分ではないが、エラー状態やデータロード後の状態も `widget_test.dart` で確認するとより堅牢になる。

- [ ] **テスト命名の言語統一** — テスト名は英語で統一されているが（`'shows loading indicator initially'`, `'build fetches initial packages'` 等）、`package_list_screen_test.dart:84` のアサーションで日本語文字列（`'再試行'`）の直書きがある。これ自体はテスト対象の表示文字列確認なので問題ないが、テスト説明文（`test('...')` の第1引数）はすべて英語で統一されており一貫している。

### Positive（良い実装）

- **Fake ベースのテスト設計が徹底されている** — `fakes.dart` の全 Fake クラスが `extends Fake implements ...` パターンで実装されており、CLAUDE.md の「No interfaces / FakeXxxRepository extends Fake implements XxxRepository」ルールに完全準拠している。

- **コールバック注入パターンが柔軟** — `FakePackageListRepository.onGetPackages` のようなコールバックフィールドを通じて各テストで挙動を差し替えられる設計は、同一 Fake インスタンスを複数テストで再利用しながら異なる挙動を設定できる点で優れている。

- **`Completer` を使ったローディング状態テスト** — `package_list_screen_test.dart:34-51` および `package_detail_screen_test.dart:50-70` で `Completer` を使って非同期完了を手動制御することで、中間状態（ローディング）を確実にテストできている。

- **`ProviderContainer` + `tearDown(container.dispose())` パターンが正しい** — Notifier テストにおいて `setUp` で `ProviderContainer` を生成し `tearDown` で `dispose()` するパターンが全テストファイルで一貫している。リソースリークを防ぐ正しい実装。

- **`packageListRepositoryProvider.overrideWithValue()` による依存注入** — Widget テスト・Notifier テスト両方で `overrideWithValue` を使ったリポジトリの差し替えが行われており、テスト専用の DI が明確に分離されている。

- **fixtures.dart による共通テストデータの集中管理** — テストデータが `test/helpers/fixtures.dart` に一元管理されており、各テストで `Map<String, dynamic>.from(...)` によってコピーを作成することでイミュータビリティを保ちながら再利用している。

- **`hasLength` / `isNotNull` / `isNull` / `isA<T>()` / `.having()` の適切な使い分け** — `expect` の matcher が状況に応じて選択されており可読性が高い。特に `ServerException` の `statusCode` 検証に `.having()` を使っている点（`pub_dev_api_client_test.dart:112-119`）は正しいパターン。

- **エラーケースのバリエーションが充実** — `pub_dev_api_client_test.dart` の `error handling` グループで `connectionError`、`connectionTimeout`、`SocketException`、`badResponse(404)`、`null data` の5パターンをテストしており、エラーハンドリングの網羅性が高い。

- **`loadMore` 系のテストが充実** — `package_list_notifier_test.dart` で「追加ロード成功」「nextUrl が null のとき何もしない」「追加ロードでエラー時に既存データを保持」の3ケースをすべてカバーしている。

## 修正例（Critical 対応）

### 1. `package_list_screen_test.dart` の Icon 不一致修正

```dart
// test/features/package_list/screens/package_list_screen_test.dart:85

// 変更前
expect(find.byIcon(Icons.error_outline), findsOneWidget);

// 変更後
expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);
```

### 2. `package_detail_screen_test.dart` へのエラー時 Icon 検証追加（対称性の確保）

```dart
// test/features/package_detail/screens/package_detail_screen_test.dart

testWidgets('shows error view on failure', (tester) async {
  fakeRepository.onGetPackageDetail = (name) =>
      throw const NetworkException();
  // ignore: cascade_invocations
  fakeRepository.onGetPackagePublisher = _publisherResponse;

  await tester.pumpWidget(createTestWidget());
  await tester.pumpAndSettle();

  expect(find.text('再試行'), findsOneWidget);
  expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget); // 追加
});
```

### 3. `pubspec.yaml` の整理（`package:checks` の扱いを決定する場合）

移行しない場合:
```yaml
dev_dependencies:
  build_runner: ^2.4.15
  # checks: ^0.3.1  # 削除（未使用のため）
  ...
```

移行する場合は全テストに段階的に `package:checks` を導入する。

## 総評

テストの基本構造（Fake パターン・ProviderContainer・3状態カバー）は高品質で、CLAUDE.md のアーキテクチャルールに忠実に実装されている。Critical 問題は `Icons.error_outline` vs `Icons.cloud_off_rounded` の不一致のみで、これは実行するとテストが失敗する明確なバグ。`package:checks` の未使用は方針を決めて対処する必要がある。Golden test の CI 運用方針を明確にすることで、テストスイート全体の信頼性がさらに高まる。
