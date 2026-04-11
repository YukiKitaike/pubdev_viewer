# Phase 6: アーキテクチャ横断 レビュー結果

## 使用スキル
- `flutter-architecting-apps` — レイヤード依存方向の検証
- `pubdev-new-feature` — アーキテクチャ一貫性チェックリスト
- `flutter-riverpod-expert` — Provider グラフ設計・keepAlive の適切性
- `dart-best-practices` — Effective Dart 準拠

---

## CLAUDE.md Critical Rules チェック結果

| ルール | ステータス | 違反箇所 |
|--------|-----------|---------|
| No interfaces | ✅ | 違反なし。`PackageListRepository`・`PackageDetailRepository` ともに具象クラスのみ |
| No UseCase | ✅ | 違反なし。Notifier → Repository 直呼び |
| No Either | ✅ | 違反なし。try/catch + `AppException` サブクラスで統一 |
| No Entity split | ✅ | 違反なし。各モデルが `fromJson/toJson` を 1 クラスで完結 |
| No premature core promotion | ⚠️ | `core/models/pubspec.dart` が実質「両 feature から参照」の条件を満たしてはいるが、昇格タイミングが早かった可能性あり（詳細は発見事項参照） |
| No hardcoded colors/spacing | ❌ | 複数ファイルで `Gap(N)` / `SizedBox(width: N)` / `fontSize: N` の直書きを確認（詳細は発見事項参照） |

---

## 発見事項

### Critical（修正必須）

なし

---

### Major（強く推奨）

- [ ] **`_SectionHeader` の完全重複** — `lib/features/package_detail/screens/widgets/overview_section.dart:44-79` と `lib/features/package_detail/screens/widgets/versions_section.dart:169-204` に全く同一の実装が存在する。同一 feature 内の重複のため `core/widgets` 昇格は不要（"No premature core promotion" ルールを尊重）。`overview_section.dart` に private として定義し、`versions_section.dart` から `part of` または package_detail feature 内の共通ファイル（例: `lib/features/package_detail/screens/widgets/_section_header.dart`）として切り出すべき。
  - `lib/features/package_detail/screens/widgets/overview_section.dart:44`
  - `lib/features/package_detail/screens/widgets/versions_section.dart:169`
  - 推奨修正: `lib/features/package_detail/screens/widgets/section_header.dart`（package_detail feature 内限定）として抽出し、両 Widget からインポートする

- [ ] **`package_list_screen.dart` の `EdgeInsets.all(16)` ハードコード** — `ListView.builder` 内の `CircularProgressIndicator` ローダー部分で `padding: EdgeInsets.all(16)` が直書きされている。
  - `lib/features/package_list/screens/package_list_screen.dart:118`
  - 推奨修正: `const EdgeInsets.all(AppSpacing.lg)` に変更（`AppSpacing.lg = 16`）

- [ ] **`package_detail_screen.dart` のハードコード数値** — `_PackageHeroHeader` 内で複数の直書き数値を確認:
  - `const Gap(8)` → `const Gap(AppSpacing.sm)` — `lib/features/package_detail/screens/package_detail_screen.dart:141`
  - `const Gap(12)` → `const Gap(AppSpacing.md)` — `lib/features/package_detail/screens/package_detail_screen.dart:151`
  - `const SizedBox(width: 4)` → `const SizedBox(width: AppSpacing.xs)` — `lib/features/package_detail/screens/package_detail_screen.dart:166`
  - `padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)` — `lib/features/package_detail/screens/package_detail_screen.dart:153`（`horizontal: AppSpacing.sm + 2` は中途半端。`AppSpacing.sm = 8` か `AppSpacing.md = 12` への丸めを検討）
  - `fontSize: 14` — `lib/features/package_detail/screens/package_detail_screen.dart:145`（`GoogleFonts.jetBrainsMono` の `fontSize` はデザイントークン対象外の可能性があるが、定数化を推奨）
  - `size: 13` — アイコンサイズ `lib/features/package_detail/screens/package_detail_screen.dart:163`（`AppSpacing.md = 12` または定数に統一）

---

### Minor（改善提案）

- [ ] **`versions_section.dart` の複数の直書き `fontSize`** — `GoogleFonts.jetBrainsMono` に渡す `fontSize` が 3 箇所で直書きされている。feature 内定数または `AppTextStyles` トークン化を検討。
  - `fontSize: 13` — `lib/features/package_detail/screens/widgets/versions_section.dart:122`
  - `fontSize: 9` — `lib/features/package_detail/screens/widgets/versions_section.dart:143`
  - `fontSize: 12` — `lib/features/package_detail/screens/widgets/versions_section.dart:154`
  - 推奨修正: `static const _versionFontSize = 13.0;` 等をクラスレベルに定義

- [ ] **`versions_section.dart` の `SizedBox(width: 10)` ハードコード** — `AppSpacing` トークンに対応する値がない（`sm = 8`, `md = 12`）。
  - `lib/features/package_detail/screens/widgets/versions_section.dart:112`
  - 推奨修正: デザイン意図に応じて `AppSpacing.sm` (8) または `AppSpacing.md` (12) に統一、もしくは `AppSpacing` に `smmd = 10` を追加

- [ ] **`versions_section.dart` の `padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.md)` の混在** — 片側は `AppSpacing.md` を使用しているが、もう片側が `0` の裸数値。パターンとして `EdgeInsets.zero` や `EdgeInsets.only(bottom: AppSpacing.md)` で明示的に書くほうが意図が伝わりやすい。
  - `lib/features/package_detail/screens/widgets/versions_section.dart:116`

- [ ] **`error_view.dart` の `Gap` ハードコード** — `core/widgets` に属するにもかかわらず、間隔トークンではなく生の数値が直書きされている。
  - `const Gap(20)` → `const Gap(AppSpacing.xl)` — `lib/core/widgets/error_view.dart:55`（`AppSpacing.xl = 20` で一致）
  - `const Gap(8)` → `const Gap(AppSpacing.sm)` — `lib/core/widgets/error_view.dart:62`
  - `const Gap(28)` → `const Gap(AppSpacing.xxl + 4)` は半端なため `AppSpacing.xxxl = 32` へ丸めるかトークン追加を検討 — `lib/core/widgets/error_view.dart:71`
  - 推奨修正: `AppSpacing.xl`, `AppSpacing.sm` に変更。28dp は `AppSpacing` への追加（`xl = 20` と `xxl = 24` の間は現在空白）も検討

- [ ] **`package_list_tile.dart` の `fontSize: 11` ハードコード** — バージョンバッジのテキストサイズが直書きされている。
  - `lib/features/package_list/screens/widgets/package_list_tile.dart:127`
  - 推奨修正: feature 内定数 `static const _badgeFontSize = 11.0;` として定義

- [ ] **`package_list_tile.dart` の `AppSpacing.sm - 2` の算術演算** — 2 箇所でトークン演算が行われている。
  - `lib/features/package_list/screens/widgets/package_list_tile.dart:39`（`vertical: AppSpacing.sm - 2`）
  - `lib/features/package_list/screens/widgets/package_list_tile.dart:135`（`height: AppSpacing.sm - 2`）
  - `skeleton_list_view.dart:38`, `skeleton_list_view.dart:94` でも同様のパターン
  - 推奨修正: `AppSpacing.xs = 4, sm = 8` の中間値として `AppSpacing` に `smm = 6` 追加を検討するか、`_verticalGap = 6.0` として定数化

- [ ] **`Pubspec` モデルの `core/` 昇格タイミング** — `lib/core/models/pubspec.dart` は `package_list_version.dart` と `package_detail_version.dart` の両方から参照されているため、"2 feature で共有されてから core/ に昇格" ルールを形式上は満たしている。ただし、`package_list_version` と `package_detail_version` はそれぞれ異なる API フィールドを持ち（前者は `archive_url/package_url/url`、後者は `archive_sha256/published`）、`Pubspec` の共有は合理的。現状の判断は妥当。

- [ ] **`package_list_screen.dart` の `top: 8` ハードコード** — `ListView` の `padding` に `top: 8` が直書きされている。
  - `lib/features/package_list/screens/package_list_screen.dart:111`
  - 推奨修正: `top: AppSpacing.sm` に変更（`AppSpacing.sm = 8` で一致）

- [ ] **`package_detail_screen.dart` の `height: 16 + MediaQuery.paddingOf(context).bottom`** — `16` が直書きされている。
  - `lib/features/package_detail/screens/package_detail_screen.dart:84`
  - 推奨修正: `height: AppSpacing.lg + MediaQuery.paddingOf(context).bottom`

---

### Positive（良い実装）

- **依存方向の完全遵守**: `screens → notifiers → repository → core/api` の依存方向が全ファイルで守られている。`package_list` feature と `package_detail` feature 間の直接依存はなく、クロス feature 参照はゼロ。

- **No interfaces ルールの徹底**: `PackageListRepository` / `PackageDetailRepository` ともに `abstract class` なし。具象クラスとして明確に実装されている。

- **No UseCase の徹底**: `PackageListNotifier` / `PackageDetailNotifier` が Repository を直接 `ref.watch` / `ref.read` しており、中間レイヤーなし。

- **No Either の徹底**: `PubDevApiClient._get()` で `DioException` を `NetworkException` / `ServerException` に変換し、Notifier 側で `on Exception catch (e)` で処理する一貫したエラーフロー。

- **`keepAlive` の適切な使用**: `@Riverpod(keepAlive: true)` は `ThemeModeNotifier` のみに限定されており、画面系 Provider が適切に autodispose されている。

- **並列 API 呼び出し**: `PackageDetailNotifier.build()` での `(repo.getPackageDetail(), repo.getPackagePublisher()).wait` による並列取得は Dart 3 の Records + `.wait` を適切に活用している。

- **Feature-First の構造一貫性**: `package_list` / `package_detail` ともに `models/ / repository/ / notifiers/ / screens/` の 4 層構造を持ち、新 feature 追加のガイドラインに沿っている。

- **デザインシステムの活用**: 大部分の Widget で `AppSpacing`, `AppRadius`, `context.tokens`, `cardElevatedShadow()`, `AppCardTheme` extension を適切に使用しており、デザイントークンへの準拠率は高い。

- **`DateFormat` の static 定数化**: `VersionsSection` で `static final DateFormat _dateFormat` として定義し、インスタンス生成を抑制している。

- **go_router の型安全ルーティング**: `TypedGoRoute` + コード生成による型安全なナビゲーションが実装されており、文字列パスのハードコードがない。

- **ドキュメントコメントの充実**: 各クラス・メソッドに `///` ドキュメントコメントが付与されており、Effective Dart の命名・コメント規約に準拠している。

---

## サマリー

アーキテクチャの骨格は非常に健全。Critical な違反はゼロで、CLAUDE.md の主要ルール（No interfaces / No UseCase / No Either / No Entity split）は全て遵守されている。

主な改善点は **ハードコード数値の残存**（No hardcoded colors/spacing ルール違反）と **`_SectionHeader` の feature 内重複**の 2 点。前者は機械的に `AppSpacing` トークンへ置換できるケースが多く、後者は feature 内の共通ファイル抽出で解消できる。いずれも動作には影響しないが、コードの保守性と CLAUDE.md 準拠の観点から早期対応を推奨する。
