# pubdev_viewer

pub.dev のパッケージ情報を閲覧する Flutter アプリ。

## Commands

- `fvm flutter` / `fvm dart` — FVM 管理。`flutter` / `dart` 直接呼び出し禁止
- `fvm dart run build_runner build -d` — コード生成（freezed/riverpod/json/go_router）
- `fvm dart analyze` / `fvm flutter test` — 解析 / テスト
- `fvm dart format .` — フォーマット（PostToolUse hook で自動実行済み）

## Architecture

Feature-First + Riverpod。依存方向: `screens/` → `notifiers/` → `repository/` → `models/`

- feature 間の直接依存は禁止。共通処理は `core/` に置く。
- API スキーマは `docs/openapi.yaml` を参照。画面仕様は `docs/overview.md` を参照。
- 新しい feature を追加するときは `/pubdev-new-feature` スキルを参照。

## Critical Rules

**No interfaces.** Repository は具象クラスのみ。`abstract class XxxRepository` は作らない。
テストは `FakeXxxRepository extends Fake implements XxxRepository` で対応。

**No UseCase.** Notifier から Repository を直接呼ぶ。中間クラスなし。

**No Either.** エラーは例外で表現し try/catch で処理する。`Result<T>` / `Either<F,T>` 禁止。

**No Entity split.** `fromJson`/`toJson` を持つ 1 クラスで完結。API 形状と UI が実際に異なる場合のみ変換クラスを作る。

**No premature core promotion.** feature 固有モデルは 2 feature で共有されてから `core/` に昇格させる。

**No hardcoded colors/spacing.** Widget 内に `Colors.red` や `fontSize: 24` 直書き禁止。

**No hardcoded strings.** UI に表示するラベル・メッセージは `AppStrings` 定数を使う。`Text('LATEST')` のような直書き禁止。

**No relative imports.** `import '../../../...'` 禁止。常に `package:pubdev_viewer/...` 形式の絶対パスを使う。

**Zero Linter errors.** `fvm dart analyze` でエラー・警告ゼロを維持する。コード変更後は必ず確認。

## Comments

**WHY only.** コメントは「なぜこの実装か」を書く。コードから読める WHAT は書かない。

- `/// XxxResponse のデータクラス。` のようなクラス名の言い換え禁止
- マジックナンバー・設計判断・トレードオフ・外部制約に WHY コメントを付ける
- 1〜2 行、日本語で簡潔に
- 自明なコードにはコメント不要

## Design System

```dart
import 'package:pubdev_viewer/core/design_system/design_system.dart';
// AppSpacing.xs/sm/md/lg/xl/xxl/xxxl (4dp grid)
// AppRadius.skeleton/avatar/button/card/full
// context.tokens → AppThemeTokens (light/dark aware semantic colors)
// cardElevatedShadow(colorScheme.primary, isDark: ...)
```

## Git

Conventional Commits 形式、日本語メッセージ。論理単位ごとにコミット。
`feat` / `fix` / `refactor` / `docs` / `chore`
