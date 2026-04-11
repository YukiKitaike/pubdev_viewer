# Phase 1: Core レイヤー レビュー結果

## 使用スキル
- `pubdev-ui` — AppThemeTokens・AppCardTheme の設計妥当性
- `design-system-patterns` — トークン設計の網羅性と使いやすさ
- `dart-best-practices` — sealed class / final class の使い方
- `flutter-riverpod-expert` — Provider 設計
- `vgv-static-security` — API クライアントのセキュリティ

---

## 発見事項

### Critical（修正必須）

- [x] **`AppColors.lightBorderSubtle` の名前と値が完全に不整合** — `lib/core/design_system/tokens/app_colors.dart:15` — `lightBorderSubtle` という名前は「薄いボーダー」を想起させるが、実際の値は `Color(0xFF334155)`（Slate-700）でダークカラー。Light テーマで使うには暗すぎ、名前が誤解を招く。さらにこのカラーは `AppThemeTokens` や `app_shadows.dart` など他のファイルから参照されておらず、定義されているが実質デッドコードになっている可能性が高い。
  - **推奨修正**: 値を `Color(0xFFCBD5E1)`（Slate-300 相当）に修正するか、Light テーマのボーダーとして正しい値に訂正する。または不要であれば削除する。

- [x] **`DioExceptionType.receiveTimeout` がハンドリングされていない** — `lib/core/api/pub_dev_api_client.dart:63-67` — `connectTimeout` と `connectionError` のみを `NetworkException` に変換しているが、`receiveTimeout`・`sendTimeout`・`badCertificate`・`cancel` ケースが catch されていない。`receiveTimeout` が発生した場合は `e.response == null` のため最後の `throw const NetworkException()` に落ちるが、意図が不明確でコードの読み手を混乱させる。
  - **推奨修正**:

```dart
on DioException catch (e) {
  _logger.severe('GET $url failed: $e');
  switch (e.type) {
    case DioExceptionType.connectionError:
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      throw const NetworkException();
    case DioExceptionType.badResponse:
      throw ServerException(
        e.response!.statusCode ?? 500,
        'Server returned ${e.response!.statusCode}',
      );
    case DioExceptionType.cancel:
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      if (e.error is SocketException) throw const NetworkException();
      throw const NetworkException();
  }
}
```

---

### Major（強く推奨）

- [x] **`SkeletonListView` の `Colors.white` ハードコード（意図コメントなし）** — `lib/core/widgets/skeleton_list_view.dart:42,52,68,77,96,98` — Shimmer パッケージは `baseColor`/`highlightColor` の上に子ウィジェットの色を `ColorFilter` でブレンドする仕様であり、子の色は描画に実質影響しない。そのため `Colors.white` は技術的に許容されうるが、コードレビュアーが「CLAUDE.md 違反の hardcoded color」と誤認するリスクが高い。コメントが一切なく意図が読み取れない。また `AppSpacing.sm - 2`（行 38, 94）は 4dp グリッドを破る `6dp` の値になっており、トークン設計と矛盾する。
  - **推奨修正 (Colors.white)**: 以下のコメントを `_SkeletonTile.build` 冒頭に追加する。
  ```dart
  // Shimmer の仕様上、子ウィジェットの色は baseColor/highlightColor で上書きされるため
  // Colors.white でよい（デザイントークンを使う必要はない）。
  ```
  - **推奨修正 (AppSpacing.sm - 2)**: `AppSpacing.xs`（4dp）または `AppSpacing.sm`（8dp）に揃えるか、`AppSpacing` に `AppSpacing.smCompact = 6` を追加する。

- [x] **`context.tokens` extension の `?? AppThemeTokens.light` フォールバックが失敗を隠す** — `lib/core/design_system/extensions/app_theme_tokens.dart:97` — `Theme.of(this).extension<AppThemeTokens>()` が `null` を返す（= テーマへの登録忘れ）場合、例外をスローせず静かにライトテーマで動く。ダークモードを設定しているのにライト色で描画される、という見つけにくいバグが発生しうる。
  - **推奨修正**: `!` で即時クラッシュさせて開発中に気づけるようにするか、`assert` を組み合わせる。
  ```dart
  extension AppThemeTokensX on BuildContext {
    AppThemeTokens get tokens {
      assert(
        Theme.of(this).extension<AppThemeTokens>() != null,
        'AppThemeTokens が ThemeData.extensions に登録されていません。'
        'app/theme.dart の _buildTheme を確認してください。',
      );
      return Theme.of(this).extension<AppThemeTokens>() ?? AppThemeTokens.light;
    }
  }
  ```

- [x] **`pubDevApiClient` Provider が `keepAlive: false`（デフォルト）のため毎回再生成される** — `lib/core/api/pub_dev_api_client.dart:79-88` — `@riverpod`（`keepAlive: false`）は最後の Listener がいなくなると破棄される。`PubDevApiClient` は状態を持たない純粋なラッパーであり、毎回 `Dio` インスタンスを生成するコストがかかる。また `Dio` 内部のコネクションプールも破棄されてしまう。
  - **推奨修正**: `@Riverpod(keepAlive: true)` に変更する。

- [x] **`error_view.dart` の `Gap` 値がハードコード** — `lib/core/widgets/error_view.dart:55,63,71` — `Gap(20)`・`Gap(8)`・`Gap(28)` がすべてリテラル値。`AppSpacing.xl`（20）・`AppSpacing.sm`（8）に対応する値は存在するが、`Gap(28)` に対応するトークンがない（AppSpacing の最大は `xxxl = 32`）。
  - **推奨修正**: `Gap(AppSpacing.xl)` / `Gap(AppSpacing.sm)` に変更し、`Gap(28)` は `AppSpacing.xxl`（24）か `AppSpacing.xxxl`（32）に揃えるか、トークンを追加する。

---

### Minor（改善提案）

- [x] **`ThemeModeNotifier.toggle()` が `ThemeMode.system` をスキップする設計** — `lib/app/theme_mode_notifier.dart:15-19` — ドキュメントコメントに「システムモードのときはダークに切り替える」と明記されており意図的な設計だが、一度トグルすると `ThemeMode.system` に戻る手段がない。将来「システム追従」オプションをトグルに加えたい場合、破壊的変更になる。Minor だが設計上の制約として記録する。

- [x] **`AppSpacing` トークンの用途セマンティクスが欠如** — `lib/core/design_system/tokens/app_spacing.dart` — `xs/sm/md/lg/xl/xxl/xxxl` はサイズのみで、「何に使うか」のセマンティクスを持たない。`app_radius.dart` がコメントで用途を示しているのに対し `app_spacing.dart` にはコメントがない。`AppRadius` と揃えて各定数に用途コメントを付けると保守性が向上する。

- [x] **`AppCardTheme` が `ThemeExtension` だが取得 extension がない** — `lib/core/design_system/extensions/app_card_theme.dart` — `AppThemeTokens` には `context.tokens` extension があるが、`AppCardTheme` には対応する `context.cardTheme` 等の取得 extension が存在しない。`defaultCardTheme` というフォールバック定数があるが、実際に Widget 側が `Theme.of(context).extension<AppCardTheme>() ?? defaultCardTheme` を毎回書く必要があり冗長。

- [x] **`app_shadows.dart` がトークン定義ではなく関数** — `lib/core/design_system/tokens/app_shadows.dart` — 他のトークンファイル（`app_colors.dart`・`app_spacing.dart` 等）は `abstract final class` + `static const` のパターンだが、`app_shadows.dart` は関数 `cardElevatedShadow()` として定義されている。ファイル名が `tokens/` 配下にあるにもかかわらずトークン（定数）ではなくファクトリ関数であり、パターンの一貫性が低い。ただし引数（`primary` カラーと `isDark` フラグ）に依存するため定数化は難しく、現状は許容範囲内。

- [x] **`main.dart` の `Logger.root.level` が `kDebugMode` で分岐していない** — `lib/main.dart:20` — `Logger.root.level = Level.INFO` がリリースビルドでも有効になる。リリースビルドでは `Level.WARNING` 以上のみにすることで不要なログ出力を防げる。
  ```dart
  Logger.root.level = kDebugMode ? Level.INFO : Level.WARNING;
  ```

- [x] **`AppThemeTokens.light` の `cardBorder` が `lightBorder` と同一** — `lib/core/design_system/extensions/app_theme_tokens.dart:42-43` — `border` と `cardBorder` 両方が `AppColors.lightBorder` を参照しており、Light テーマでは区別がない。Dark テーマでは `darkBorder`（`0xFF1E293B`）と `darkBorderCard`（`0xFF334155`）で使い分けている。Light テーマでもカードボーダーを少し暗くしたい場合のために別トークンを持っているなら、値も差別化すべき。

---

### Positive（良い実装）

- **`sealed class AppException` + `final class` サブクラスの設計** — `lib/core/error/app_exception.dart` — Dart 3.x の `sealed class` を適切に活用しており、`switch (error)` の exhaustive チェックが静的に機能する。`ErrorView` の `switch (error)` パターン（`lib/core/widgets/error_view.dart:21-31`）でも網羅チェックが働いており、新しいエラー型を追加した際にコンパイルエラーで検知できる設計。

- **`AppThemeTokens` の `lerp` 実装** — `lib/core/design_system/extensions/app_theme_tokens.dart:76-91` — テーマ切替アニメーションのために `Color.lerp` を正しく実装している。`?? fallback` パターンも null 安全に書かれている。

- **プリミティブ → セマンティックの分離** — `AppColors`（プリミティブ）→ `AppThemeTokens`（セマンティック）の 2 層構造が維持されており、コンポーネントは `AppThemeTokens` のみを参照する設計が徹底されている（`SkeletonListView` が `context.tokens` を使用している点も良い）。

- **`Dio` の timeout 設定** — `lib/core/api/pub_dev_api_client.dart:83-85` — `connectTimeout` と `receiveTimeout` を両方 10 秒で設定しており、無限待ちを防いでいる。

- **`ThemeModeNotifier.toggle()` の switch 式** — `lib/app/theme_mode_notifier.dart:15-18` — Dart 3.x の switch 式を活用し、ドットショートハンド記法（`.dark`・`.light`）で簡潔に記述している。

- **`AppCardTheme.defaultCardTheme` によるフォールバック** — `lib/core/design_system/extensions/app_card_theme.dart:50-54` — ThemeExtension の登録忘れに対するフォールバックが `const` で定義されており、パフォーマンス上も問題ない。

- **`go_router` の TypedGoRoute 活用** — `lib/app/router.dart` — 型安全なルーティングを `TypedGoRoute` + `GoRouteData` で実装しており、文字列リテラルによるルート参照のバグを防いでいる。

- **エラーメッセージに内部情報を含めない** — `lib/core/api/pub_dev_api_client.dart:69-71` — `ServerException` のメッセージは `'Server returned ${e.response!.statusCode}'` のみでレスポンスボディを含めていない。スタックトレースや内部エラー詳細が UI に漏洩しないよう `AppException.message` のみを表示する設計になっている。

---

## 修正例（優先度順）

### 1. `AppColors.lightBorderSubtle` の修正（Critical）

```dart
// lib/core/design_system/tokens/app_colors.dart

// Before（誤った値）:
static const Color lightBorderSubtle = Color(0xFF334155);  // Slate-700: ダークすぎる

// After（修正案 A: 薄いボーダーとして正しい値に修正）:
static const Color lightBorderSubtle = Color(0xFFCBD5E1);  // Slate-300

// After（修正案 B: 未使用なら削除）:
// 削除する
```

### 2. `_get()` の DioException ハンドリング完全化（Critical）

```dart
// lib/core/api/pub_dev_api_client.dart

Future<Map<String, dynamic>> _get(String url) async {
  _logger.info('GET $url');
  try {
    final response = await _dio.get<Map<String, dynamic>>(url);
    _logger.info('GET $url -> ${response.statusCode}');
    final data = response.data;
    if (data == null) {
      throw const ServerException(500, 'Empty response body');
    }
    return data;
  } on DioException catch (e) {
    _logger.severe('GET $url failed: $e');
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        throw const NetworkException();
      case DioExceptionType.badResponse:
        throw ServerException(
          e.response?.statusCode ?? 500,
          'Server returned ${e.response?.statusCode}',
        );
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        if (e.error is SocketException) throw const NetworkException();
        throw const NetworkException();
    }
  }
}
```

### 3. `pubDevApiClient` を keepAlive: true に変更（Major）

```dart
// lib/core/api/pub_dev_api_client.dart

// Before:
@riverpod
PubDevApiClient pubDevApiClient(Ref ref) { ... }

// After:
@Riverpod(keepAlive: true)
PubDevApiClient pubDevApiClient(Ref ref) { ... }
```

### 4. `context.tokens` extension に assert を追加（Major）

```dart
// lib/core/design_system/extensions/app_theme_tokens.dart

extension AppThemeTokensX on BuildContext {
  AppThemeTokens get tokens {
    assert(
      Theme.of(this).extension<AppThemeTokens>() != null,
      'AppThemeTokens が ThemeData.extensions に登録されていません。'
      'app/theme.dart の _buildTheme を確認してください。',
    );
    return Theme.of(this).extension<AppThemeTokens>() ?? AppThemeTokens.light;
  }
}
```

### 5. `error_view.dart` の Gap をトークン化（Major）

```dart
// lib/core/widgets/error_view.dart

// Before:
const Gap(20),  // line 55
const Gap(8),   // line 63
const Gap(28),  // line 71

// After:
const Gap(AppSpacing.xl),   // 20dp
const Gap(AppSpacing.sm),   // 8dp
const Gap(AppSpacing.xxl),  // 24dp（または xxxl=32dp に揃える。28dp は AppSpacing に追加）
```

### 6. `SkeletonListView` の Colors.white に説明コメントを追加（Major）

```dart
// lib/core/widgets/skeleton_list_view.dart

class _SkeletonTile extends StatelessWidget {
  const _SkeletonTile();

  @override
  Widget build(BuildContext context) {
    // Shimmer の仕様上、子ウィジェットの色は Shimmer の baseColor/highlightColor で
    // ColorFilter を通じて上書きされるため、Colors.white を使用しても問題ない。
    // デザイントークンを使う必要はなく、CLAUDE.md の「No hardcoded colors」の
    // 例外に該当する。
    return Padding(
      ...
```

---

## サマリー

| 重要度 | 件数 |
|--------|------|
| Critical | 2 件 |
| Major | 4 件 |
| Minor | 6 件 |
| Positive | 7 件 |

最優先で対処すべきは `lightBorderSubtle` の意味論的誤りと `DioException` ハンドリングの不完全性。次いで `pubDevApiClient` の `keepAlive` 設定と `context.tokens` のフォールバック問題への対処を推奨する。
