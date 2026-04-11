# Phase 5: Screen / Widget 層 レビュー結果

## 使用スキル
- `/pubdev-ui` — デザイントークン・テーマ・Widget パターン（最重要）
- `/flutter-dart-code-review` — Widget ベストプラクティス
- `/flutter-riverpod-expert` — HookConsumerWidget / ConsumerWidget の使い分け

## 対象ファイル

- `lib/features/package_list/screens/package_list_screen.dart`
- `lib/features/package_list/screens/widgets/package_list_tile.dart`
- `lib/features/package_detail/screens/package_detail_screen.dart`
- `lib/features/package_detail/screens/widgets/overview_section.dart`
- `lib/features/package_detail/screens/widgets/versions_section.dart`
- `lib/features/package_detail/screens/widgets/section_header.dart`

---

## LGTM（問題なし）

### デザイントークン準拠（pubdev-ui で確認）
- **PackageListScreen**: `AppSpacing.sm`, `AppSpacing.lg`, `MediaQuery.paddingOf` で safe area 対応 ✅
- **PackageListTile**: `AppSpacing.lg/md/sm/xs`, `AppRadius.card/avatar/full`, `AppTextSize.mono10`, `tokens.surface/cardBorder`, `cardElevatedShadow()` を全て使用 ✅
- **PackageDetailScreen._PackageHeroHeader**: `AppSpacing.xl/xxl/md/sm/xs`, `AppRadius.full`, `AppTextSize.mono14`, `context.tokens.border` を使用 ✅
- **OverviewSection**: `AppCardTheme` 拡張から `cardTheme.margin/padding` を使用 ✅
- **VersionsSection**: `AppCardTheme`, `AppSpacing.lg/sm/md`, `AppRadius.full`, `AppTextSize.mono10/12` を使用 ✅

### ref パターン（flutter-riverpod-expert で確認）
- **PackageListScreen**: `ref.watch()` で状態購読、`ref.listen()` で SnackBar 副作用、`ref.read().notifier` でメソッド呼び出し ✅
- **PackageDetailScreen**: `ref.watch()` / `ref.read().notifier` の正しい使い分け ✅
- **RefreshIndicator**: `onRefresh` が `ref.read().notifier.refresh()` を呼び、`Future` を返す設計 ✅

### アクセシビリティ
- **テーマトグルボタン**: `tooltip: AppStrings.labelDarkMode / labelLightMode` ✅
- **_ShareButton**: `tooltip: AppStrings.labelShare` ✅
- **_ExternalLinkButton**: `tooltip: AppStrings.labelOpenExternal` ✅
- **context.mounted チェック**: `launchUrl` コールバックで `context.mounted` 確認済み ✅

### Widget 設計（flutter-dart-code-review で確認）
- **PackageListScreen**: `HookConsumerWidget` を使用（`useScrollController` + `useEffect` のため正しい選択）✅
- **PackageListTile**: `StatefulWidget` で `_gradient` キャッシュ + `_pressed` アニメーション状態管理。`didUpdateWidget` でパッケージ名変更時に再計算 ✅
- **OverviewSection / VersionsSection / SectionHeader**: 全て `StatelessWidget`（const コンストラクタ）✅
- **_PackageHeroHeader / _ShareButton / _ExternalLinkButton**: プライベートクラスとして分割（ヘルパーメソッドではなくクラス）✅

### スクロール & UX
- **loadMore trigger**: `scrollController.position.pixels >= maxScrollExtent - 200` の適切なプリフェッチ閾値 ✅
- **loadMore SnackBar**: `clearLoadMoreError()` をスナックバー表示後に必ず呼ぶ設計 ✅
- **VersionsSection.DateFormat**: `static final` でビルドごとに再生成しない設計 ✅

---

## 要修正

| # | 優先度 | 観点 | ファイル | 行番号 | 問題 | 修正方針 |
|---|--------|------|----------|--------|------|----------|
| 1 | High | No hardcoded colors | `lib/features/package_list/screens/widgets/package_list_tile.dart` | L100 | `color: Colors.white` — アバターテキストカラーをハードコード。`AppColors.shimmerPlaceholder` は Shimmer 用途限定（コメントで明示）なので流用不可 | `AppColors` に `avatarText = Color(0xFFFFFFFF)` を追加し置換 |
| 2 | High | No hardcoded spacing | `lib/features/package_list/screens/widgets/package_list_tile.dart` | L127 | `vertical: 3` — バージョンバッジの垂直 padding が AppSpacing にない値 | `AppSpacing.xxs = 2` を新設して置換（1dp 削減で視覚的影響最小限） |
| 3 | High | No hardcoded spacing | `lib/features/package_detail/screens/widgets/versions_section.dart` | L96 | `vertical: 2` — タイムライン縦線の垂直 margin が AppSpacing にない値 | `AppSpacing.xxs` へ置換 |
| 4 | High | No hardcoded spacing | `lib/features/package_detail/screens/widgets/versions_section.dart` | L123-124 | `horizontal: 7, vertical: 2` — LATEST バッジの padding が AppSpacing にない値 | `horizontal: AppSpacing.sm` (8dp), `vertical: AppSpacing.xxs` (2dp) へ置換 |
| 5 | High | No hardcoded spacing | `lib/features/package_detail/screens/widgets/section_header.dart` | L19-20 | `width: 3, height: 18` — セクションアクセントバーのサイズがハードコード | ウィジェット内のプライベート定数として明示: `static const _accentWidth = 3.0; static const _accentHeight = 18.0;` |
| 6 | Medium | パフォーマンス | `lib/features/package_detail/screens/package_detail_screen.dart` | L82-83 | `[...state.detail.versions]..sort(...)` が build() 内で実行される（リビルドごとに O(n log n)） | `package_detail_notifier.dart` の `build()` 内でソート済みリストを `PackageDetailState` に保持する |

---

## 要検討（Low）

| # | 優先度 | 観点 | ファイル | 行番号 | 問題 | 修正方針 |
|---|--------|------|----------|--------|------|----------|
| 1 | Low | 規約統一 | `lib/features/package_detail/screens/package_detail_screen.dart` | L21 | `ConsumerWidget` を使用。`pubdev-ui` スキルは「全スクリーンは HookConsumerWidget を継承する」と記載しているが、hooks 未使用のため `ConsumerWidget` の方が軽量で適切 | 現状維持。hooks を使わない画面で HookConsumerWidget を強制するのは過剰 |
| 2 | Low | サイズ定数 | `lib/features/package_list/screens/widgets/package_list_tile.dart` | L86-87, L166 | `width: 44, height: 44` (アバター), `size: 16` (シェブロン) がハードコード | プライベート定数化を検討（`static const _avatarSize = 44.0` 等）。AppSpacing 範囲外のためトークン化は不要 |
| 3 | Low | サイズ定数 | `lib/features/package_detail/screens/widgets/versions_section.dart` | L82-84 | `width: 8, height: 8` (ドット), `top: 5` (ドット上マージン), `width: 1` (縦線) がハードコード | プライベート定数化を検討。`width: 1` は装飾的な 1px ルールで慣習的に許容 |
| 4 | Low | サイズ定数 | `lib/features/package_detail/screens/package_detail_screen.dart` | L168 | `size: 13` (verified アイコン) がハードコード | プライベート定数化を検討 |

---

## 修正結果

| # | 修正内容 | コミット |
|---|----------|---------|
| 1 | `AppColors.avatarText` 追加、`Colors.white` → `AppColors.avatarText` | Phase 8 でコミット |
| 2 | `AppSpacing.xxs = 2` 追加、各ハードコード spacing をトークンに置換 | Phase 8 でコミット |
| 3-4 | `AppSpacing.sm` / `AppSpacing.xxs` に置換 | Phase 8 でコミット（#2 と同一コミット） |
| 5 | `SectionHeader` にプライベート定数を追加 | Phase 8 でコミット |
| 6 | Notifier の `build()` でバージョンをソートして保持する | Phase 8 でコミット |

---

## メモ（将来の参考）

- `PackageListTile` の `StatefulWidget` は Hooks に移行するメリットが小さい（`_gradient` は `didUpdateWidget` 依存のため単純な `useState` より `initState`/`didUpdateWidget` パターンが明確）。現状維持が適切
- `versions_section.dart` の `IntrinsicHeight` は `Column` の高さ制約が必要なため意図的（タイムラインドットと横コンテンツの高さ同期）。パフォーマンス影響は小さい（バージョン数が大量でない限り）
- `_packageHeroHeader` の `switch (Theme.of(context).platform)` による scroll physics 分岐は iOS / 非 iOS で自然なスクロールフィールを提供するための意図的な実装
