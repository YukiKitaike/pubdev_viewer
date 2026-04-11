# Phase 5: package_detail Notifier & Screen レビュー結果

## 使用スキル
- `pubdev-state` — 並列 API コール（Records の `.wait`）
- `pubdev-ui` — カードセクション・タイムライン Widget パターン
- `dart-new-syntax` — `(a, b).wait`, `if-case`, switch expressions
- `flutter-dart-code-review` — Widget 分割の粒度
- `vgv-static-security` — `launchUrl` の安全な使い方

---

## 発見事項

### Critical（修正必須）

- [x] **`launchUrl` の `await` 欠落 → エラーが無視される** — `lib/features/package_detail/screens/package_detail_screen.dart:217` — **対応済み**: `async` 化・`await` 追加・失敗時 SnackBar 表示・`LaunchMode.externalApplication` 明示。
  `onPressed: () => launchUrl(parsed)` は `Future<bool>` を返すが `await` しておらず、起動失敗（`false`）もエラーも握り潰される。ユーザーへのフィードバックが一切ない。
  ```dart
  // 現状
  onPressed: () => launchUrl(parsed),

  // 推奨: async にして結果を検証
  onPressed: () async {
    final launched = await launchUrl(
      parsed,
      mode: LaunchMode.externalApplication,
    );
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URLを開けませんでした')),
      );
    }
  },
  ```

- [x] **仕様と実装の乖離: `publisherId` を Overview セクション内 右寄せで表示すべき** — `docs/overview.md:49` vs `lib/features/package_detail/screens/package_detail_screen.dart:150–176` — **対応済み**: `docs/overview.md` にヒーローヘッダーへの意図的移設を記載。
  仕様書（`docs/overview.md`）は "description の下部に右寄せ（`end`）で表示" と明記しているが、実装では `_PackageHeroHeader` の Column 内に左寄せのバッジとして表示されており、`OverviewSection` には publisherId が存在しない。意図的な仕様変更であれば `docs/overview.md` を更新すること。

### Major（強く推奨）

- [x] **`_SectionHeader` の完全重複** — `lib/features/package_detail/screens/widgets/overview_section.dart:44–79` と `lib/features/package_detail/screens/widgets/versions_section.dart:169–204` — **対応済み**: `section_header.dart` として抽出し `icon` 未使用フィールドも削除。
  クラス名・実装・コメントまで完全に同一のプライベート Widget が 2 ファイルに存在する。共通 Widget として `core/widgets/section_header.dart` または `package_detail/screens/widgets/section_header.dart` に切り出すべき。
  ```dart
  // core/widgets/section_header.dart（または feature 内 widgets/）
  class SectionHeader extends StatelessWidget {
    const SectionHeader({required this.label, required this.icon, super.key});
    final String label;
    final IconData icon;
    // ... 同一実装
  }
  ```

- [x] **`PackageDetailScreen` が `HookConsumerWidget` を継承しているが Flutter Hooks を一切使っていない** — `lib/features/package_detail/screens/package_detail_screen.dart:20` — **対応済み**: `ConsumerWidget` に変更、`hooks_riverpod` → `flutter_riverpod` インポート変更。
  `useXxx()` 系の Hook 呼び出しが皆無。`hooks_riverpod` パッケージへの不要な依存と `HookConsumerWidget` を使うことで生じる軽微なオーバーヘッドを避けるため `ConsumerWidget` に変更すること。
  ```dart
  // Before
  class PackageDetailScreen extends HookConsumerWidget {
  // After
  class PackageDetailScreen extends ConsumerWidget {
  ```

- [x] **`_sortedVersions` getter がビルドのたびにリストコピー＋ソートを実行する** — `lib/features/package_detail/screens/widgets/versions_section.dart:19–23` — **対応済み**: getter を削除し呼び出し元 (`package_detail_screen.dart`) でソート済みリストを渡す方式に変更。
  `StatelessWidget` の `build()` は頻繁に再呼び出しされるが、getter は毎回 `[...versions]..sort(...)` を実行する。バージョン数が多い場合にパフォーマンス劣化を招く。`versions` を受け取る際にソート済みリストを渡すか、`VersionsSection` の `build()` 内でローカル変数としてキャッシュするのみに止める（現状 `build` 内で `final sorted = _sortedVersions` としているのは正しいが、getter 自体をソートなし単純リターンにする方が明確）。
  ```dart
  // 推奨: 呼び出し元でソート済みを渡す
  VersionsSection(
    versions: state.detail.versions.sorted(
      (a, b) => b.published.compareTo(a.published),
    ),
  ),
  // VersionsSection 内では getter を廃止して直接 versions を使う
  ```

- [ ] **`onRetry` で `ref.invalidate` を直接呼んでいる — `refresh()` との非対称** — `lib/features/package_detail/screens/package_detail_screen.dart:52–55`
  Pull-to-refresh では `notifier.refresh()`（= `invalidateSelf()` + `await future`）を呼んでいるが、エラー時の「再試行」ボタンでは `ref.invalidate(...)` を直接呼んでいる。後者は `await future` を待たないため RefreshIndicator のスピナーが完了まで表示されない（エラー時は RefreshIndicator がないため実害は薄いが）、パターンの統一のために `notifier.refresh()` に揃えることを推奨。

### Minor（改善提案）

- [ ] **ハードコード数値 `Gap(8)` → `AppSpacing.sm`** — `lib/features/package_detail/screens/package_detail_screen.dart:141`
  ```dart
  // Before
  const Gap(8),
  // After
  const Gap(AppSpacing.sm),
  ```

- [ ] **ハードコード数値 `Gap(12)` → `AppSpacing.md`** — `lib/features/package_detail/screens/package_detail_screen.dart:151`
  ```dart
  // Before
  const Gap(12),
  // After
  const Gap(AppSpacing.md),
  ```

- [ ] **ハードコード数値 `EdgeInsets.symmetric(horizontal: 10, vertical: 4)`** — `lib/features/package_detail/screens/package_detail_screen.dart:153`
  `horizontal: 10` は `AppSpacing` グリッド（4dp 刻み）から外れている。`horizontal: AppSpacing.sm` (8) か `horizontal: AppSpacing.xl` (20) の最寄りトークンか、もしくは `AppSpacing.xs + AppSpacing.sm` (= 12) を検討。
  ```dart
  padding: const EdgeInsets.symmetric(
    horizontal: AppSpacing.sm,  // 8 または専用トークン追加
    vertical: AppSpacing.xs,    // 4
  ),
  ```

- [ ] **ハードコード数値 `SizedBox(width: 4)` → `SizedBox(width: AppSpacing.xs)`** — `lib/features/package_detail/screens/package_detail_screen.dart:166`

- [ ] **ハードコード数値 `SizedBox(width: 10)` → トークン化** — `lib/features/package_detail/screens/widgets/versions_section.dart:112`
  `10` は 4dp グリッドに乗っていない。`AppSpacing.sm` (8) か `AppSpacing.md` (12) に寄せることを推奨。

- [ ] **`SizedBox(height: 16 + MediaQuery.paddingOf(context).bottom)` → `AppSpacing.lg`** — `lib/features/package_detail/screens/package_detail_screen.dart:83–85`
  ```dart
  // Before
  SizedBox(height: 16 + MediaQuery.paddingOf(context).bottom),
  // After（bottom safe area 自体は維持してよい）
  SizedBox(height: AppSpacing.lg + MediaQuery.paddingOf(context).bottom),
  ```

- [ ] **`asyncState.valueOrNull != null` ガード内の `requireValue` が 2 回呼ばれて冗長** — `lib/features/package_detail/screens/package_detail_screen.dart:38–44`
  `valueOrNull != null` チェック後に `requireValue` を 3 回呼んでいる。ローカル変数に束縛する方がシンプル。
  ```dart
  if (asyncState.valueOrNull case final state?) ...[
    _ShareButton(packageName: state.detail.name),
    _ExternalLinkButton(
      url: state.detail.latest.pubspec.homepage ??
          state.detail.latest.pubspec.repository,
    ),
  ],
  ```

- [x] **`_formatDate` が Widget クラスのインスタンスメソッドとして存在** — `lib/features/package_detail/screens/widgets/versions_section.dart:69–74` — **対応済み(M9と一括)**: `published` を `DateTime` 型に変更し `_formatDate` は単純な `dateFormat.format()` 呼び出しになった。
  `PackageDetailVersion.published` が `String` 型であるため Widget 層でパースしている。モデル層で `DateTime` 型にするか（`package_detail_version.dart` の `published` フィールドを `DateTime` 型に変更）、`DateFormat` と `_formatDate` を `VersionsSection` レベルのトップレベル関数か Extension として切り出すことで Widget の責務を減らせる。

- [x] **`http` スキームの URL を許可している理由のコメント欠如** — `lib/features/package_detail/screens/package_detail_screen.dart:213` — **対応済み**: 意図コメントを追加。
  `pub.dev` の `pubspec.yaml` には `http://` スキームの `homepage` が実際に存在しうるが、現状コードに意図の説明がない。セキュリティレビュー時に疑問を生じさせないようコメントを追加すること。
  ```dart
  // pub.dev の pubspec.homepage は http:// を含む場合があるため両スキームを許可する
  (parsed.scheme == 'https' || parsed.scheme == 'http')
  ```

- [ ] **Notifier テスト: 並列実行の実証が不十分** — `test/features/package_detail/notifiers/package_detail_notifier_test.dart:40–53`
  「コール数が各 1 回」のアサーションだけでは逐次実行との区別ができない。`Completer` を 2 つ使って両方が同時に pending になることを確認するテストを追加するとより確実。

- [ ] **`_ExternalLinkButton` の `icon` パラメータが `_SectionHeader` と同様に `icon` フィールドを持つが使われていない** — `lib/features/package_detail/screens/widgets/overview_section.dart:46` / `versions_section.dart:172`
  `_SectionHeader` に `icon` フィールドが定義されているが、`build()` 内で `icon` は参照されていない（Row に Icon Widget が存在しない）。不要なフィールドは削除するか、Icon を実際に描画するよう実装すること。

### Positive（良い実装）

- **`(repository.getPackageDetail, repository.getPackagePublisher).wait` による正しい並列 API コール** — `lib/features/package_detail/notifiers/package_detail_notifier.dart:18–21`
  Dart 3.x Records の `.wait` を使って 2 つの API を並列実行している。Records destructuring (`final (detail, publisher) = ...`) との組み合わせも自然でクリーン。

- **`refresh()` の実装が正しいパターンに従っている** — `lib/features/package_detail/notifiers/package_detail_notifier.dart:28–31`
  `ref.invalidateSelf()` + `await future` の 2 行構成は、pubdev-state スキルで定義された標準パターンと完全に一致している。

- **`build()` 内の `ref.watch(packageDetailRepositoryProvider)` が適切** — `lib/features/package_detail/notifiers/package_detail_notifier.dart:15–17`
  Repository を `ref.watch` で取得することで、Repository が再生成された場合に Notifier も自動的に再ビルドされる。

- **`_ExternalLinkButton` の URL バリデーション** — `lib/features/package_detail/screens/package_detail_screen.dart:210–219`
  `if-case` パターン (`if (url case final String u when u.isNotEmpty)`) と `Uri.tryParse` を組み合わせ、スキーム検証まで行っている。URL が無効な場合は `SizedBox.shrink()` で graceful degradation している点も正しい。

- **`switch` + platform-aware スクロール物理学** — `lib/features/package_detail/screens/package_detail_screen.dart:63–69`
  `switch (Theme.of(context).platform)` で iOS と他プラットフォームのスクロール物理を適切に切り替えている。

- **`VersionsSection` での `DateFormat` を `static final` でキャッシュ** — `lib/features/package_detail/screens/widgets/versions_section.dart:17`
  `DateFormat` は生成コストが高いため `static final` でクラスレベルにキャッシュしているのは正しい。

- **`if-case` パターンの活用** — `lib/features/package_detail/screens/widgets/versions_section.dart:70`
  `if (DateTime.tryParse(published) case final date?)` という if-case null-check パターンは Dart 3.x らしい書き方で明確。

- **Widget テスト: `Completer` を使ったローディング状態の検証** — `test/features/package_detail/screens/package_detail_screen_test.dart:51–70`
  `Completer` で非同期完了を制御しながら loading インジケーターを検証しているパターンは `pubdev-testing` スキルの推奨スタイルに沿っている。

- **`FakePackageDetailRepository` の設計** — `test/helpers/fakes.dart:88–110`
  `Fake implements` パターン、コールバック式のスタブ、`Completer` フィールドの共存が適切に設計されている。

---

## 修正例（必要に応じて）

### 1. `launchUrl` の `await` とエラーハンドリング（Critical）

```dart
// lib/features/package_detail/screens/package_detail_screen.dart

class _ExternalLinkButton extends StatelessWidget {
  // ...
  @override
  Widget build(BuildContext context) {
    if (url case final String u when u.isNotEmpty) {
      final parsed = Uri.tryParse(u);
      // pub.dev の pubspec.homepage は http:// を含む場合があるため両スキームを許可
      if (parsed != null &&
          (parsed.scheme == 'https' || parsed.scheme == 'http')) {
        return IconButton(
          icon: const Icon(Icons.open_in_new),
          tooltip: '外部サイトで開く',
          onPressed: () async {
            final launched = await launchUrl(
              parsed,
              mode: LaunchMode.externalApplication,
            );
            if (!launched && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('URLを開けませんでした')),
              );
            }
          },
        );
      }
    }
    return const SizedBox.shrink();
  }
}
```

### 2. `_SectionHeader` の共通化（Major）

```dart
// lib/features/package_detail/screens/widgets/section_header.dart（新規）

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_system.dart';

/// パッケージ詳細画面のセクション共通ヘッダー（左ボーダーアクセント + ラベル）。
class PackageDetailSectionHeader extends StatelessWidget {
  const PackageDetailSectionHeader({
    required this.label,
    required this.icon,
    super.key,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(AppRadius.sectionAccent),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
```

### 3. AppBar のアクション: `if-case` 活用（Minor）

```dart
// lib/features/package_detail/screens/package_detail_screen.dart

actions: [
  if (asyncState.valueOrNull case final state?) ...[
    _ShareButton(packageName: state.detail.name),
    _ExternalLinkButton(
      url: state.detail.latest.pubspec.homepage ??
          state.detail.latest.pubspec.repository,
    ),
  ],
],
```

### 4. `HookConsumerWidget` → `ConsumerWidget`（Major）

```dart
// Before
class PackageDetailScreen extends HookConsumerWidget {
  // ...
  @override
  Widget build(BuildContext context, WidgetRef ref) { ... }
}

// After
class PackageDetailScreen extends ConsumerWidget {
  // ...
  @override
  Widget build(BuildContext context, WidgetRef ref) { ... }
}
// import 'package:hooks_riverpod/hooks_riverpod.dart'; も削除可能
// import 'package:flutter_riverpod/flutter_riverpod.dart'; に変更
```

### 5. ハードコード数値のトークン化（Minor）

```dart
// _PackageHeroHeader 内

// Before
const Gap(8),
// After
const Gap(AppSpacing.sm),

// Before
const Gap(12),
// After
const Gap(AppSpacing.md),

// Before
padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// After
padding: const EdgeInsets.symmetric(
  horizontal: AppSpacing.sm,  // 8dp（または専用トークン追加を検討）
  vertical: AppSpacing.xs,    // 4dp
),

// Before
const SizedBox(width: 4),
// After
const SizedBox(width: AppSpacing.xs),

// _VersionTimelineItem 内（versions_section.dart:112）
// Before
const SizedBox(width: 10),
// After
const SizedBox(width: AppSpacing.sm),  // 8dp に寄せる
```

---

## 優先度サマリー

| 優先度 | 件数 | 内容 |
|--------|------|------|
| Critical | 2 | `launchUrl` await 欠落、仕様との publisherId 表示位置の乖離 |
| Major | 4 | `_SectionHeader` 重複、`HookConsumerWidget` 誤用、`_sortedVersions` 毎回ソート、`onRetry` 非対称 |
| Minor | 9 | ハードコード数値 5 件、`requireValue` 冗長、`_formatDate` 責務、`http` スキームコメント欠如、テスト並列性 |
