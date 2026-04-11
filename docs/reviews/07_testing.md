# テスト

> 対象セクション: テスト
> レビュー日: 2026-04-11

## サマリー

| 重要度 | 件数 |
|--------|------|
| Critical | 0 |
| Important | 6 |
| Minor | 2 |
| Good | 4 |

テストの基盤は整っており、AAA パターン、ディレクトリ構造、非同期テストのパターンが適切。ただし、flutter.md が要求するテスト種別・ツール・カバレッジに対して不足がある。特に統合テスト・ゴールデンテストの未実装、`package:checks` の未使用、エラーパステストの不足が目立つ。

## 指摘事項

### [Important] 統合テスト（integration_test）が未実装

- **対象ファイル:** プロジェクト全体（`integration_test/` ディレクトリが存在しない）
- **ガイドライン参照:** flutter.md > テスト > 統合テスト（`package:integration_test` を使用。エンドツーエンドのユーザーフローを検証）
- **現状:** `integration_test/` ディレクトリが存在せず、統合テストが一切実装されていない。`pubspec.yaml` の `dev_dependencies` にも `integration_test` パッケージが含まれていない。
- **リスク:** 画面遷移を含むエンドツーエンドのユーザーフロー（一覧画面 → 詳細画面 → 戻る）が検証されていない。Widget テストではカバーできない実際のナビゲーションやプラットフォーム固有の挙動が未検証。
- **推奨対応:**
  1. `pubspec.yaml` に `integration_test` を追加:
     ```yaml
     dev_dependencies:
       integration_test:
         sdk: flutter
     ```
  2. `integration_test/` ディレクトリを作成し、基本フローのテストを実装

### [Important] ゴールデンテストが未実装

- **対象ファイル:** `test/` 全体
- **ガイドライン参照:** flutter.md > テスト（`docs/overview.md` のチャレンジ項目にもゴールデンテストが記載）
- **現状:** ゴールデンテスト（UI のスナップショットテスト）が一切実装されていない。
- **リスク:** UI の意図しない変更（レイアウト崩れ、テキスト変更等）をテストで検出できない。
- **推奨対応:** 主要画面（パッケージ一覧、パッケージ詳細）のゴールデンテストを追加。
  ```dart
  testWidgets('package list screen golden test', (tester) async {
    // ... setup
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(PackageListScreen),
      matchesGoldenFile('goldens/package_list_screen.png'),
    );
  });
  ```

### [Important] package:checks が未使用

- **対象ファイル:** 全テストファイル
- **ガイドライン参照:** flutter.md > テスト > アサーション（デフォルトの matchers よりも `package:checks` の使用を推奨）
- **現状:** 全テストが `expect()` + `package:matcher` の標準アサーションを使用。`package:checks` は `pubspec.yaml` にも含まれていない。
  ```dart
  // 現状
  expect(response.packages, hasLength(2));
  expect(response.packages[0].name, 'http');
  ```
- **リスク:** flutter.md が明示的に推奨するアサーションライブラリが未採用。`package:checks` はより型安全で表現力豊かなアサーションを提供する。
- **推奨対応:**
  1. `pubspec.yaml` に `checks` を追加:
     ```yaml
     dev_dependencies:
       checks: ^0.3.0
     ```
  2. 新規テストから段階的に移行:
     ```dart
     // package:checks
     check(response.packages).length.equals(2);
     check(response.packages[0].name).equals('http');
     ```

### [Important] Mock vs Fake/Stub の方針不一致

- **対象ファイル:** `test/helpers/mocks.dart`, 全テストファイル
- **ガイドライン参照:** flutter.md > テスト > Mock（Mock よりも Fakes や Stubs を優先。どうしても Mock が必要な場合は `mockito` を使用）
- **現状:** 全テストが `mocktail` の `Mock` クラスのみを使用。Fake や Stub は実装されていない。
  ```dart
  class MockPubDevApiClient extends Mock implements PubDevApiClient {}
  class MockPackageListRepository extends Mock implements PackageListRepository {}
  class MockPackageDetailRepository extends Mock implements PackageDetailRepository {}
  ```
  また、flutter.md は Mock が必要な場合に `mockito` を推奨しているが、実際には `mocktail` が使用されている。

  **注意:** CLAUDE.md では「テスト時は mocktail 等でクラスごとモックする」と記載されており、flutter.md との間に矛盾がある。
- **リスク:** ガイドライン間の不整合により、テスト方針が不明確。
- **推奨対応:** flutter.md と CLAUDE.md のテスト方針を統一する。以下のいずれかを選択:
  - **案A:** flutter.md を更新し、`mocktail` を正式に採用する（CLAUDE.md と整合）
  - **案B:** flutter.md の方針に従い、Repository の Fake 実装を作成し、Mock の使用を最小化する

### [Important] エラーパステストの不足

- **対象ファイル:** `test/features/**/repository/*_test.dart`, `test/features/**/notifiers/*_test.dart`
- **ガイドライン参照:** flutter.md > テスト > カバレッジ（高いテストカバレッジを目指す）
- **現状:** Repository テストと Notifier テストでハッピーパスのみがテストされており、エラーパス（例外発生時）のテストが存在しない。
  - `PackageListRepository`: `getPackages` の成功のみ。`NetworkException` / `ServerException` 発生時のテストなし
  - `PackageDetailRepository`: `getPackageDetail` / `getPackagePublisher` の成功のみ
  - `PackageListNotifier`: `build` と `loadMore` の成功のみ。例外発生時の状態遷移テストなし
  - `PackageDetailNotifier`: `build` の成功のみ。片方の API が失敗した場合のテストなし
- **リスク:** エラーハンドリングのバグ（04_state_management.md の Critical で指摘した `loadMore` の問題等）がテストで検出されない。
- **推奨対応:** 各テストファイルにエラーパステストを追加:
  ```dart
  test('getPackages throws NetworkException on connection error', () async {
    when(() => mockApiClient.getPackages())
        .thenThrow(const NetworkException());
    expect(
      () => repository.getPackages(),
      throwsA(isA<NetworkException>()),
    );
  });
  ```

### [Important] PubDevApiClient のテストが未実装

- **対象ファイル:** `test/core/api/`（ディレクトリは存在するがテストファイルがない）
- **ガイドライン参照:** flutter.md > テスト > ユニットテスト（データレイヤーに対して記述）
- **現状:** `PubDevApiClient` はアプリの全ての API 通信を担当する中核クラスだが、ユニットテストが存在しない。
- **リスク:** API クライアントのエラーハンドリングロジック（`DioException` → `AppException` 変換）が未検証。
- **推奨対応:** Dio の Mock を使用して、各種レスポンス・エラーに対する挙動をテスト。

### [Minor] widget_test.dart がデフォルトテンプレートの残骸

- **対象ファイル:** `test/widget_test.dart`
- **ガイドライン参照:** flutter.md > テスト
- **現状:** Flutter プロジェクト作成時に自動生成されるデフォルトテストがカスタマイズされて残っている。テスト内容は「アプリが起動してタイトルが表示される」という基本的な確認のみ。
- **リスク:** テストスイートの意図が不明確。他の画面別テストと役割が重複。
- **推奨対応:** より意味のあるアプリ起動テストに書き直すか、`package_list_screen_test.dart` に統合して削除。

### [Minor] テストヘルパーの fixtures が Map リテラルで定義

- **対象ファイル:** `test/helpers/fixtures.dart`
- **ガイドライン参照:** flutter.md > テスト > パターン
- **現状:** テスト用 JSON データが Dart の Map リテラルとして定義されている。実際の API レスポンスとの乖離が発生する可能性がある。
- **リスク:** API レスポンス形式の変更時に fixture の更新漏れが起こりうる。ただし、現状の規模では実用上の問題は軽微。
- **推奨対応:** 現状維持で問題ないが、将来的には JSON ファイルからの読み込みに切り替えることで、実際の API レスポンスとの一致性を高められる。

### [Good] テストディレクトリ構造が lib/ と対応

- **説明:** `test/features/package_list/models/`, `test/features/package_list/repository/` 等、テストファイルの配置が `lib/` の構造と1対1で対応している。flutter.md の「テストフォルダの階層は実装クラスと同じ階層で配置」に準拠。

### [Good] test/helpers/ によるテストユーティリティの分離

- **説明:** `test/helpers/fixtures.dart`（テストデータ）と `test/helpers/mocks.dart`（モッククラス）が共有ヘルパーとして適切に分離されている。各テストファイルからの重複定義を防止。

### [Good] Completer による非同期タイミング制御

- **説明:** Widget テストで `Completer<T>` を使用して非同期処理のタイミングを制御している。ローディング状態のテストで、API レスポンスの完了タイミングを明示的にコントロールしている。

### [Good] Arrange-Act-Assert パターンの一貫した使用

- **説明:** 全テストで AAA パターンが一貫して使用されている。`setUp` でモック設定（Arrange）、テスト本体でアクション実行（Act）、`expect` / `verify` で検証（Assert）の流れが明確。

## 次のアクション

- [ ] `integration_test/` ディレクトリを作成し、基本ユーザーフローの統合テストを実装
- [ ] 主要画面のゴールデンテストを追加
- [ ] `package:checks` を `dev_dependencies` に追加し、新規テストから段階的に移行
- [ ] flutter.md と CLAUDE.md のテスト方針（Mock vs Fake, mocktail vs mockito）を統一
- [ ] Repository / Notifier テストにエラーパステストを追加
- [ ] `PubDevApiClient` のユニットテストを `test/core/api/` に作成
