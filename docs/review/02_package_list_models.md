# Phase 2: package_list Models & Repository レビュー結果

## 使用スキル
- `pubdev-models` — Freezed + json_serializable パターン
- `dart-new-syntax` — Dart 3.x 新記法の適用確認
- `dart-test-fundamentals` — テストグループ構造・lifecycle の正確性
- `dart-checks-migration` — `package:checks` 移行の可能性

---

## 発見事項

### Critical（修正必須）

- [ ] **`loadMoreError` の型が `Object?` と広すぎる** — `lib/features/package_list/models/package_list_state.dart:14` — `AppException?` に絞り込むべき。`PackageListNotifier.loadMore()` は `on Exception catch (e)` でキャッチしているが、`AppException` は `Exception` を実装しているため絞り込み可能。`Object?` のままでは `loadMoreError` を受け取る Widget 側で型スイッチが書けず、`sealed class AppException` のパターンマッチが活かせない。

  ```dart
  // Before
  Object? loadMoreError,

  // After
  AppException? loadMoreError,
  ```

  合わせて `package_list_notifier.dart:49` の catch 節も変更する:
  ```dart
  // Before
  on Exception catch (e) {

  // After
  on AppException catch (e) {
  ```

- [ ] **`package:checks` が `dev_dependencies` に宣言されているが、テストコード全体で一切使われていない** — `pubspec.yaml:33` / `test/` 配下全ファイル — `checks: ^0.3.1` が宣言済みにもかかわらず、全テストが `expect/matcher` のみを使用している。デッドな依存関係として misleading であり、移行方針を統一する必要がある。「使わないなら削除」「使うなら移行」のどちらかを選択すること。

---

### Major（強く推奨）

- [ ] **`PackageListState.nextUrl` が `String?` — `Uri?` の方が型安全** — `lib/features/package_list/models/package_list_state.dart:12` および `lib/features/package_list/repository/package_list_repository.dart:18` — `nextUrl` は常に `https://pub.dev/api/packages?page=N` 形式の URL であり、`String?` で保持すると Notifier 側でも API クライアント側でも文字列のまま引き回される。`Uri?` に変えることで `Uri.parse()` 漏れや不正な URL が混入するリスクが減る。

  ただし `PubDevApiClient.getPackages({String? pageUrl})` のシグネチャとの整合が必要で、変更スコープが大きくなるため、後続 PR での対応も許容する。その場合は TODO コメントを残すこと。

- [ ] **`PackageListVersion` と `PackageDetailVersion` はフィールド構造が意図的に異なるにも関わらず、コード上にその説明がない** — `lib/features/package_list/models/package_list_version.dart` / `lib/features/package_detail/models/package_detail_version.dart` — `openapi.yaml` の `PackageListVersion` と `PackageDetailVersion` の説明には「フィールドが異なる」と明記されているが、Dart モデルのドキュメントコメントにその説明がない。将来の開発者が誤って統合しようとするリスクがある。

  差異の整理:
  - `PackageListVersion` 固有: `package_url`, `url`
  - `PackageDetailVersion` 固有: `archive_sha256`, `published`

  現在の分離は `No premature core promotion` ルールに沿っており正しい判断だが、以下のコメントを追加すること:

  ```dart
  /// パッケージ一覧で使用するバージョン情報のデータクラス。
  ///
  /// 詳細 API の [PackageDetailVersion] とはフィールド構成が異なるため、
  /// 共通化せず feature 固有クラスとして維持している（openapi.yaml 参照）。
  ```

- [ ] **`FakePackageListRepository.getPackagesCompleter` が `null` のとき `onGetPackages` が `null` でも `!` で呼ばれる** — `test/helpers/fakes.dart:81` — `onGetPackages!(pageUrl: pageUrl)` は `onGetPackages` が未設定の場合に `Null check operator used on a null value` を投げる。テストの setUp で設定し忘れた場合のエラーメッセージが不明瞭になる。

  ```dart
  // Before
  return onGetPackages!(pageUrl: pageUrl);

  // After
  final handler = onGetPackages;
  assert(handler != null, 'FakePackageListRepository.onGetPackages を設定してください');
  return handler!(pageUrl: pageUrl);
  ```

---

### Minor（改善提案）

- [ ] **`package_list_response_test.dart` のテストに `group` が1層しかなく、将来の拡張で平坦になりやすい** — `test/features/package_list/models/package_list_response_test.dart:7` — 現在は `PackageListResponse > fromJson parses correctly / fromJson parses last page` の2テストのみで問題はないが、`toJson` や `copyWith` のテストを追加する際に `fromJson` グループをネストしておくと整理しやすい。

  ```dart
  group('PackageListResponse', () {
    group('fromJson', () {
      test('通常ページを正しくパースする', () { ... });
      test('最終ページ（next_url が null）を正しくパースする', () { ... });
    });
  });
  ```

- [ ] **テスト命名が英語と日本語で統一されていない** — `test/features/package_list/` 配下全般 — `package_list_response_test.dart` のテスト名は英語 (`fromJson parses correctly`) だが、プロジェクトのコミットメッセージは日本語。テスト名の言語を統一するか、CLAUDE.md にポリシーを追記すること。

- [ ] **`PackageListState` は `@freezed` を使っているが `fromJson` を持たない UI State モデル** — `lib/features/package_list/models/package_list_state.dart` — これは正しいパターン（`pubdev-models` スキルに沿った API Response / UI State の分離）。ただし `part 'package_list_state.g.dart'` の宣言がないことで「意図的に json_serializable を使っていない」ことが示されており、この点は明示的なコメントがあるとよりわかりやすい。

- [ ] **`fixtures.dart` の `packageListResponseJson` に `pubspec` フィールドが最小セット（`name`/`version`/`description` のみ）** — `test/helpers/fixtures.dart:8-12` — `Pubspec` の `fromJson` は `homepage`/`repository` 等をオプショナルで受け入れるため、最小フィクスチャ自体は問題ない。ただし、`PackageDetailResponse` のフィクスチャ (`packageDetailResponseJson`) には `homepage`/`repository` が含まれているのに、`packageListResponseJson` 側には含まれておらず、一覧画面で表示できるはずのフィールドがテストで検証されていない。将来的に一覧画面で `homepage` を表示する要件が入ったときにテスト漏れが起きやすい。

- [ ] **`package_list_repository_test.dart` の `getPackages rethrows NetworkException` テストがエラーパスを async で検証していない** — `test/features/package_list/repository/package_list_repository_test.dart:41-48` — テスト本体が `async` ではなく `expect` に `throwsA` を使う形になっている。これ自体は正しいが、`await` がないため、テストの終了前に非同期エラーが検証されない可能性がある（`flutter_test` フレームワークは通常カバーするが、明示的に `await` することが推奨される）。

  ```dart
  // Before
  test('getPackages rethrows NetworkException', () {
    fakeApiClient.onGetPackages = ({String? pageUrl}) =>
        throw const NetworkException();

    expect(
      () => repository.getPackages(),
      throwsA(isA<NetworkException>()),
    );
  });

  // After
  test('getPackages rethrows NetworkException', () async {
    fakeApiClient.onGetPackages = ({String? pageUrl}) =>
        throw const NetworkException();

    await expectLater(
      () => repository.getPackages(),
      throwsA(isA<NetworkException>()),
    );
  });
  ```

  `getPackages rethrows ServerException` テスト（`test/features/package_list/repository/package_list_repository_test.dart:51-65`）も同様。

---

### Positive（良い実装）

- **API Response / UI State の分離が明確** — `PackageListResponse`（`fromJson` あり）と `PackageListState`（`fromJson` なし）が完全に分離されており、`pubdev-models` スキルのパターンに忠実に従っている。

- **`No interfaces` ルールを厳守** — `PackageListRepository` は具象クラスのみで定義されており、Fake は `FakePackageListRepository extends Fake implements PackageListRepository` で実装されている。CLAUDE.md の Critical Rules に完全準拠。

- **`No Either` ルールを厳守** — Repository・Notifier 共に例外ベースのエラーハンドリングを採用しており、`Result<T>` / `Either` 型は使用されていない。

- **`No premature core promotion` ルールを厳守** — `PackageListVersion` と `PackageDetailVersion` は API スキーマ上の差異（`package_url`/`url` vs `archive_sha256`/`published`）があり、同一クラスへの統合は誤り。feature 固有クラスとして分離した判断は正しい。

- **`FakePubDevApiClient` の設計が優秀** — コールバック (`onGetPackages`) と呼び出し履歴 (`getPackagesCalls`) を分離しており、テストの意図が明確に書ける。`pubdev-testing` パターンに沿っている。

- **`FakePackageListRepository` に `Completer` が用意されている** — 非同期タイミングを制御するテスト（ローディング中状態の検証等）のために `getPackagesCompleter` が用意されており、`package_list_notifier_test.dart` での高度なシナリオテストが書きやすい設計になっている。

- **`PackageListNotifier.loadMore()` のガード条件が適切** — `current == null || current.isLoadingMore || current.nextUrl == null` の3条件を冒頭でチェックしており、二重ロードや最終ページ後の余分なリクエストを防止している。

- **`PackageListVersion` の `@JsonKey` 使用が正確** — `archive_url` / `package_url` のスネークケースフィールドに `@JsonKey(name: ...)` が漏れなく付与されており、API スキーマとの整合が取れている。

- **フィクスチャの JSON 構造が `openapi.yaml` と整合している** — `packageListResponseJson` の全フィールド（`next_url`, `packages[].name`, `packages[].latest.version`, `archive_url`, `package_url`, `url`）が `PackageListVersion` スキーマ定義と一致している。

---

## 修正例

### 1. `loadMoreError` の型を `AppException?` に絞り込む

`lib/features/package_list/models/package_list_state.dart`:
```dart
import '../../../core/error/app_exception.dart';  // 追加

@freezed
abstract class PackageListState with _$PackageListState {
  const factory PackageListState({
    @Default([]) List<PackageListItem> packages,
    String? nextUrl,
    @Default(false) bool isLoadingMore,
    AppException? loadMoreError,  // Object? → AppException?
  }) = _PackageListState;
}
```

`lib/features/package_list/notifiers/package_list_notifier.dart`:
```dart
    } on AppException catch (e) {  // Exception → AppException
      state = AsyncData(
        current.copyWith(isLoadingMore: false, loadMoreError: e),
      );
    }
```

これにより Widget 側で exhaustive な switch が書ける:
```dart
switch (state.loadMoreError) {
  case NetworkException() => const Text('ネットワークエラー'),
  case ServerException(:final statusCode) => Text('サーバーエラー: $statusCode'),
  case null => const SizedBox.shrink(),
}
```

### 2. エラー系テストを `async` + `expectLater` に統一する

`test/features/package_list/repository/package_list_repository_test.dart`:
```dart
test('getPackages rethrows NetworkException', () async {
  fakeApiClient.onGetPackages = ({String? pageUrl}) =>
      throw const NetworkException();

  await expectLater(
    () => repository.getPackages(),
    throwsA(isA<NetworkException>()),
  );
});

test('getPackages rethrows ServerException', () async {
  fakeApiClient.onGetPackages = ({String? pageUrl}) =>
      throw const ServerException(500);

  await expectLater(
    () => repository.getPackages(),
    throwsA(
      isA<ServerException>().having(
        (e) => e.statusCode,
        'statusCode',
        500,
      ),
    ),
  );
});
```

### 3. `package:checks` の移行例（採用する場合）

`pubspec.yaml` の `checks: ^0.3.1` を活かすなら、`package_list_response_test.dart` を以下のように書き換える:

```dart
import 'package:checks/checks.dart';
// flutter_test の expect は不要になる

test('fromJson parses correctly', () {
  final response = PackageListResponse.fromJson(
    Map<String, dynamic>.from(packageListResponseJson),
  );

  check(response.nextUrl).isNotNull();
  check(response.packages).length.equals(2);
  check(response.packages[0].name).equals('http');
  check(response.packages[0].latest.version).equals('1.6.0');
  check(response.packages[1].name).equals('dio');
});
```

採用しない場合は `pubspec.yaml` から `checks: ^0.3.1` を削除して意図を明確にすること。
