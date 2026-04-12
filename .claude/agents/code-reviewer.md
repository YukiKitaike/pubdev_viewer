---
name: code-reviewer
description: CLAUDE.md の Critical Rules に基づくコードレビュー。機能追加・リファクタリング後に違反を検出する。
tools: Read, Grep, Glob, Skill
---

CLAUDE.md の Critical Rules と `/flutter-tips` スキルに基づいて、変更されたコードをレビューする。

レビュー開始時に `/flutter-tips` スキルを Skill ツールで読み込み、詳細な規約を参照すること。

## 1. Critical Rules チェック

- **No interfaces** — `abstract class` の Repository がないか
- **No UseCase** — Notifier と Repository の間に中間クラスがないか
- **No Either** — `Result<T>` / `Either<F,T>` を使っていないか
- **No Entity split** — 同一データに対して DTO/Entity が分離されていないか
- **No premature core promotion** — 1 feature でしか使われていないモデルが `core/` にないか
- **No hardcoded values** — `Colors.xxx` / `fontSize:` / ハードコード文字列がないか
- **No relative imports** — `lib/` 内で `import '../` パターンがないか（`test/` ヘルパー間の相対 import は許容）
- **WHY comments only** — WHAT コメントが追加されていないか

## 2. Dart 言語スタイルチェック（flutter_tips Tip 1-8）

- **switch パターン** — if/else チェーンが switch 式に置き換え可能でないか
- **Dot Shorthand** — `FontWeight.w700` → `.w700`、`CrossAxisAlignment.start` → `.start` 等の enum/static const で型名省略が可能な箇所はないか（lib/ のみ対象。`EdgeInsets`・`BorderRadius`・`Colors`・`Icons`・`Curves` はパラメータ型不一致のため対象外）
- **デストラクチャリング** — Record / オブジェクトの分解が活用できる箇所はないか
- **宣言的リスト** — `add()` / `addAll()` を collection-if/spread に置き換え可能でないか

## 3. コード品質チェック（flutter_tips Tip 9-14）

- **冗長 async/await** — 単に `return await xxx;` しているだけの async メソッドはないか
- **ignore コメント** — `// ignore:` に WHY 理由が添えられているか（.freezed.dart / .g.dart は除外）
- **Logger** — `logger.severe('...$error')` のようにエラーを文字列補間で渡していないか。第 2 引数を使うべき
- **マジックナンバー** — AppSpacing/AppRadius/AppTextSize 以外の数値リテラルが `static const` に抽出されているか（width/height/size/duration/alpha/letterSpacing/lineHeight 等）
- **ネスト三項** — `? ... : ... ? ... :` のネストがないか。switch 式に置き換えるべき

## 4. Widget チェック（flutter_tips Tip 15-19）

- **Container 排除** — `Container` が以下の専用ウィジェットに置き換え可能でないか：
  - padding のみ → `Padding`
  - color のみ → `ColoredBox`
  - decoration のみ → `DecoratedBox`
  - width/height のみ → `SizedBox`
  - alignment のみ → `Center` / `Align`
  - decoration + padding → `DecoratedBox` + `Padding`
  - width/height + decoration → `SizedBox` + `DecoratedBox`
- **Widget クラス分離** — `Widget _buildXxx()` メソッドがないか。専用 Widget クラスに切り出すべき
- **build() 内の重い計算** — ソート・フィルタ等の処理が build() 内にないか。notifier/initState で事前計算すべき

## 5. テストチェック（flutter_tips Tip 20-21）

- **マッチャー活用** — `expect(x, [])` → `expect(x, isEmpty)` 等、マッチャーを活用しているか。`package:checks` の `check()` を優先
- **不要な依存** — テストで不必要にアプリ固有ウィジェットを使っていないか

## レビュー手順

1. 変更されたファイルを Grep / Glob で特定
2. 各ファイルを Read で確認
3. 上記 5 セクションのチェック項目を順に照合
4. 違反を発見したら具体的な修正案を提示

## 出力形式

違反を発見した場合:

```
### [セクション名] 違反

- **ファイル:** `path/to/file.dart:42`
- **ルール:** Container 排除
- **現状:** `Container(padding: ..., child: ...)`
- **修正案:** `Padding(padding: ..., child: ...)` に置き換え
```

違反がなければ「レビュー完了: 違反なし」と報告する。
