# Phase 4: Notifier 層 レビュー結果

## 使用スキル
- `/pubdev-state` — AsyncNotifier パターン（最重要）
- `/flutter-riverpod-expert` — ref.watch/read の使い分け
- `/dart-best-practices` — Dart 3.x 構文

## 対象ファイル

- `lib/features/package_list/notifiers/package_list_notifier.dart`
- `lib/features/package_detail/notifiers/package_detail_notifier.dart`

---

## LGTM（問題なし）

### ref.watch/read の使い分け（pubdev-state で確認）
- **PackageListNotifier.build()** L16: `ref.watch(packageListRepositoryProvider)` → build() 内で watch。正しい ✅
- **PackageListNotifier.loadMore()** L35: `ref.read(packageListRepositoryProvider)` → メソッド内で read。正しい ✅
- **PackageDetailNotifier.build()** L15: `ref.watch(packageDetailRepositoryProvider)` → build() 内で watch。正しい ✅

### AsyncNotifier パターン（pubdev-state で確認）
- **PackageListNotifier**: `@riverpod class` + `AsyncNotifier<PackageListState>` パターン準拠 ✅
- **PackageDetailNotifier**: パラメータ付き `build(String packageName)` で Family パターンを正しく実装 ✅

### 並列フェッチ（pubdev-state `.wait` パターン）
- **PackageDetailNotifier.build()** L18-21: `(detail, publisher) = await (...).wait` で並列フェッチ ✅
- Records の分割代入が正しく機能 ✅

### ページネーションの Guard（pubdev-state で確認）
- **PackageListNotifier.loadMore()** L26: Guard 条件 3 つ（`current == null`、`isLoadingMore`、`nextUrl == null`）が全てチェックされている ✅
- `isLoadingMore` フラグの設定（L30）・解除（エラー時 L53-54）が対称 ✅

### リフレッシュパターン（pubdev-state で確認）
- **PackageListNotifier.refresh()** L67-69: `ref.invalidateSelf(); await future;` パターン ✅
- **PackageDetailNotifier.refresh()** L28-30: 同パターン ✅

### clearLoadMoreError
- **PackageListNotifier.clearLoadMoreError()** L59-65: `state.valueOrNull == null` の early return あり ✅
- Screen 側で SnackBar 表示後に必ず呼ばれる設計（Phase 5 で確認済み）✅

### No UseCase ルール
- Notifier が Repository を直接呼ぶ。中間層なし ✅

### エラーハンドリング（pubdev-state との差異）
- **`on Object catch` の使用（L50）**: pubdev-state スキルは `on Exception catch` だが、実装は `on Object` でコメントに意図が明記（"Exception でない Error（StateError 等）も含めてキャッチする"）。より広いキャッチで堅牢性向上 ✅
- **AppException への変換（L52）**: `e is AppException ? e : NetworkException(e.toString())` で型安全化 ✅

---

## 要修正

なし

---

## 要検討（Low）

| # | 優先度 | 観点 | ファイル | 行番号 | 問題 | 修正方針 |
|---|--------|------|----------|--------|------|----------|
| 1 | Low | エラーメッセージ | `lib/features/package_list/notifiers/package_list_notifier.dart` | L52 | `NetworkException(e.toString())` で変換する際、`e.toString()` に内部情報（クラス名・スタックトレース断片）が含まれる可能性。ただし UI には `AppStrings.errorMessageLoadMoreFailed` が表示されるため実際の露出はない | 現状維持。`e.toString()` はログ目的で使用されておらず UI 表示もされないため問題なし |

---

## 修正結果

| # | 修正内容 | コミット |
|---|----------|---------|
| — | 修正なし | — |

---

## メモ（将来の参考）

- `PackageDetailNotifier.build()` で `.wait` を使った並列フェッチは、どちらか一方が例外をスローすると全体が `AsyncError` になる。`publisher` が 404 を返した場合もエラー画面になる設計（現仕様では OK: publisher が取れない場合はエラー表示が望ましい）
- ページネーション中に `refresh()` が呼ばれた場合: `invalidateSelf()` で `state` が `AsyncLoading` に遷移し、`loadMore()` の残りの `state = AsyncData(...)` が実行されても Riverpod が最終的な整合状態を保証するため、実質的なレースコンディションは発生しない
