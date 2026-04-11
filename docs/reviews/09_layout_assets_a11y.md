# レイアウト・アセット・アクセシビリティ

> 対象セクション: アセットと画像 / レイアウトのベストプラクティス / アクセシビリティ (A11Y) / 利用ツール
> レビュー日: 2026-04-11

## サマリー

| 重要度 | 件数 |
|--------|------|
| Critical | 0 |
| Important | 1 |
| Minor | 3 |
| Good | 3 |

アプリの現在の規模ではレイアウトとアセット管理は十分だが、アクセシビリティ対応に改善が必要。`Semantics` ウィジェットの付与が不足しており、スクリーンリーダー利用者への配慮が欠けている。

## 指摘事項

### [Important] アクセシビリティ対応の不足（Semantics の欠落）

- **対象ファイル:** 全画面 Widget
- **ガイドライン参照:** flutter.md > アクセシビリティ > 検証（セマンティックラベル、スクリーンリーダーでのテストを定期的に行う）
- **現状:** 以下のカスタム Widget に `Semantics` ウィジェットやセマンティックラベルが付与されていない:
  - `PackageListTile` — パッケージ名とバージョンの意味的な説明がない
  - `ErrorView` — エラーメッセージのセマンティックロールが未定義
  - `OverviewSection` — セクションのランドマークとしてのセマンティクスがない
  - `VersionsSection` — バージョンリストの意味的な構造がない
  - `_buildShareButton` / `_buildExternalLinkButton` — `IconButton` に `tooltip` プロパティが設定されていない

  特に `IconButton` の `tooltip` 欠落は、スクリーンリーダー利用者がボタンの機能を理解できない直接的な問題。
- **リスク:** 視覚障害のあるユーザーがアプリを操作できない。特に `IconButton`（共有、外部リンク）は `tooltip` がないとスクリーンリーダーでボタンの用途が伝わらない。
- **推奨対応:**
  ```dart
  // IconButton に tooltip を追加
  IconButton(
    icon: const Icon(Icons.share),
    tooltip: '共有',
    onPressed: () => ...,
  );

  IconButton(
    icon: const Icon(Icons.open_in_new),
    tooltip: '外部サイトで開く',
    onPressed: () => ...,
  );

  // セクションに Semantics を追加
  Semantics(
    label: 'パッケージ概要',
    child: OverviewSection(...),
  );
  ```

### [Minor] レスポンシブレイアウトの未実装

- **対象ファイル:** `lib/features/package_list/screens/package_list_screen.dart`, `lib/features/package_detail/screens/package_detail_screen.dart`
- **ガイドライン参照:** flutter.md > レイアウトのベストプラクティス > レスポンシブ（`LayoutBuilder` または `MediaQuery` を使用）
- **現状:** `LayoutBuilder` や `MediaQuery` を使用したレスポンシブレイアウトが一切実装されていない。全画面が固定幅で表示される。
- **リスク:** 現状モバイル専用アプリのため影響は軽微だが、タブレットや Web 対応時に修正が必要。
- **推奨対応:** 08_visual_design_theming.md の [Minor] レスポンシブ対応なし と同一。画面幅に応じた最大幅制限の追加を検討。

### [Minor] flutter_svg が依存関係にあるが未使用

- **対象ファイル:** `pubspec.yaml:16`
- **ガイドライン参照:** flutter.md > アセットと画像 > ベクター画像（flutter_svg を使用）
- **現状:** `flutter_svg: ^2.2.3` が `dependencies` に含まれているが、プロジェクト内のどのファイルでも import されていない。SVG アセットも存在しない。
- **リスク:** 不要な依存パッケージがアプリサイズを増加させる。
- **推奨対応:** 現時点で使用予定がなければ `pubspec.yaml` から削除:
  ```bash
  dart pub remove flutter_svg
  ```

### [Minor] アセットパスの宣言がない

- **対象ファイル:** `pubspec.yaml`
- **ガイドライン参照:** flutter.md > アセットと画像 > 宣言（`pubspec.yaml` ですべてのアセットパスを宣言）
- **現状:** `pubspec.yaml` の `flutter:` セクションにアセットパスの宣言がない。`assets/` ディレクトリも存在しない。
- **リスク:** 現状アセットファイル（画像、SVG 等）がないため問題ない。将来アセットを追加する際に宣言を忘れないよう注意。
- **推奨対応:** アセット追加時に `pubspec.yaml` に宣言を追加:
  ```yaml
  flutter:
    uses-material-design: true
    assets:
      - assets/images/
  ```

### [Good] gap パッケージの適切な使用

- **説明:** flutter.md の利用ツールで推奨されている `gap` パッケージが適切に使用されている。`ErrorView`（`const Gap(16)`, `const Gap(24)`）、`PackageDetailScreen`（`const Gap(16)`）等で一貫してスペーシングに使用。`SizedBox(height: 16)` の代わりに可読性の高い API を提供。

### [Good] ListView.builder による遅延読み込み

- **説明:** flutter.md の「長いリストには遅延読み込み方式の Widget を活用」に準拠。`PackageListScreen` で `ListView.builder` が使用されており、画面外のアイテムは描画されない。`itemCount` も正しく設定されている。

### [Good] SingleChildScrollView の適切な使用

- **説明:** `PackageDetailScreen` で `SingleChildScrollView` と `AlwaysScrollableScrollPhysics` が組み合わされ、固定サイズのコンテンツ（概要 + バージョン一覧）がスクロール可能。`RefreshIndicator` との組み合わせで pull-to-refresh も有効。

## 次のアクション

- [ ] 全 `IconButton` に `tooltip` プロパティを追加
- [ ] 主要セクションに `Semantics` ウィジェットを追加
- [ ] 未使用の `flutter_svg` パッケージを `pubspec.yaml` から削除
