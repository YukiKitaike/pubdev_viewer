# パッケージ管理・QA

> 対象セクション: パッケージ管理 / API 設計の原則 / Lint ルール / タスク完了時の必須チェックリスト
> レビュー日: 2026-04-11

## サマリー

| 重要度 | 件数 |
|--------|------|
| Critical | 0 |
| Important | 2 |
| Minor | 2 |
| Good | 5 |

Lint 設定とパッケージ管理の基盤は良好。`pedantic_mono` による厳格な分析ルールが正しく設定され、`dart analyze` は問題なし。ただし `dart format` で 23 ファイルのフォーマット差分が検出されており、QA チェックリストの一部が未達成。

## 指摘事項

### [Important] dart format でフォーマット差分が検出（23 ファイル）

- **対象ファイル:** プロジェクト全体（23 ファイル）
- **ガイドライン参照:** flutter.md > タスク完了時の必須チェックリスト > フォーマットの適用（`dart format .` を実行し、全ファイルのフォーマットを整える）
- **現状:** `dart format --set-exit-if-changed .` を実行した結果、58 ファイル中 23 ファイルにフォーマット差分が検出された。主な対象:
  - `lib/features/package_detail/` 配下の複数ファイル
  - `lib/features/package_list/` 配下の複数ファイル
  - `test/` 配下の複数ファイル
- **リスク:** コードレビューやマージ時にフォーマット差分がノイズになる。CI でフォーマットチェックが設定されている場合はビルドが失敗する。
- **推奨対応:**
  ```bash
  dart format .
  ```
  を実行してフォーマットを適用する。また、今後のワークフローに `dart format` の自動実行（IDE の保存時フォーマットや pre-commit hook）を組み込む。

### [Important] package:checks が dev_dependencies に未含

- **対象ファイル:** `pubspec.yaml`
- **ガイドライン参照:** flutter.md > テスト > アサーション（`package:checks` の使用を推奨）
- **現状:** `package:checks` が `pubspec.yaml` の `dev_dependencies` に含まれていない。テストでは標準の `package:matcher` のみ使用。
- **リスク:** flutter.md が推奨するアサーションライブラリを使用する準備が整っていない。
- **推奨対応:**
  ```bash
  flutter pub add --dev checks
  ```

### [Minor] flutter_svg が依存に含まれているが未使用

- **対象ファイル:** `pubspec.yaml:16`
- **ガイドライン参照:** flutter.md > パッケージ管理
- **現状:** `flutter_svg: ^2.2.3` が `dependencies` に含まれているが、プロジェクト内で一切 import されていない。
- **リスク:** 不要な依存がアプリサイズを増加させる。依存関係の管理が雑に見える。
- **推奨対応:**
  ```bash
  dart pub remove flutter_svg
  ```

### [Minor] flutter.md 推奨パッケージの未導入（将来参照）

- **対象ファイル:** `pubspec.yaml`
- **ガイドライン参照:** flutter.md > ルーティング / アセットと画像 / 利用ツール
- **現状:** flutter.md で言及されているが現状未導入のパッケージ:
  - `animations` — `showModal` によるダイアログ表示（ルーティングセクション）
  - `adaptive_dialog` — シンプルなシステムダイアログ（ルーティングセクション）
  - `cached_network_image` — ネットワーク画像のキャッシュ（アセットセクション）
- **リスク:** 現状これらの機能が未実装のため即座の問題はない。機能追加時の参照情報として記録。
- **推奨対応:** 各機能の実装時に導入を検討する。

### [Good] dart analyze で問題なし

- **説明:** `dart analyze` を実行した結果、エラー・警告・Info が0件。flutter.md の「すべてのエラー・警告・Info を解消する」に完全準拠。

### [Good] pedantic_mono が正しく設定されている

- **説明:** `analysis_options.yaml` で `pedantic_mono` パッケージが正しく include されている。flutter.md の「`pedantic_mono` パッケージを採用」に準拠。生成ファイルの除外設定も適切。

### [Good] riverpod_lint が導入されている

- **説明:** `riverpod_lint: ^2.6.5` が `dev_dependencies` に含まれ、Riverpod 固有の lint ルールが有効。`ref.watch()` / `ref.read()` の誤用を静的に検出可能。

### [Good] 依存パッケージのバージョン管理

- **説明:** 全パッケージが `^` プレフィックスによる互換性バージョン指定を使用。固定バージョン指定やワイルドカードは使用されておらず、安定したバージョン管理が実現されている。

### [Good] build_runner が dev_dependencies に含まれている

- **説明:** flutter.md の「`build_runner` が `dev_dependencies` に含まれていることを確認」に準拠。`build_runner: ^2.4.15` が正しく設定されている。

## 次のアクション

- [ ] `dart format .` を実行してフォーマット差分を解消
- [ ] `package:checks` を `dev_dependencies` に追加
- [ ] 未使用の `flutter_svg` を `dependencies` から削除
- [ ] IDE またはpre-commit hook で `dart format` の自動適用を設定
