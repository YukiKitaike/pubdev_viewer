# Agent 作成・アップデート Tips 集

pubdev_viewer プロジェクトで Claude Code サブエージェントを作成・更新する際の実践的な Tips 集。
公式ドキュメントの全訳ではなく、このプロジェクトで実際に使える判断基準とパターンだけを抽出している。

参考: [公式ドキュメント](https://docs.claude.com/ja/docs/claude-code/sub-agents)

---

## 1. そもそも Agent を作るべきか？

まず「Agent ではなく Skill / Slash Command のほうが適切では？」を疑う。

| 目的 | 選ぶべきもの |
|:-----|:------------|
| 特定ドメインの知識・コード例を参照させたい | **Skill** (`.claude/skills/`) |
| 定型フロー（コミット、PR 作成等）を呼び出したい | **Slash Command** (`.claude/commands/`) |
| **別コンテキストで**読み取り専用レビューを走らせたい | **Agent** |
| 大量出力（テスト実行、ログ解析）をメイン会話から隔離したい | **Agent** |
| ツール権限を絞った状態で特定タスクを実行させたい | **Agent** |

**判断基準**: メイン会話のコンテキストを汚したくない / ツールを制限したい、のいずれかに該当しなければ Skill で十分。

---

## 2. 既存 Agent の配置とパターン

このプロジェクトでは `.claude/agents/` に以下の Agent を配置している。いずれも **「Skill を参照するレビュー型 Agent」** という共通パターン。

| Agent | 役割 | 参照 Skill |
|:------|:-----|:-----------|
| [code-reviewer.md](../../.claude/agents/code-reviewer.md) | CLAUDE.md の Critical Rules 違反を検出 | `/flutter-tips` |
| [pattern-reviewer.md](../../.claude/agents/pattern-reviewer.md) | Riverpod/Freezed/Test のパターン準拠 | `/pubdev-state` `/pubdev-models` `/pubdev-ui` 他 |
| [test-reviewer.md](../../.claude/agents/test-reviewer.md) | テストコードのパターン準拠 | `/pubdev-testing` |

新規 Agent を作るときは、まずこの 3 ファイルを読んで既存パターンを踏襲すること。

---

## 3. 作成手順

### 3.1 まず `/agents` コマンドで雛形生成

```
/agents
```

**Create new agent → Project** を選択。`.claude/agents/` に保存され Git 管理される。
既存パターンに合わせて手書きのほうが早い場合もあるが、初回は雛形生成を推奨。

### 3.2 最小フロントマター

必須は `name` と `description` のみ。このプロジェクトの標準構成:

```yaml
---
name: xxx-reviewer             # 小文字ハイフン
description: 〇〇を△△する。□□時に使用。  # 日本語 OK
tools: Read, Grep, Glob, Skill  # 必要最小限
---
```

### 3.3 `description` の書き方（最重要）

Claude はこの `description` を見て「この Agent に委譲するか」を判断する。
**「何を」「いつ使うか」を明示**する。

**悪い例**:
```yaml
description: コードをレビューする
```

**良い例**（既存 Agent より）:
```yaml
description: CLAUDE.md の Critical Rules に基づくコードレビュー。機能追加・リファクタリング後に違反を検出する。
```

積極的に使ってほしい Agent には `Use proactively when ...` / `〇〇時に使用` を明記。

---

## 4. ツール選択の原則

### 4.1 レビュー型は読み取り専用に限定

```yaml
tools: Read, Grep, Glob, Skill
```

レビュー Agent は `Edit` / `Write` を **与えない**。誤って修正を始めるのを防ぐ。
このプロジェクトの既存 3 Agent すべてこの構成。

### 4.2 Skill 参照型は `Skill` ツール必須

スキルを読み込ませる設計なら `tools` に `Skill` を必ず含める。
忘れるとレビュー基準を読めず役に立たなくなる。

### 4.3 実装系は最小限の書き込み権限

修正まで任せるなら `Edit` を追加。`Write` は新規ファイル作成が必要な場合のみ。
`Bash` を渡すときは何に使うか明確な場合のみ（テスト実行、git diff 等）。

### 4.4 `disallowedTools` より `tools` 許可リストを使う

継承で余計なツールが混ざると事故のもと。明示的な許可リストを推奨。

---

## 5. モデル選択

`model` 未指定なら親会話から継承される（通常はこれで十分）。
明示する場合の目安:

| モデル | 用途 |
|:------|:-----|
| `haiku` | パターンマッチ中心の高速レビュー、ログ解析 |
| `sonnet` | 通常のレビュー、コード生成 |
| `opus` | 複雑な推論、アーキテクチャ判断 |
| `inherit`（既定） | 親会話の判断を引き継ぐ |

このプロジェクトの既存 Agent は `model` 未指定（= inherit）。特殊な要件がない限り明示不要。

---

## 6. システムプロンプト（本文）の書き方

### 6.1 冒頭で「何を入力とし何を出力するか」を 1 行で宣言

```markdown
CLAUDE.md の Critical Rules と `/flutter-tips` スキルに基づいて、変更されたコードをレビューする。
```

### 6.2 Skill を読むタイミングを明示

Skill 参照型 Agent では **「レビュー開始時に Skill を Skill ツールで読み込む」** と指示を入れる。
これを書かないと読まずに作業を始めることがある。

```markdown
レビュー開始時に `/flutter-tips` スキルを Skill ツールで読み込み、詳細な規約を参照すること。
```

### 6.3 チェックリスト形式で網羅性を担保

既存 Agent は **セクション番号付きチェックリスト** で構造化している。
見落としを防ぎ、後から項目追加がしやすい。

```markdown
## 1. Critical Rules チェック
- **No interfaces** — `abstract class` の Repository がないか
- **No UseCase** — ...

## 2. Dart 言語スタイルチェック
- **switch パターン** — if/else チェーンが ...
```

### 6.4 出力フォーマットをテンプレートで固定

自由記述を許すとフォーマットがバラつく。コードブロックで型を指定する。

```markdown
## 出力形式

違反を発見した場合:

\`\`\`
### [セクション名] 違反

- **ファイル:** `path/to/file.dart:42`
- **ルール:** Container 排除
- **現状:** `Container(padding: ..., child: ...)`
- **修正案:** `Padding(padding: ..., child: ...)` に置き換え
\`\`\`

違反がなければ「レビュー完了: 違反なし」と報告する。
```

### 6.5 手順番号で進行を明示

```markdown
## レビュー手順
1. 変更されたファイルを Grep / Glob で特定
2. 各ファイルを Read で確認
3. 上記 5 セクションのチェック項目を順に照合
4. 違反を発見したら具体的な修正案を提示
```

---

## 7. アップデート時の Tips

### 7.1 CLAUDE.md の Critical Rules を追加したら code-reviewer も更新

`.claude/CLAUDE.md` に新ルールを追加したら、[code-reviewer.md](../../.claude/agents/code-reviewer.md) の **セクション 1** に対応するチェック項目を追加する。
この 2 ファイルは対にして保守する。

### 7.2 Skill を新規追加したら pattern-reviewer に登録

`.claude/skills/` に新 Skill を追加したら、[pattern-reviewer.md](../../.claude/agents/pattern-reviewer.md) の「参照するスキル」一覧に追加する。
登録を忘れるとレビュー対象から漏れる。

### 7.3 `/flutter-tips` Tip 番号の再配番に注意

[code-reviewer.md](../../.claude/agents/code-reviewer.md) は `/flutter-tips` の **Tip 番号を参照している**（例: "Tip 1-8", "Tip 20-21"）。
Skill 側で Tip を追加・削除したら、Agent 側の番号レンジも同期させること。

### 7.4 セッション再起動で反映

Agent ファイル編集後は Claude Code セッションを再起動するか `/agents` を開いて再読込する。
保存直後は古い定義のまま動くことがある。

### 7.5 `description` を変えたら動作確認

委譲判断は `description` ベース。変更後は実際に「〇〇をレビューして」と呼んで、意図通り委譲されるかを確認する。

---

## 8. デバッグ Tips

### 8.1 Agent が呼ばれない

- `description` が曖昧 → 「いつ使うか」を具体化
- 必要なツールが `tools` に無い → トランスクリプトで失敗箇所を確認
- セッション再起動していない → 再起動

### 8.2 Agent が Skill を読まずに結論を出す

システムプロンプトに **「最初に Skill ツールで 〇〇 を読み込むこと」** を明記。指示がないと読まない。

### 8.3 想定外のファイルを編集する

`tools` から `Edit` / `Write` を外す。レビュー型は読み取り専用が原則。

### 8.4 出力がバラつく

出力フォーマットをコードブロックでテンプレート化（6.4 参照）。

---

## 9. テンプレート（コピペ用）

### レビュー型 Agent（Skill 参照）

```markdown
---
name: xxx-reviewer
description: 〇〇を△△スキルに基づいてレビューする。□□時に使用。
tools: Read, Grep, Glob, Skill
---

〇〇が `/△△` スキルに定義されたパターンに準拠しているかレビューする。

レビュー開始時に `/△△` スキルを Skill ツールで読み込むこと。

## チェックリスト

### カテゴリ 1

- [ ] 項目 1
- [ ] 項目 2

### カテゴリ 2

- [ ] 項目 1

## レビュー手順

1. 対象ファイルを Glob/Grep で特定し Read で確認
2. `/△△` スキルを Skill で読み込む
3. チェックリストと照合
4. 違反があれば修正案を提示

## 出力形式

違反を発見した場合:

\`\`\`
### [ファイルパス:行番号]
- **違反**: 〈項目〉
- **現状**: 〈コード〉
- **修正案**: 〈修正後〉
\`\`\`

問題なしの場合: 「パターン準拠 OK」
```

---

## 10. チェックリスト（作成・更新時）

### 新規作成

- [ ] `Skill` / `Slash Command` で済まないことを確認した
- [ ] 既存 3 Agent のパターンを読んだ
- [ ] `name` は小文字ハイフン
- [ ] `description` に「何を」「いつ使うか」を明記
- [ ] `tools` は必要最小限（レビュー型なら `Read, Grep, Glob, Skill`）
- [ ] Skill 参照なら「最初に Skill を読み込む」指示を本文に記載
- [ ] 出力フォーマットをテンプレート化
- [ ] セッション再起動して呼び出し確認

### 既存更新

- [ ] CLAUDE.md 更新時は code-reviewer も同期
- [ ] Skill 追加時は pattern-reviewer に登録
- [ ] `/flutter-tips` Tip 番号変更時は参照レンジを同期
- [ ] `description` 変更時は委譲動作を再確認
- [ ] セッション再起動で反映

---

## 関連ドキュメント

- 公式: [サブエージェントの作成](https://docs.claude.com/ja/docs/claude-code/sub-agents)
- 公式: [Skills](https://docs.claude.com/ja/docs/claude-code/skills)
- このプロジェクトの既存 Agent: [.claude/agents/](../../.claude/agents/)
- このプロジェクトの Skill: [.claude/skills/](../../.claude/skills/)
