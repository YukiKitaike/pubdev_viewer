# Phase 7: Test 層 レビュー結果

## 使用スキル
- `/pubdev-testing` — テストパターン（最重要）
- `/dart-matcher-best-practices` — アサーションの書き方
- `/flutter-dart-code-review` — Widget テストのベストプラクティス

## 対象ファイル

- `test/` 配下全ファイル（13 ファイル）

---

## LGTM（問題なし）

### Fake 設計（pubdev-testing で確認）
- **Fake パターン準拠**: `FakePackageListRepository`, `FakePackageDetailRepository`, `FakePubDevApiClient`, `FakeDio` — 全て `Fake + implements` パターン。`@GenerateMocks` なし ✅
- **コールバック設計**: `onGetPackages` 等のコールバックで挙動を設定、`getPackagesCallCount` 等で呼び出し追跡 ✅
- **Completer 制御**: `getPackagesCompleter` / `getPackageDetailCompleter` でローディング状態のテストが可能 ✅
- **mocks.dart**: mockito を残す理由がコメントで明示されている。現在 Mock は使用されていない ✅

### テストインフラ（flutter-dart-code-review で確認）
- **ProviderContainer.dispose()**: 全 Notifier テストで `tearDown(() { container.dispose(); })` が実装済み ✅
- **フィクスチャ共有**: `fixtures.dart` の `const Map<String, dynamic>` を全テストで使用。インライン JSON なし ✅
- **Map<String, dynamic>.from() コピー**: const マップを直接 `fromJson` に渡さず防御的コピーを徹底 ✅
- **createTestWidget()**: `appLightTheme` を渡し `AppThemeTokens` / `AppCardTheme` ThemeExtension が正しく適用される ✅
- **widget_test.dart**: 空テンプレートではなく `PubDevViewerApp` の統合スモークテストが実装済み ✅

### Notifier テストカバレッジ（pubdev-testing で確認）
| テスト | PackageListNotifier | PackageDetailNotifier |
|--------|--------------------|-----------------------|
| build 初期ロード | ✅ | ✅ |
| エラー時 AsyncError | ✅ | ✅ |
| loadMore 成功 | ✅ | — |
| loadMore nextUrl=null でスキップ | ✅ | — |
| loadMore エラー時データ保持 | ✅ | — |
| null publisherId 対応 | — | ✅ |

### Widget テストカバレッジ
| テスト | PackageListScreen | PackageDetailScreen |
|--------|------------------|--------------------|
| ローディング表示 | ✅ | ✅ |
| データ表示 | ✅ | ✅ |
| エラー表示 | ✅ | ✅ |
| リトライ動作 | ✅ | — |
| 外部リンクボタン表示 | — | ✅ |

### アサーション品質（dart-matcher-best-practices で確認）
- **isA<T>()**: `isA<NetworkException>()` / `isA<ServerException>().having(...)` パターンが正しく使用されている ✅
- **hasLength**: `expect(response.packages, hasLength(2))` — 推奨パターン ✅
- **AsyncError テスト**: `.then((_) => null).catchError((_) => null)` でエラー握り潰しパターンが正しく実装 ✅
- **ServerException.statusCode 検証**: `.having((e) => e.statusCode, 'statusCode', 404)` — 適切な `.having()` 使用 ✅

---

## 要修正

| # | 優先度 | 観点 | ファイル | 行番号 | 問題 | 修正方針 |
|---|--------|------|----------|--------|------|----------|
| 1 | Medium | テストカバレッジ | `test/features/package_list/notifiers/package_list_notifier_test.dart` | — | `refresh()` のテスト未実装。`ref.invalidateSelf()` 後に再ロードすることを検証するテストがない | `refresh()` テストを追加: 初期ロード後に `refresh()` を呼ぶと再度 build が実行されることを確認 |
| 2 | Medium | テストカバレッジ | `test/features/package_list/notifiers/package_list_notifier_test.dart` | — | `clearLoadMoreError()` のテスト未実装 | `loadMoreError` をセット後に `clearLoadMoreError()` を呼ぶと `null` に戻ることを確認するテストを追加 |
| 3 | Medium | テストカバレッジ | `test/features/package_list/notifiers/package_list_notifier_test.dart` | — | `loadMore` が `isLoadingMore: true` 中に呼ばれても no-op になることのテスト未実装 | Completer で `loadMore` を保留中に `loadMore()` を再度呼び、`getPackagesCallCount == 1` のままであることを確認 |
| 4 | Medium | テストカバレッジ | `test/features/package_detail/notifiers/package_detail_notifier_test.dart` | — | `refresh()` のテスト未実装 | `PackageDetailNotifier.refresh()` テストを追加 |

---

## 要検討（Low）

| # | 優先度 | 観点 | ファイル | 行番号 | 問題 | 修正方針 |
|---|--------|------|----------|--------|------|----------|
| 1 | Low | アサーション一貫性 | `test/features/package_list/notifiers/package_list_notifier_test.dart` | L63-65 | `expect(state?.packages, hasLength(2))` — nullable アクセス演算子の使用。`state` が null の場合のエラーメッセージが `null.hasLength(2)` で分かりにくい。L107-111 の `expect(state, isNotNull); expect(state!.packages, ...)` パターンと不統一 | `expect(state, isNotNull); expect(state!.packages, hasLength(2));` に統一 |

---

## 修正結果

| # | 修正内容 | コミット |
|---|----------|---------|
| 1-4 | テストケースの追加（refresh, clearLoadMoreError, loadMore ガード） | Phase 8 でコミット |

---

## メモ（将来の参考）

- テスト名が英語（`'build fetches initial packages'`）で統一されている。pubdev-testing スキルのサンプルは日本語だが、英語テスト名は国際的に一般的。現状維持でよい
- `FakePackageDetailRepository.getPackagePublisher()` には `Completer` がない。publisher のローディング状態を個別にテストしたい場合は `getPublisherCompleter` の追加が必要になる（現時点では不要）
- `package_list_notifier_test.dart` の `loadMore appends packages` テストで `_lastPage()` が空リストを返すため `hasLength(2)` の期待値が正しい（page1: http + dio = 2件、page2: 空）
