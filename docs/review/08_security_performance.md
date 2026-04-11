# Phase 8: セキュリティ・パフォーマンス レビュー結果

## 使用スキル
- `vgv-static-security` — Flutter セキュリティベストプラクティス
- `flutter-riverpod-expert` — Provider リーク・不要な再ビルド
- `dart-best-practices` — パフォーマンス上の懸念

---

## セキュリティチェックリスト

| チェック項目 | ステータス | 詳細 |
|------------|-----------|------|
| URL スキーム検証（外部リンク） | ⚠️ | `https` / `http` 両方を許可。`http` 許可の明示的な理由なし |
| `launchUrl` の `await` | ❌ | `onPressed: () => launchUrl(parsed)` — `await` なしで失敗を無視 |
| `launchMode` 指定 | ⚠️ | 未指定（`platformDefault`）。Android では in-app WebView になる可能性あり |
| `Uri.parse` の安全性（ShareButton） | ⚠️ | `Uri.parse` 使用。形式不正時に例外をスローする可能性あり |
| URL パラメータのサニタイズ | ⚠️ | `packageName` がそのまま API パスに結合される。バリデーションなし |
| エラーメッセージの情報漏洩 | ✅ | `ServerException` は `'Server returned ${statusCode}'` のみ。内部スタックトレース非露出 |
| ログへの機密情報出力 | ✅ | `GET $url` / ステータスコードのみ。ヘッダー・ボディは非出力 |
| `MarionetteBinding` のビルド分離 | ✅ | `kDebugMode` ガード済み。リリースビルドに影響なし |
| `baseUrl` のハードコード | ✅ | `pub.dev` 固定の読み取り専用アプリとして許容範囲 |
| `share_plus` の安全な使用 | ⚠️ | URL は固定文字列結合のため XSS リスクなし。ただし `Uri.parse` 例外リスクあり |
| Provider の auto-dispose | ⚠️ | `@riverpod` はデフォルト auto-dispose だが、画面遷移時に毎回 API 呼び出しが発生 |
| `useEffect` スクロールリスナー管理 | ✅ | cleanup 関数で `removeListener` が正しく呼ばれている |
| `ref.listen` のライフサイクル | ✅ | `HookConsumerWidget` 内で管理されており、適切に解除される |

---

## 発見事項

### Critical（修正必須）

- [ ] **`launchUrl` の `await` 欠落** — `lib/features/package_detail/screens/package_detail_screen.dart:217`

  ```dart
  // 現在（Bad）
  onPressed: () => launchUrl(parsed),

  // 修正後（Good）
  onPressed: () async {
    final launched = await launchUrl(
      parsed,
      mode: LaunchMode.externalApplication,
    );
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('リンクを開けませんでした')),
      );
    }
  },
  ```

  `launchUrl` は `Future<bool>` を返す。`await` なしだと起動失敗を検知できず、ユーザーに何も通知されない。`url_launcher` のドキュメントでも `await` を強く推奨している。

---

### Major（強く推奨）

- [ ] **`http` スキームを許可する理由が不明確** — `lib/features/package_detail/screens/package_detail_screen.dart:213`

  ```dart
  // 現在
  if (parsed != null &&
      (parsed.scheme == 'https' || parsed.scheme == 'http')) {
  ```

  `pub.dev` の pubspec フィールド（`homepage`, `repository`）は大半が `https`。`http` を許可すると中間者攻撃（MITM）リスクが生じる。pub.dev の API レスポンスに実際に `http://` のみの URL が含まれるケースを確認した上で、不要であれば `https` 限定に変更すること。

  ```dart
  // 推奨（https のみ）
  if (parsed != null && parsed.scheme == 'https') {
  ```

- [ ] **`launchMode` 未指定** — `lib/features/package_detail/screens/package_detail_screen.dart:217`

  `LaunchMode.platformDefault` では Android で in-app WebView が開く場合があり、ユーザーが意図しないブラウザ動作になる。外部リンクは明示的に `LaunchMode.externalApplication` を指定することを強く推奨。

  ```dart
  await launchUrl(parsed, mode: LaunchMode.externalApplication);
  ```

- [x] **`Uri.parse` で例外の可能性** — `lib/features/package_detail/screens/package_detail_screen.dart:196` — **対応済み**: `Uri.tryParse` に変更し null ガードを追加。

  ```dart
  // 現在（Bad）
  uri: Uri.parse('https://pub.dev/packages/$packageName'),

  // 修正後（Good）
  final uri = Uri.tryParse('https://pub.dev/packages/$packageName');
  if (uri == null) return;
  SharePlus.instance.share(ShareParams(uri: uri));
  ```

  この箇所は固定文字列 + `packageName` の結合なので実用上リスクは低いが、`packageName` に予期しない文字（スペース等）が含まれると `Uri.parse` がスローする。`Uri.tryParse` に変更してガードを追加するのがベストプラクティス。

- [ ] **`_gradient` getter がビルドごとにハッシュ計算** — `lib/features/package_list/screens/widgets/package_list_tile.dart:25-28`

  ```dart
  // 現在（Bad）— build() のたびに実行される
  List<Color> get _gradient {
    final hash = widget.package.name.codeUnits.fold(0, (a, b) => a + b);
    return AppColors.avatarGradients[hash % AppColors.avatarGradients.length];
  }
  ```

  `StatefulWidget` の `State` なので `initState` または `late final` で1度だけ計算可能。

  ```dart
  // 修正後（Good）
  late final List<Color> _gradient = _computeGradient();

  List<Color> _computeGradient() {
    final hash = widget.package.name.codeUnits.fold(0, (a, b) => a + b);
    return AppColors.avatarGradients[hash % AppColors.avatarGradients.length];
  }
  ```

  `ListView.builder` で大量のタイルが表示されるため、スクロール中に全タイルで毎フレーム計算されるとジャンクの原因になりうる。

- [ ] **`_sortedVersions` getter がビルドごとにリストコピー＋ソート** — `lib/features/package_detail/screens/widgets/versions_section.dart:19-23`

  ```dart
  // 現在（Bad）— build() のたびに [...versions]..sort() が実行される
  List<PackageDetailVersion> get _sortedVersions {
    return [...versions]..sort(
      (a, b) => b.published.compareTo(a.published),
    );
  }
  ```

  `StatelessWidget` のため `late final` は使えないが、`build()` 内でローカル変数として計算する実装は現在正しく行われている（`final sorted = _sortedVersions;` と1回だけ呼んでいる）。ただし getter 自体は毎 `build` 呼び出しで新しいリストを生成する。`StatefulWidget` への変更か、リポジトリ/notifier 層でソート済みデータを提供することを検討。

  ```dart
  // 代替案: build() 内でインライン化してメソッド呼び出しを明示
  @override
  Widget build(BuildContext context) {
    // getter に頼らずインラインで明示的に1回だけ計算
    final sorted = ([...versions]..sort((a, b) => b.published.compareTo(a.published)));
    ...
  }
  ```

---

### Minor（改善提案）

- [ ] **API レスポンスキャッシュなし（UX）** — `lib/features/package_detail/notifiers/package_detail_notifier.dart`

  `@riverpod` のデフォルト `autoDispose: true` により、パッケージ詳細画面を離れると Provider が破棄される。詳細画面に戻るたびに2つの API リクエスト（detail + publisher）が発生する。頻繁にナビゲーションする場合の UX 改善として `keepAlive()` または `@Riverpod(keepAlive: true)` の検討も可能（ただしメモリ使用量とのトレードオフあり）。

  ```dart
  // 検討案: ref.keepAlive() でキャッシュ保持
  @override
  Future<PackageDetailState> build(String packageName) async {
    final link = ref.keepAlive();
    // 一定時間後に破棄する場合は Timer で link.close() を呼ぶ
    ...
  }
  ```

- [ ] **Dio の retry 未設定** — `lib/core/api/pub_dev_api_client.dart:80-88`

  一時的なネットワークエラー（タイムアウト等）に対してリトライなし。`dio_smart_retry` パッケージや Dio の Interceptor でリトライロジックを追加することでモバイル環境での堅牢性が向上する。この規模のアプリでは必須ではないが、ユーザーへの透明性（リトライ中のインジケータ）とセットで検討。

- [ ] **URL パラメータのサニタイズなし** — `lib/app/router.dart:29-31` / `lib/core/api/pub_dev_api_client.dart:39`

  `GoRouter` の `TypedGoRoute` で `:name` パスパラメータが取得され、そのまま `$_baseUrl/api/packages/$name` にテンプレート結合される。パス区切り文字（`/`, `..`）が含まれると意図しないエンドポイントにアクセスされる可能性がある（サーバー側では弾かれるが）。

  ```dart
  // 推奨: 正規表現でパッケージ名を検証
  // pub.dev のパッケージ名は [a-z0-9_] のみ許可
  static final _validPackageName = RegExp(r'^[a-z0-9_]+$');

  Future<Map<String, dynamic>> getPackageDetail(String name) {
    if (!_validPackageName.hasMatch(name)) {
      throw const ServerException(400, 'Invalid package name');
    }
    return _get('$_baseUrl/api/packages/$name');
  }
  ```

- [ ] **`package_detail_screen.dart` の `SizedBox(height: 16 + ...)` のハードコード** — `lib/features/package_detail/screens/package_detail_screen.dart:84`

  ```dart
  SizedBox(height: 16 + MediaQuery.paddingOf(context).bottom),
  ```

  `16` は `AppSpacing.md` に該当するが直書きされている。デザインシステムのルール違反。

  ```dart
  SizedBox(height: AppSpacing.md + MediaQuery.paddingOf(context).bottom),
  ```

- [ ] **`_PackageHeroHeader` 内のマジックナンバー** — `lib/features/package_detail/screens/package_detail_screen.dart:152-153, 165`

  ```dart
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  // ...
  const SizedBox(width: 4),
  ```

  `10`, `4` がハードコード。デザインシステムの `AppSpacing` 値（`xs=4`, `sm=8`）に近い値を使用しているが、直書きになっている。

- [ ] **`colors: Colors.white` のハードコード** — `lib/features/package_list/screens/widgets/package_list_tile.dart:85`

  ```dart
  color: Colors.white,
  ```

  アバターのイニシャル文字色が固定 `Colors.white`。ダークモードでも機能するグラデーションカラーが使われているため現状問題ないが、デザインシステムポリシー上は違反。

---

### Positive（良い実装）

- **`Uri.tryParse` の使用（外部リンクバリデーション）** — `package_detail_screen.dart:211`
  `Uri.tryParse` を使い `null` チェックを挟んでいるため、不正な URL でクラッシュしない。パターンとして正しい。

- **スキーム検証によるフィルタリング** — `package_detail_screen.dart:212-213`
  `ftp://`, `mailto:` 等の非 Web スキームを弾く実装は適切。

- **エラーメッセージの適切な抽象化** — `app_exception.dart`
  `ServerException` は内部の詳細（レスポンスボディ等）を含まず、ステータスコードのみを保持。情報漏洩を防ぐ設計。

- **`MarionetteBinding` のデバッグ限定化** — `main.dart:13-19`
  `kDebugMode` で確実にガードされており、リリースビルドへの影響なし。

- **`useEffect` によるスクロールリスナーの適切な管理** — `package_list_screen.dart:22-35`
  `addListener` / `removeListener` が `useEffect` の cleanup 関数で対称的に管理されており、メモリリークなし。

- **並列 API リクエスト** — `package_detail_notifier.dart:18-21`
  `(detail, publisher).wait` で並列実行しており、逐次実行より高速。

- **ログに機密情報なし** — `pub_dev_api_client.dart:50-55`
  URL とステータスコードのみをログ出力。リクエスト/レスポンスボディ、認証情報は出力しない。

- **`loadMore` の二重実行防止** — `package_list_notifier.dart:25`
  `current.isLoadingMore` フラグで多重リクエストを防止している。

---

## 修正例

### 1. `launchUrl` の `await` 追加と `launchMode` 指定

```dart
// lib/features/package_detail/screens/package_detail_screen.dart
class _ExternalLinkButton extends StatelessWidget {
  const _ExternalLinkButton({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url case final String u when u.isNotEmpty) {
      final parsed = Uri.tryParse(u);
      // http を排除し https のみ許可
      if (parsed != null && parsed.scheme == 'https') {
        return IconButton(
          icon: const Icon(Icons.open_in_new),
          tooltip: '外部サイトで開く',
          onPressed: () async {
            final launched = await launchUrl(
              parsed,
              mode: LaunchMode.externalApplication,
            );
            if (!launched && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('リンクを開けませんでした')),
              );
            }
          },
        );
      }
    }
    return const SizedBox.shrink();
  }
}
```

### 2. `_ShareButton` の `Uri.tryParse` 化

```dart
// lib/features/package_detail/screens/package_detail_screen.dart
class _ShareButton extends StatelessWidget {
  const _ShareButton({required this.packageName});

  final String packageName;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.share),
      tooltip: '共有',
      onPressed: () {
        final uri = Uri.tryParse('https://pub.dev/packages/$packageName');
        if (uri == null) return;
        SharePlus.instance.share(ShareParams(uri: uri));
      },
    );
  }
}
```

### 3. `_gradient` を `late final` に変更

```dart
// lib/features/package_list/screens/widgets/package_list_tile.dart
class _PackageListTileState extends State<PackageListTile> {
  bool _pressed = false;

  // build() ごとの再計算を防ぐ
  late final List<Color> _gradient = _computeGradient();

  List<Color> _computeGradient() {
    final hash = widget.package.name.codeUnits.fold(0, (a, b) => a + b);
    return AppColors.avatarGradients[hash % AppColors.avatarGradients.length];
  }

  @override
  Widget build(BuildContext context) {
    // _gradient をそのまま参照
    ...
  }
}
```

### 4. パッケージ名バリデーション（API クライアント層）

```dart
// lib/core/api/pub_dev_api_client.dart
class PubDevApiClient {
  // pub.dev パッケージ名の許可パターン（英小文字・数字・アンダースコア）
  static final _validPackageName = RegExp(r'^[a-z0-9_]+$');

  Future<Map<String, dynamic>> getPackageDetail(String name) {
    if (!_validPackageName.hasMatch(name)) {
      throw const ServerException(400, 'Invalid package name');
    }
    return _get('$_baseUrl/api/packages/$name');
  }

  Future<Map<String, dynamic>> getPackagePublisher(String name) {
    if (!_validPackageName.hasMatch(name)) {
      throw const ServerException(400, 'Invalid package name');
    }
    return _get('$_baseUrl/api/packages/$name/publisher');
  }
}
```

---

## 優先度サマリー

| 優先度 | 件数 | 内容 |
|--------|------|------|
| Critical | 1 | `launchUrl` の `await` 欠落 |
| Major | 4 | `http` 許可・`launchMode` 未指定・`Uri.parse` 安全性・getter パフォーマンス |
| Minor | 6 | キャッシュ・retry・サニタイズ・ハードコード値 |
| Positive | 8 | 優れた実装事例 |
