# Phase 4: package_detail Models & Repository レビュー結果

## 使用スキル
- `pubdev-models` — Freezed パターン・nullable フィールド設計
- `dart-new-syntax` — switch expressions in fromJson / Records `.wait`
- `dart-test-fundamentals` — Repository テストの網羅性・グループ構造

---

## 発見事項

### Critical（修正必須）

なし。

---

### Major（強く推奨）

- [ ] **`published` フィールドが `String` 型のまま UI 層で `DateTime.tryParse` している** — `lib/features/package_detail/models/package_detail_version.dart:16` / `lib/features/package_detail/screens/widgets/versions_section.dart:70-73`

  現状、Widget 内の `_formatDate` メソッドが `DateTime.tryParse(published)` でパースしており、パース失敗時のフォールバック（`return published;` — 生の ISO 8601 文字列をそのまま表示）が存在している。パース失敗はモデル層で検知すべきであり、UI 層がパース責務を持つのは SoC 違反。

  **推奨修正**: `@JsonConverter` または `fromJson` ファクトリ内で `DateTime` に変換し、フィールド型を `DateTime` にする。

  ```dart
  // package_detail_version.dart
  @freezed
  abstract class PackageDetailVersion with _$PackageDetailVersion {
    const factory PackageDetailVersion({
      required String version,
      required Pubspec pubspec,
      @JsonKey(name: 'archive_url') required String archiveUrl,
      @JsonKey(name: 'archive_sha256') required String archiveSha256,
      required DateTime published,  // ← String から DateTime へ
    }) = _PackageDetailVersion;

    factory PackageDetailVersion.fromJson(
      Map<String, dynamic> json,
    ) => _$PackageDetailVersionFromJson(json);
  }
  ```

  json_serializable は `String` → `DateTime` を自動変換するため、`@JsonConverter` も不要。`_formatDate` 相当のロジックは Widget から消える。

  OpenAPI スキーマ（`docs/openapi.yaml:185`）で `published` は `format: date-time` と定義されており、`DateTime` 型へのマッピングがスキーマの意図に合致する。

- [ ] **`PackageDetailState` の `fromJson` 欠落は正しいが、`*.g.dart` が生成されていない点の確認が必要** — `lib/features/package_detail/models/package_detail_state.dart:1-15`

  `PackageDetailState` は State モデルのため `fromJson` を持たないのは正しい。ただし、`part 'package_detail_state.freezed.dart'` のみで `.g.dart` 部宣言がないことを、チームが将来的に誤って `.g.dart` を追加しないよう、コメントで明示するとよい。

  ```dart
  /// パッケージ詳細画面の UI 状態を表すデータクラス。
  /// NOTE: State モデルのため fromJson / .g.dart は不要。
  @freezed
  abstract class PackageDetailState with _$PackageDetailState {
  ```

---

### Minor（改善提案）

- [ ] **`advisoriesUpdated` フィールドが UI で一切使用されておらず、削除候補** — `lib/features/package_detail/models/package_detail_response.dart:15`

  `PackageDetailScreen` / `OverviewSection` / `VersionsSection` のいずれでも `advisoriesUpdated` は参照されていない。OpenAPI スキーマには定義があるが、現在の UI 仕様（`docs/overview.md`）に該当項目がないなら、APIレスポンスにフィールドが存在しても無視する設計（= フィールドを定義しない）が "No premature promotion" の精神にも沿う。

  **推奨**: 画面に表示する予定がないなら `advisoriesUpdated` フィールドを削除する。表示予定があるなら `DateTime?` 型に変更する（`format: date-time` をモデル層で吸収）。

- [ ] **`PackagePublisherResponse` の単一フィールド設計 — Freezed クラスとしての妥当性** — `lib/features/package_detail/models/package_publisher_response.dart:8-16`

  フィールドが `String? publisherId` のみ。Freezed クラスにすることで `copyWith`・`==`・`toString` が得られるが、実用上は `String?` の typedef でも足りる。ただし:
  - OpenAPI で `PackagePublisherResponse` として独立した schema が定義されている
  - 将来フィールドが追加される可能性がある（例: `publisherUrl`）
  - `FakePackageDetailRepository` で `PackagePublisherResponse` 型として扱っている

  これらを鑑みると Freezed クラスのままで問題なし。現状維持を推奨。ただし、もしシンプルなデータクラスに変えるならその際は `fromJson` を削除し他の手段でデシリアライズが必要になることを注意点として記録しておく。

- [ ] **Repository テストに `group` のネストが不足** — `test/features/package_detail/repository/package_detail_repository_test.dart:17`

  dart-test-fundamentals スキルの指針: "Avoid Single Groups: Do not wrap all tests in a file with a single group call if it's the only one."

  現状は `group('PackageDetailRepository', ...)` の単一グループに全テストが入っており、成功系・エラー系のサブグループ分けがない。`package_list_repository_test.dart` と整合性を持たせる観点からも、以下のようなネストを検討する。

  ```dart
  group('PackageDetailRepository', () {
    group('getPackageDetail', () {
      test('returns parsed response', ...);
      test('rethrows NetworkException', ...);
    });
    group('getPackagePublisher', () {
      test('returns parsed response', ...);
      test('rethrows ServerException', ...);
    });
  });
  ```

- [ ] **`FakePackageDetailRepository` の `getPackagePublisher` に `Completer` がない** — `test/helpers/fakes.dart:106-109`

  `getPackageDetail` には `getPackageDetailCompleter` があり並列処理中の中断テストが可能だが、`getPackagePublisher` には同等の `Completer` がない。Notifier は `Future.wait` で両者を並列に呼び出すため、`getPackagePublisher` の遅延・キャンセルをテストする場合にブロッカーになりうる。将来のテスト拡張性のために追加を検討する。

  ```dart
  Completer<PackagePublisherResponse>? getPackagePublisherCompleter;

  @override
  Future<PackagePublisherResponse> getPackagePublisher(String name) {
    getPackagePublisherCallCount++;
    if (getPackagePublisherCompleter != null) {
      return getPackagePublisherCompleter!.future;
    }
    return onGetPackagePublisher!(name);
  }
  ```

- [ ] **モデルテストに `PackageDetailVersion.fromJson` 単体テストがない** — `test/features/package_detail/models/package_detail_response_test.dart`

  `PackageDetailVersion` のフィールド（特に `archiveSha256`・`published`）を直接アサートするテストが存在しない。`response.latest.version` のみ確認しているが、`published` の値や `archiveSha256` が正しくマッピングされているかは現テストでは未検証。

  ```dart
  group('PackageDetailVersion', () {
    test('fromJson parses all fields correctly', () {
      final version = PackageDetailVersion.fromJson(
        Map<String, dynamic>.from(packageDetailResponseJson['latest'] as Map),
      );
      expect(version.version, '1.6.0');
      expect(version.archiveSha256, 'abc123');
      expect(version.published, '2025-11-10T18:27:56.434747Z'); // または DateTime
      expect(version.archiveUrl, contains('http-1.6.0'));
    });
  });
  ```

- [x] **`versions_section.dart` に `fontSize: 13` / `fontSize: 9` / `fontSize: 12` の直書き** — `lib/features/package_detail/screens/widgets/versions_section.dart`

  `AppTextSize.mono13` / `AppTextSize.mono9` / `AppTextSize.mono12` に置換済み。`AppTextSize` クラスを `lib/core/design_system/tokens/app_text_size.dart` に新設し、全 JetBrainsMono サイズをトークン化した。

---

### Positive（良い実装）

- **API Response / State モデルの分離が正確**: `PackageDetailResponse`・`PackageDetailVersion`・`PackagePublisherResponse` は全て `fromJson` + `.g.dart` を持つ API Response モデルとして正しく定義されており、`PackageDetailState` は `fromJson` なし・`.g.dart` なしの State モデルとして明確に分離されている。pubdev-models スキルのパターンに完全準拠。

- **`Pubspec` の `core/` 昇格が適切**: `Pubspec` は `package_list` と `package_detail` の両 feature で共有されており、`lib/core/models/pubspec.dart` に昇格済み。CLAUDE.md の「2 feature で共有されてから昇格」ルールに従っている。

- **No interfaces の遵守**: `PackageDetailRepository` はインターフェースなしの具象クラスのみ。テスト用の `FakePackageDetailRepository extends Fake implements PackageDetailRepository` も CLAUDE.md の指示通り。

- **Records + `.wait` による並列 API コール**: `package_detail_notifier.dart:18-21` の `(detail, publisher) = await (...).wait` は Dart 3.0 Records と `Future.wait` の拡張メソッドを活用した慣用的かつ可読性の高い実装。

- **`if-case` パターンの活用**: `versions_section.dart:70` の `if (DateTime.tryParse(published) case final date?)` は Dart 3.0 の if-case + null-check パターンを適切に使用。

- **`PackageDetailVersion` と `PackageListVersion` が意図的に分離されている**: 両クラスは共通フィールド（`version`・`pubspec`・`archiveUrl`）を持ちつつも、`PackageDetailVersion` が `archiveSha256`・`published` を持ち、`PackageListVersion` が `packageUrl`・`url` を持つ。OpenAPI スキーマ（`docs/openapi.yaml:105-133`, `159-188`）で明示されている API の構造差異を正確に反映しており、"No premature core promotion" の原則に従った妥当な分離。

- **nullable フィールドの設計が API スキーマと整合**: `publisherId: String?`（OpenAPI: `nullable: true`）、`advisoriesUpdated: String?`（OpenAPI: `nullable: true`）、`Pubspec.homepage: String?` など、全 nullable フィールドが OpenAPI スキーマの定義と一致している。

- **`FakePackageDetailRepository` がテスト用途を正確に反映**: `onGetPackageDetail`・`onGetPackagePublisher` のコールバックと呼び出しカウンタを備え、モック・スタブ・スパイの役割を一つのクラスで担う設計は簡潔で拡張しやすい。

- **Repository の単一責務**: `PackageDetailRepository` は `getPackageDetail` と `getPackagePublisher` の 2 メソッドのみを持ち、並列呼び出しの責務は Notifier に委譲している。Repository 層が API の形状に忠実であり、Notifier 層が並列化の意思決定を行うという正しいレイヤー分担。

---

## 修正例

### Major: `published` を `DateTime` 型に変更する

#### 1. モデル変更（`package_detail_version.dart`）

```dart
// Before（16行目）
required String published,

// After
required DateTime published,
```

コード生成後、`_$PackageDetailVersionFromJson` は自動的に以下を生成する:

```dart
// 生成される .g.dart（変更不要）
published: DateTime.parse(json['published'] as String),
```

#### 2. Widget 修正（`versions_section.dart`）

```dart
// Before: _formatDate メソッドで手動パース（69-73行目）
String _formatDate(String published) {
  if (DateTime.tryParse(published) case final date?) {
    return dateFormat.format(date);
  }
  return published;
}

// After: DateTime 型を直接フォーマット
String _formatDate(DateTime published) {
  return dateFormat.format(published);
}
```

#### 3. ソート処理も型安全になる（`versions_section.dart:21`）

```dart
// Before: String の辞書順比較（ISO 8601 なので偶然正しく動くが型が不正確）
(a, b) => b.published.compareTo(a.published),

// After: DateTime の compareTo（意図が明確）
(a, b) => b.published.compareTo(a.published),  // 同じ呼び出しだが型安全
```

#### 4. フィクスチャは変更不要

```dart
// fixtures.dart の 'published': '2025-11-10T18:27:56.434747Z' はそのまま
// json_serializable が String → DateTime のパースを担う
```

---

## スキーマとモデルの対応表

| OpenAPI フィールド | 型 | モデルフィールド | 型 | 一致 |
|---|---|---|---|---|
| `PackageDetailResponse.name` | `string` | `name` | `String` | ✅ |
| `PackageDetailResponse.latest` | `PackageDetailVersion` | `latest` | `PackageDetailVersion` | ✅ |
| `PackageDetailResponse.versions` | `array` | `versions` | `List<PackageDetailVersion>` | ✅ |
| `PackageDetailResponse.advisoriesUpdated` | `string / date-time / nullable` | `advisoriesUpdated` | `String?` | △ (`DateTime?` が望ましい) |
| `PackageDetailVersion.version` | `string` | `version` | `String` | ✅ |
| `PackageDetailVersion.pubspec` | `Pubspec` | `pubspec` | `Pubspec` | ✅ |
| `PackageDetailVersion.archive_url` | `string` | `archiveUrl` (`@JsonKey`) | `String` | ✅ |
| `PackageDetailVersion.archive_sha256` | `string` | `archiveSha256` (`@JsonKey`) | `String` | ✅ |
| `PackageDetailVersion.published` | `string / date-time` | `published` | `String` | △ (`DateTime` が望ましい) |
| `PackagePublisherResponse.publisherId` | `string / nullable` | `publisherId` | `String?` | ✅ |
