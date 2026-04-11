# Phase 3: package_list Notifier & Screen レビュー結果

## 使用スキル
- `pubdev-state` — AsyncNotifier・loadMore・refresh の設計
- `flutter-riverpod-expert` — `ref.watch` vs `ref.read` の使い分け
- `pubdev-ui` — デザイントークン使用（AppSpacing）
- `flutter-dart-code-review` — Widget ベストプラクティス
- `dart-new-syntax` — Dot shorthands の活用

---

## 発見事項

### Critical（修正必須）

- [x] **テストのアイコン不一致** — `test/features/package_list/screens/package_list_screen_test.dart:85` —
  実装の `ErrorView` は `Icons.cloud_off_rounded` を使用しているのに対し、テストは `Icons.error_outline` を検索している。このテストは現在必ずパスしない（または golden 更新まで潜在的なバグを隠蔽する）。
  ```dart
  // テスト（誤）
  expect(find.byIcon(Icons.error_outline), findsOneWidget);

  // 実装（正）
  // lib/core/widgets/error_view.dart:50
  Icons.cloud_off_rounded,

  // 修正後
  expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);
  ```

---

### Major（強く推奨）

- [x] **`on Exception` が `Error` サブクラスを取り逃す** — `lib/features/package_list/notifiers/package_list_notifier.dart:49` — **対応済み**: `on Object catch (e)` に変更。
  Dart の `Error` 系（`StateError`, `AssertionError`, `RangeError` 等）は `Exception` を実装しておらず、現在の catch 節では補足されない。補足されなかった `Error` は `AsyncError` に変換されず、`loadMore` 中のスタックが壊れたまま後続のビルドに影響する可能性がある。
  ```dart
  // 現状
  } on Exception catch (e) {
    state = AsyncData(current.copyWith(isLoadingMore: false, loadMoreError: e));
  }

  // 推奨: Object で受けて Exception キャストで保存
  } catch (e) {
    final error = e is Exception ? e : Exception(e.toString());
    state = AsyncData(current.copyWith(isLoadingMore: false, loadMoreError: error));
  }
  // あるいはプロジェクト内の AppException 階層に揃えるなら:
  // } on AppException catch (e) { ... } on Object catch (e, st) { Error.throwWithStackTrace(e, st); }
  ```
  対応するノーテストケース: Notifier テストに `StateError` を投げるケースが存在しない（`test/features/package_list/notifiers/package_list_notifier_test.dart:93–113`）。

- [ ] **ハードコードされた `padding` 数値 — `top: 8`** — `lib/features/package_list/screens/package_list_screen.dart:111` —
  `EdgeInsets.only(top: 8, ...)` が `AppSpacing.sm` を使わずに直書きされており CLAUDE.md の「No hardcoded colors/spacing」に違反する。
  ```dart
  // 現状
  padding: EdgeInsets.only(
    top: 8,
    bottom: 16 + MediaQuery.paddingOf(context).bottom,
  ),

  // 修正後
  padding: EdgeInsets.only(
    top: AppSpacing.sm,
    bottom: AppSpacing.lg + MediaQuery.paddingOf(context).bottom,
  ),
  ```
  `bottom: 16` も同様に `AppSpacing.lg` に統一する。

- [ ] **ハードコードされた `padding` 数値 — `EdgeInsets.all(16)` （ローディングインジケーター）** — `lib/features/package_list/screens/package_list_screen.dart:118` —
  無限スクロール中のローディング `CircularProgressIndicator` の padding が直書き。
  ```dart
  // 現状
  padding: EdgeInsets.all(16),

  // 修正後
  padding: const EdgeInsets.all(AppSpacing.lg),
  // const も付与可能になる
  ```

- [ ] **`_gradient` getter がビルドごとに hash 計算** — `lib/features/package_list/screens/widgets/package_list_tile.dart:25–28` —
  `codeUnits.fold` によるハッシュ計算はリスト再ビルドのたびに（スクロール時も含め）実行される。`package.name` は不変であるため、`State` の `initState` で `late final` フィールドに一度だけ計算するべきである。
  ```dart
  // 現状: ビルドごとに計算
  List<Color> get _gradient {
    final hash = widget.package.name.codeUnits.fold(0, (a, b) => a + b);
    return AppColors.avatarGradients[hash % AppColors.avatarGradients.length];
  }

  // 修正後: State 初期化時に一度だけ計算
  late final List<Color> _gradient;

  @override
  void initState() {
    super.initState();
    final hash = widget.package.name.codeUnits.fold(0, (a, b) => a + b);
    _gradient = AppColors.avatarGradients[hash % AppColors.avatarGradients.length];
  }
  ```

---

### Minor（改善提案）

- [ ] **`PackageListTile` を `StatelessWidget` 化できる** — `lib/features/package_list/screens/widgets/package_list_tile.dart:10–20` —
  `_pressed` 状態は `InkWell.onHighlightChanged` で `AnimatedScale` を駆動するためだけに使われている。`StatefulWidget` を維持する必要はあるが、`_gradient` の `late final` 化（上記 Major 参照）によって `initState` が必要なため、現状では `StatefulWidget` のほうが自然。ただし将来的に gradient を `PackageListItem` モデル側で保持（`computedGradient` フィールド等）すれば `StatelessWidget` + `ValueNotifier` パターンに移行できる。

- [ ] **`AppColors.avatarGradients` へのインデックスアクセスで境界チェックなし** — `lib/features/package_list/screens/widgets/package_list_tile.dart:27` —
  `hash % AppColors.avatarGradients.length` は `length == 0` のとき `RangeError` になる。現実的には発生しないが、防御的に `assert` を追加しておくと安全。

- [x] **ウィジェットテストでテーマ未設定** — `test/features/package_list/screens/package_list_screen_test.dart:21–29` — **対応済み**: `MaterialApp(theme: appLightTheme, ...)` を追加。
  `createTestWidget()` が `MaterialApp` を使用しており `appLightTheme` を適用していない。`context.tokens` はフォールバック値（デフォルトのカラースキーム）に依存するため、golden テストとの見た目の差異が生じる可能性がある。
  ```dart
  // 推奨
  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        packageListRepositoryProvider.overrideWithValue(fakeRepository),
      ],
      child: MaterialApp(
        theme: appLightTheme,  // テーマ適用
        home: const PackageListScreen(),
      ),
    );
  }
  ```

- [ ] **Notifier テストに `on Exception` 範囲外エラーのケースがない** — `test/features/package_list/notifiers/package_list_notifier_test.dart` —
  `StateError` など `Exception` でないエラーが `loadMore` 中に投げられた場合の挙動テストが存在しない。Major の `on Exception → catch` 修正と対で追加すべき。

- [ ] **`AppSpacing.sm - 2` という魔法の計算** — `lib/features/package_list/screens/widgets/package_list_tile.dart:39` / `135` —
  `AppSpacing.sm - 2`（= 6dp）は 4dp グリッド外の値である。`AppSpacing.xs`（4dp）か `AppSpacing.sm`（8dp）への統一、もしくは中間値 `6dp` をデザイントークンに追加する（例: `AppSpacing.smNarrow = 6`）ことを検討する。

- [ ] **`Colors.white` のハードコード** — `lib/features/package_list/screens/widgets/package_list_tile.dart:87` —
  アバター文字色が `Colors.white` で固定されている。グラデーション色によっては白が読みにくい場合があり、`colorScheme.onPrimary` または輝度に基づく動的色を使用するほうが堅牢。

- [ ] **`ref.listen` のコールバック内で `ScaffoldMessenger` への同期アクセス** — `lib/features/package_list/screens/package_list_screen.dart:37–50` —
  `ref.listen` のコールバックはビルドフェーズ外で呼ばれるため現状は正しいが、`clearLoadMoreError()` を同じコールバック内で即時呼び出すことで「listen → snackbar 表示 → 状態更新 → listen 再発火」の連鎖リスクがある。現状の実装では `loadMoreError` を `null` にするだけなので再発火はしないが、将来の変更時に注意が必要。コメントで意図を明記しておくとよい。

---

### Positive（良い実装）

- **`ref.watch` / `ref.read` の使い分けが正確**: `build()` 内での `ref.watch(packageListRepositoryProvider)` と `loadMore()` 内での `ref.read(packageListRepositoryProvider)` の使い分けが正しく実装されており、不要な再ビルドを防いでいる。

- **`loadMore()` のガード条件が堅牢**: `current == null || current.isLoadingMore || current.nextUrl == null` の三重チェックが適切に実装されており、重複リクエストや不正な状態遷移を防いでいる（`package_list_notifier.dart:25`）。

- **`refresh()` が `ref.invalidateSelf()` + `await future` パターンを採用**: `ref.invalidateSelf()` で状態をリセットし、`await future` で完了を待つ正しいパターン（`package_list_notifier.dart:65–67`）。

- **Dot shorthands の活用**: `switch (themeMode) { .dark => ..., _ => ... }` が正しく使われており（`package_list_screen.dart:85–93`）、`dart-new-syntax` スキルの推奨パターンに準拠している。

- **`FakePackageListRepository` の設計が優れている**: `Completer<PackageListResponse>` による非同期タイミング制御と `onGetPackages` コールバックによる柔軟な挙動設定が共存しており、ローディング中・データ取得後・エラー時のテストシナリオを網羅しやすい設計（`test/helpers/fakes.dart:70–83`）。

- **`clearLoadMoreError()` を Notifier 側に持ち、`ref.listen` から呼ぶ設計が明確**: SnackBar 表示のタイミング制御と状態クリアの責務分離が適切（`package_list_screen.dart:37–50`、`package_list_notifier.dart:56–62`）。

- **`HookConsumerWidget` + `useScrollController` + `useEffect` の組み合わせが適切**: スクロールリスナーのライフサイクルが `useEffect` のクリーンアップ関数で正しく管理されており、メモリリークがない（`package_list_screen.dart:20–35`）。

- **デザイントークンの一貫した使用（Tile 内）**: `PackageListTile` の主要な spacing・radius は `AppSpacing.*`、`AppRadius.*` のトークンで統一されており（`package_list_tile.dart:36–79`）、ハードコード違反は `sm - 2` の 2 箇所のみ。

---

## 修正例

### Critical: テストのアイコン修正

```dart
// test/features/package_list/screens/package_list_screen_test.dart:85
// 修正前
expect(find.byIcon(Icons.error_outline), findsOneWidget);

// 修正後
expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);
```

### Major: `on Exception` → `catch` への変更 + テスト追加

```dart
// lib/features/package_list/notifiers/package_list_notifier.dart
// 修正前
} on Exception catch (e) {
  state = AsyncData(
    current.copyWith(isLoadingMore: false, loadMoreError: e),
  );
}

// 修正後
} catch (e) {
  // Exception でない Error (StateError 等) も含めてハンドル
  final wrapped = e is Exception ? e : Exception(e.toString());
  state = AsyncData(
    current.copyWith(isLoadingMore: false, loadMoreError: wrapped),
  );
}
```

対応テスト追加例:
```dart
test('loadMore handles non-Exception errors', () async {
  var callCount = 0;
  fakeRepository.onGetPackages = ({String? pageUrl}) async {
    callCount++;
    if (callCount == 1) return _firstPage();
    throw StateError('unexpected state');  // Exception ではない Error
  };

  await container.read(packageListNotifierProvider.future);
  await container.read(packageListNotifierProvider.notifier).loadMore();

  final state = container.read(packageListNotifierProvider).valueOrNull;
  expect(state, isNotNull);
  expect(state!.isLoadingMore, isFalse);
  expect(state.loadMoreError, isNotNull);
});
```

### Major: Screen の padding をトークン化

```dart
// lib/features/package_list/screens/package_list_screen.dart
// 修正前
padding: EdgeInsets.only(
  top: 8,
  bottom: 16 + MediaQuery.paddingOf(context).bottom,
),
// ...
padding: EdgeInsets.all(16),

// 修正後
padding: EdgeInsets.only(
  top: AppSpacing.sm,
  bottom: AppSpacing.lg + MediaQuery.paddingOf(context).bottom,
),
// ...
padding: const EdgeInsets.all(AppSpacing.lg),
```

### Major: `_gradient` の `late final` 化

```dart
// lib/features/package_list/screens/widgets/package_list_tile.dart
class _PackageListTileState extends State<PackageListTile> {
  bool _pressed = false;
  late final List<Color> _gradient;  // ← late final に変更

  @override
  void initState() {
    super.initState();
    final hash = widget.package.name.codeUnits.fold(0, (a, b) => a + b);
    _gradient = AppColors.avatarGradients[hash % AppColors.avatarGradients.length];
  }

  // getter を削除
  // ...
}
```

---

## 優先度サマリー

| 優先度 | 件数 | 内容 |
|--------|------|------|
| Critical | 1 | テストのアイコン不一致（テストが常に失敗） |
| Major | 4 | `on Exception` の範囲、spacing ハードコード×2、`_gradient` 計算コスト |
| Minor | 6 | テーマ未適用、テストケース不足、`sm - 2` 魔法数、`Colors.white`、`ref.listen` コメント、アバターグラデーション境界チェック |
