---
name: flutter-tips
description: >
  Flutter/Dart 実践 Tips とコーディング規約。Dart 3.10+ dot shorthand・
  switch パターンマッチング・専用ウィジェット・マジックナンバー排除・
  宣言的リスト・lint 設定・型プロモーションのためのローカル変数化・
  String index アクセス回避など 19 項目。
  コード追加・レビュー・リファクタリング時に参照。テストの規約は /pubdev-testing が扱う。
---

# Flutter / Dart 実践 Tips

> このプロジェクトは Dart ^3.11.4 / Flutter 3.x を使用。全機能が利用可能。

## Tips 早見表

| # | Tips | キーワード | 参照 |
|---|---|---|---|
| 1 | switch パターンマッチング | if/else → switch 式 | [dart-language.md](references/dart-language.md) |
| 2 | null チェック `case final` | `!` 排除 | [dart-language.md](references/dart-language.md) |
| 3 | デストラクチャリング | Records, `.wait` | [dart-language.md](references/dart-language.md) |
| 4 | Dot Shorthand (3.10+) | `.min`, `.circle`, `.w700` | [dart-language.md](references/dart-language.md) |
| 5 | 宣言的リストリテラル | collection-if/for, spread | [dart-language.md](references/dart-language.md) |
| 6 | Wildcard Variables (3.7+) | `_` プレースホルダー | [dart-language.md](references/dart-language.md) |
| 7 | 冗長 async/await 排除 | 単純 Future 返却 | [code-quality.md](references/code-quality.md) |
| 8 | ignore コメントに理由 | lint suppress | [code-quality.md](references/code-quality.md) |
| 9 | Logger 構造化パラメータ | `severe('msg', e)` | [code-quality.md](references/code-quality.md) |
| 10 | マジックナンバー排除 | 名前付き定数 | [code-quality.md](references/code-quality.md) |
| 11 | ネスト三項→switch | 可読性 | [code-quality.md](references/code-quality.md) |
| 12 | 型プロモーション | ローカル変数化で `!` 不要 | [code-quality.md](references/code-quality.md) |
| 13 | String index 回避 | `firstGrapheme()` | [code-quality.md](references/code-quality.md) |
| 14 | Lint 設定 | riverpod_lint, custom_lint | [code-quality.md](references/code-quality.md) |
| 15 | 専用ウィジェット | Container → Padding/SizedBox | [flutter-widget.md](references/flutter-widget.md) |
| 16 | Sliver プレフィックス | 命名規約 | [flutter-widget.md](references/flutter-widget.md) |
| 17 | Widget クラス分離 | メソッド → クラス | [flutter-widget.md](references/flutter-widget.md) |
| 18 | build() 計算回避 | initState / notifier | [flutter-widget.md](references/flutter-widget.md) |
| 19 | compute() で Isolate | UI フリーズ防止 | [flutter-widget.md](references/flutter-widget.md) |

## いつどのファイルを読むか

- **Dart 言語機能**（switch, dot shorthand, null チェック, デストラクチャリング）→ [dart-language.md](references/dart-language.md)
- **コード品質**（マジックナンバー, 型プロモーション, String index, lint）→ [code-quality.md](references/code-quality.md)
- **Widget 選択・構造**（Container 置換, クラス分離, compute）→ [flutter-widget.md](references/flutter-widget.md)
