# 状態管理・データフロー

> 対象セクション: 状態管理 / データフロー
> レビュー日: 2026-04-11

## サマリー

| 重要度 | 件数 |
|--------|------|
| Critical | 1 |
| Important | 1 |
| Minor | 0 |
| Good | 6 |

Riverpod による状態管理の基盤は非常に高品質。`riverpod_generator` / `riverpod_lint` / `hooks_riverpod` の3点セットが正しく導入され、freezed による不変データクラスも適切に活用されている。ただし、`loadMore()` のエラーハンドリングに設計上の問題がある。

## 指摘事項

### [Critical] loadMore() のエラーハンドリングで状態が不整合になる

- **対象ファイル:** `lib/features/package_list/notifiers/package_list_notifier.dart:48-52`
- **ガイドライン参照:** flutter.md > 状態管理 > Riverpod をフル活用
- **現状:**
  ```dart
  } on Exception catch (e, st) {
    state = AsyncData(
      current.copyWith(isLoadingMore: false),
    );
    state = AsyncError(e, st);
  }
  ```
  catch 節で `state = AsyncData(...)` を設定した直後に `state = AsyncError(e, st)` で上書きしている。`AsyncData` の設定は即座に `AsyncError` で置き換えられるため無意味。さらに、`AsyncError` に遷移すると、それまで表示されていたパッケージリストのデータが失われ、画面全体がエラー表示に切り替わる。
- **リスク:**
  1. 追加読み込みの失敗で、既に読み込み済みのデータが全て消失する
  2. ユーザーがスクロールして蓄積したデータが失われ、UX が著しく低下する
  3. `AsyncData` → `AsyncError` の連続代入は Flutter の状態通知を不必要に2回発火させる
- **推奨対応:** 追加読み込みのエラーは、既存データを保持したまま `isLoadingMore` をリセットし、エラーを別の方法で通知する。
  ```dart
  } on Exception catch (e, st) {
    // 既存データを保持し、読み込み中フラグのみリセット
    state = AsyncData(
      current.copyWith(isLoadingMore: false),
    );
    // エラーは state に含めるか、別途 SnackBar 等で通知
    // 例: state にエラー情報を持たせる場合
    // state = AsyncData(
    //   current.copyWith(isLoadingMore: false, loadMoreError: e),
    // );
  }
  ```
  より堅牢にするなら、`PackageListState` に `Object? loadMoreError` フィールドを追加し、画面側で SnackBar 等によるエラー通知を実装する。

### [Important] Notifier の loadMore エラーで既存データが消失する設計

- **対象ファイル:** `lib/features/package_list/notifiers/package_list_notifier.dart:20-54`
- **ガイドライン参照:** flutter.md > 状態管理 > Riverpod のパターン
- **現状:** 上記 Critical と関連。`loadMore()` がページネーション（追加読み込み）を担当しているが、エラー発生時に `AsyncError` に遷移するため、`asyncState.when()` の `error` コールバックが発火し、画面全体が `ErrorView` に置き換わる。
- **リスク:** 初回読み込みのエラーと追加読み込みのエラーが同じ `AsyncError` で表現されるため、画面側でエラーの種類を区別できない。
- **推奨対応:** 初回読み込み（`build`）のエラーは `AsyncError` のまま、追加読み込み（`loadMore`）のエラーは `PackageListState` の中で表現する。
  ```dart
  @freezed
  abstract class PackageListState with _$PackageListState {
    const factory PackageListState({
      @Default([]) List<PackageListItem> packages,
      String? nextUrl,
      @Default(false) bool isLoadingMore,
      Object? loadMoreError, // 追加
    }) = _PackageListState;
  }
  ```

### [Good] riverpod_generator + riverpod_lint + hooks_riverpod の導入

- **説明:** flutter.md が要求する3パッケージが全て `pubspec.yaml` に含まれている。`@riverpod` アノテーションによるコード生成が全 Notifier・Provider で使用されており、ボイラープレートが最小化されている。

### [Good] Dart Records + .wait による並列 API 呼び出し

- **説明:** `PackageDetailNotifier.build()` で以下のパターンが使用されている:
  ```dart
  final (detail, publisher) = await (
    repository.getPackageDetail(packageName),
    repository.getPackagePublisher(packageName),
  ).wait;
  ```
  Dart 3 の Records と並列 await を活用した、モダンで効率的な非同期パターン。

### [Good] freezed による不変データクラス

- **説明:** 全モデルクラス（`PackageListResponse`, `PackageListItem`, `PackageListState`, `PackageDetailResponse` 等）で `@freezed` アノテーションが使用されている。flutter.md の「freezed パッケージを活用してデータ構造を定義」に完全準拠。`copyWith` による安全な状態更新も活用されている。

### [Good] Repository → Provider の DI パターン

- **説明:** 各 Repository が Riverpod Provider として公開され、Notifier から `ref.watch()` / `ref.read()` で取得されている。flutter.md の「Riverpod の Ref をサービスロケーターとして使用」に合致。テスト時は `overrideWithValue` で容易にモック差し替えが可能。

### [Good] ref.watch() と ref.read() の適切な使い分け

- **説明:** `build()` メソッド内では `ref.watch()` でリアクティブな依存関係を確立し、`loadMore()` 等のユーザーアクション起因のメソッド内では `ref.read()` で1回だけ値を取得している。Riverpod の推奨パターンに正確に準拠。

### [Good] State クラスによるUI状態の明示的管理

- **説明:** `PackageListState` と `PackageDetailState` で UI に必要な状態（`isLoadingMore`, `nextUrl` 等）が明示的に定義されている。`AsyncValue<State>` でラップすることで、ロード中・成功・エラーの3状態が型安全に管理されている。

## 次のアクション

- [ ] `loadMore()` のエラーハンドリングを修正し、既存データを保持する設計に変更
- [ ] `PackageListState` に `loadMoreError` フィールドを追加し、画面側でエラー通知を実装
