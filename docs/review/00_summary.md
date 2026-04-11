# pubdev_viewer 徹底レビュー — 横断サマリー

レビュー実施日: 2026-04-11  
対象: Feature × Layer 全 8 フェーズ

---

## 使用スキル一覧

| フェーズ | スキル |
|---------|-------|
| Phase 1 Core | `pubdev-models`, `pubdev-ui`, `design-system-patterns`, `dart-best-practices`, `flutter-riverpod-expert`, `vgv-static-security` |
| Phase 2 PL Models | `pubdev-models`, `dart-new-syntax`, `dart-test-fundamentals`, `dart-checks-migration` |
| Phase 3 PL UI | `pubdev-state`, `flutter-riverpod-expert`, `pubdev-ui`, `flutter-dart-code-review`, `dart-new-syntax` |
| Phase 4 PD Models | `pubdev-models`, `dart-new-syntax`, `dart-test-fundamentals` |
| Phase 5 PD UI | `pubdev-state`, `pubdev-ui`, `dart-new-syntax`, `flutter-dart-code-review`, `vgv-static-security` |
| Phase 6 Architecture | `flutter-architecting-apps`, `pubdev-new-feature`, `flutter-riverpod-expert`, `dart-best-practices` |
| Phase 7 Testing | `pubdev-testing`, `dart-test-fundamentals`, `dart-checks-migration`, `dart-matcher-best-practices`, `flutter-dart-code-review` |
| Phase 8 Security/Perf | `vgv-static-security`, `flutter-riverpod-expert`, `dart-best-practices` |

---

## Critical（修正必須）

| # | 問題 | ファイル | 担当フェーズ |
|---|------|---------|------------|
| ~~C1~~ | ~~`find.byIcon(Icons.error_outline)` vs 実装 `Icons.cloud_off_rounded` — テストが常に失敗~~ **✅ 対応済み** | `test/features/package_list/screens/package_list_screen_test.dart:85` | Phase 3, 7 |
| ~~C2~~ | ~~`launchUrl(parsed)` の `await` 欠落 — ブラウザ起動失敗がサイレント無視される~~ **✅ 対応済み** | `lib/features/package_detail/screens/package_detail_screen.dart:217` | Phase 5, 8 |
| ~~C3~~ | ~~`DioExceptionType.receiveTimeout` / `sendTimeout` / `badCertificate` / `cancel` が明示的に分岐されず意図が不明確~~ **✅ 対応済み** | `lib/core/api/pub_dev_api_client.dart:63-67` | Phase 1 |
| ~~C4~~ | ~~`AppColors.lightBorderSubtle` が名前（薄いボーダー）と値（Slate-700: ダーク色）が不整合。`AppThemeTokens` から未参照でデッドコードの疑い~~ **✅ 対応済み（削除）** | `lib/core/design_system/tokens/app_colors.dart:15` | Phase 1 |
| ~~C5~~ | ~~仕様書「publisherId を description 下部に右寄せで表示」vs 実装「ヒーローヘッダー内に左寄せバッジ」— 意図的変更なら `docs/overview.md` の更新が必要~~ **✅ 対応済み** | `lib/features/package_detail/screens/package_detail_screen.dart` / `docs/overview.md` | Phase 5 |

---

## Major（強く推奨）

| # | 問題 | ファイル | 担当フェーズ |
|---|------|---------|------------|
| ~~M1~~ | ~~`package:checks` が `dev_dependencies` に宣言されているが全テストで未使用~~ **✅ 対応済み（削除）** | `pubspec.yaml:33` | Phase 2, 7 |
| ~~M2~~ | ~~`_SectionHeader` が `overview_section.dart` と `versions_section.dart` に完全重複~~ **✅ 対応済み（`section_header.dart` に抽出）** | `lib/features/package_detail/screens/widgets/` | Phase 5, 6 |
| ~~M3~~ | ~~`PackageDetailScreen` が `HookConsumerWidget` を継承しているが Flutter Hooks を一切使っていない — `ConsumerWidget` に変更~~ **✅ 対応済み** | `lib/features/package_detail/screens/package_detail_screen.dart:20` | Phase 5 |
| ~~M4~~ | ~~`on Exception catch (e)` が `Error` サブクラス（`AssertionError`, `StateError` 等）を取り逃す~~ **✅ 対応済み（`on Object catch (e)` に変更）** | `lib/features/package_list/notifiers/package_list_notifier.dart:49` | Phase 3 |
| ~~M5~~ | ~~`context.tokens` extension の `?? AppThemeTokens.light` フォールバックが登録忘れを隠す — `assert` 追加を推奨~~ **✅ 対応済み** | `lib/core/design_system/extensions/app_theme_tokens.dart:97` | Phase 1 |
| ~~M6~~ | ~~`pubDevApiClientProvider` が `keepAlive: false` で状態を持たないのに毎回 `Dio` を再生成~~ **✅ 対応済み（`@Riverpod(keepAlive: true)` に変更）** | `lib/core/api/pub_dev_api_client.dart:79` | Phase 1 |
| ~~M7~~ | ~~`_gradient` getter がビルドのたびに `codeUnits.fold` でハッシュ計算~~ **✅ 対応済み（`late final` + `didUpdateWidget`）** | `lib/features/package_list/screens/widgets/package_list_tile.dart` | Phase 3, 8 |
| ~~M8~~ | ~~`_sortedVersions` getter がビルドのたびにリストコピー＋ソートを実行~~ **✅ 対応済み（呼び出し元でソート済みリストを渡す方式に変更）** | `lib/features/package_detail/screens/widgets/versions_section.dart` | Phase 5, 8 |
| ~~M9~~ | ~~`PackageDetailVersion.published` が `String` — `DateTime` へ型変更~~ **✅ 対応済み（`@JsonKey(fromJson/toJson)` で `DateTime` 変換。`_formatDate` も簡素化）** | `lib/features/package_detail/models/package_detail_version.dart` | Phase 4 |
| ~~M10~~ | ~~`http` スキーム許可の理由がコメントで未記載~~ **✅ 対応済み（意図コメント追加）** | `lib/features/package_detail/screens/package_detail_screen.dart` | Phase 8 |
| ~~M11~~ | ~~`Uri.parse` が `_ShareButton` 内で例外を投げる可能性~~ **✅ 対応済み（`Uri.tryParse` に変更）** | `lib/features/package_detail/screens/package_detail_screen.dart` | Phase 8 |
| ~~M12~~ | ~~Widget テストで `MaterialApp` にテーマ（`appLightTheme`）が未設定 — `context.tokens` フォールバックに依存~~ **✅ 対応済み** | `test/features/package_list/screens/package_list_screen_test.dart` | Phase 7 |
| ~~M13~~ | ~~`pub_dev_api_client_test.dart` で `receiveTimeout` / `sendTimeout` テストが欠落~~ **✅ 対応済み（2テスト追加）** | `test/core/api/pub_dev_api_client_test.dart` | Phase 7 |
| M14 | `PackageListState.loadMoreError: Object?` が型として広すぎる — `AppException?` に絞ることで Widget 側での exhaustive switch が可能に | `lib/features/package_list/models/package_list_state.dart` | Phase 2 |
| M15 | `onRetry` が `ref.invalidate` 直呼び、Pull-to-refresh は `notifier.refresh()` と非対称 — パターン統一を推奨 | `lib/features/package_detail/screens/package_detail_screen.dart:52-55` | Phase 5 |

---

## Minor（改善提案）

### ハードコード数値（CLAUDE.md 違反）

| 場所 | 値 | 推奨 |
|------|-----|------|
| `package_list_screen.dart:111` | `top: 8` | `AppSpacing.sm` |
| `package_list_screen.dart:112` | `bottom: 16 + ...` | `AppSpacing.lg + ...` |
| `package_list_screen.dart:118` | `EdgeInsets.all(16)` | `EdgeInsets.all(AppSpacing.lg)` |
| `package_detail_screen.dart:141` | `Gap(8)` | `Gap(AppSpacing.sm)` |
| `package_detail_screen.dart:151` | `Gap(12)` | `Gap(AppSpacing.md)` |
| `package_detail_screen.dart:153` | `EdgeInsets.symmetric(horizontal: 10, vertical: 4)` | `AppSpacing` トークン組み合わせ |
| `package_detail_screen.dart:166` | `SizedBox(width: 4)` | `Gap(AppSpacing.xs)` |
| `package_detail_screen.dart:83` | `SizedBox(height: 16 + ...)` | `AppSpacing.lg + ...` |
| `versions_section.dart:112` | `SizedBox(width: 10)` | `Gap(AppSpacing.sm)` または `Gap(AppSpacing.md)` |
| `versions_section.dart` | `fontSize: 13/9/12` | TextTheme またはデザイントークン |
| `error_view.dart:55,63,71` | `Gap(20)`, `Gap(8)`, `Gap(28)` | `AppSpacing.xl`, `AppSpacing.sm`, `AppSpacing.xxxl` |
| `package_list_tile.dart` | `AppSpacing.sm - 2` | 専用定数の定義 |
| `skeleton_list_view.dart` | `Colors.white` | Shimmer 仕様上必要だがコメントで意図を明示 |

### その他

| # | 問題 | ファイル |
|---|------|---------|
| m1 | `launchMode` が未指定（Android で in-app WebView になる可能性） | `package_detail_screen.dart:216` |
| m2 | `PackageDetailVersion` / `PackageListVersion` の意図的分離がコメントで未記載 — 将来の誤った統合リスク | `lib/features/package_detail/models/package_detail_version.dart` |
| m3 | `PackageDetailResponse.advisoriesUpdated` が UI 未使用 — 将来用か削除候補か | `lib/features/package_detail/models/package_detail_response.dart` |
| m4 | `ThemeModeNotifier.toggle()` で `ThemeMode.system` から常に `.dark` への遷移 — 意図的設計かコメントで明示 | `lib/app/theme_mode_notifier.dart` |
| m5 | Integration test が起動確認のみ — 画面遷移・スクロール等の E2E テストが欠落 | `integration_test/` |
| m6 | Golden test の CI 運用方針（初回生成フロー、更新方法）が未文書化 | `test/features/*/screens/goldens/` |
| m7 | API レスポンスキャッシュなし — auto-dispose により戻り遷移で毎回 API 呼び出し（UX 観点） | `lib/features/package_detail/notifiers/` |
| m8 | Dio のリトライ機構なし — 一時的なネットワークエラーへの対処が欠落 | `lib/core/api/pub_dev_api_client.dart` |
| m9 | URL パラメータ（パッケージ名）のサニタイズなし（パス区切り文字 `/` を含む入力への対処） | `lib/app/router.dart` |

---

## CLAUDE.md Critical Rules 遵守状況

| ルール | 結果 | 備考 |
|--------|------|------|
| No interfaces | ✅ 完全遵守 | Repository は全て具象クラスのみ |
| No UseCase | ✅ 完全遵守 | Notifier → Repository 直接呼び出し |
| No Either | ✅ 完全遵守 | 例外 + try/catch のみ |
| No Entity split | ✅ 完全遵守 | fromJson/toJson が1クラスで完結 |
| No premature core promotion | ✅ 概ね遵守 | `_SectionHeader` は feature 内重複（`core/` 昇格不要） |
| No hardcoded colors/spacing | ❌ 複数違反 | 上記ハードコード数値リスト参照 |

---

## Positive（プロジェクト全体の良い実装）

- Feature-First アーキテクチャが徹底されており feature 間の依存がゼロ
- `sealed class AppException` + exhaustive switch による型安全なエラーハンドリング
- `(repository.getPackageDetail(), repository.getPackagePublisher()).wait` による正しい並列 API コール
- `ref.watch` / `ref.read` の使い分けが正確で不要な再ビルドがない
- `FakeXxxRepository` の Completer + コールバック設計が優秀（ローディング状態のテストが可能）
- Dart 3.x の新機能（dot shorthands, if-case, switch expressions, Records）が適切に活用されている
- `TypedGoRoute` による型安全なルーティング
- `ThemeModeNotifier` のみに `keepAlive: true`（適切な Provider ライフサイクル管理）
- `useEffect` によるスクロールリスナーの対称登録・解除（メモリリークなし）
- `loadMore()` の三重ガード条件（`isLoadingMore`, `nextUrl`, `state.valueOrNull`）が堅牢
- `DateFormat` の `static final` キャッシュなどのパフォーマンス配慮
- エラーメッセージへの内部情報非漏洩

---

## 優先度別アクションプラン

### 即座に対応（テスト・動作に影響）
1. **C1**: `Icons.error_outline` → `Icons.cloud_off_rounded` に修正
2. **C2**: `launchUrl` に `await` 追加 + エラー時 SnackBar

### 早期対応（品質・保守性）
3. **M2**: `_SectionHeader` の重複解消
4. **M3**: `PackageDetailScreen` を `ConsumerWidget` に変更
5. **M4**: `on Exception` → `catch (e)` に変更
6. **M9**: `PackageDetailVersion.published` を `DateTime` 型に変更
7. **M1**: `package:checks` の方針決定（移行 or 削除）
8. ハードコード数値の `AppSpacing` トークン化（一括 PR）

### 中長期（設計改善）
9. **M5**: `context.tokens` の assert 追加
10. **M6**: `pubDevApiClientProvider` に `keepAlive: true`
11. **M7/M8**: `_gradient` / `_sortedVersions` のキャッシュ化
12. **m7**: API レスポンスキャッシュの導入検討

---

## 詳細ファイル

| フェーズ | ファイル |
|---------|---------|
| Phase 1: Core レイヤー | [01_core_layer.md](01_core_layer.md) |
| Phase 2: package_list Models & Repository | [02_package_list_models.md](02_package_list_models.md) |
| Phase 3: package_list Notifier & Screen | [03_package_list_ui.md](03_package_list_ui.md) |
| Phase 4: package_detail Models & Repository | [04_package_detail_models.md](04_package_detail_models.md) |
| Phase 5: package_detail Notifier & Screen | [05_package_detail_ui.md](05_package_detail_ui.md) |
| Phase 6: アーキテクチャ横断 | [06_architecture.md](06_architecture.md) |
| Phase 7: テスト品質 | [07_testing.md](07_testing.md) |
| Phase 8: セキュリティ・パフォーマンス | [08_security_performance.md](08_security_performance.md) |
