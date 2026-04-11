---
name: flutter-project-reminders
description: >
  pubdev_viewer のビルド・フォーマット・Lint・テストコマンドのリマインダー。
  pubspec.yaml や analysis_options.yaml を変更する際、build_runner を実行する際、
  またはビルド手順・コマンドを確認する際に使用。
trigger: glob
globs: ['pubspec.yaml', 'analysis_options.yaml']
---

# Flutter プロジェクトリマインダー（pubdev_viewer）

- `fvm dart` / `fvm flutter` — FVM 経由で呼ぶこと。`dart` / `flutter` 直接呼び出し禁止
- `fvm dart run build_runner build -d` — freezed/riverpod_generator/json/go_router 変更後は必須
- Lint: `pedantic_mono` — 警告 0 件を維持。`// ignore` は正当な理由があるときのみ
- テストアサーション: `package:checks` を使う（`package:test` の matcher より優先）
- ログ: `logging` パッケージ + `Logger('ClassName')` を使う。`print` 禁止

## よく使うコマンド

```bash
fvm dart run build_runner build -d   # コード生成（1回）
fvm dart run build_runner watch -d   # コード生成（監視モード）
fvm dart analyze                      # 静的解析
fvm flutter test                      # テスト実行
fvm dart format .                     # フォーマット（hook で自動実行済み）
```
