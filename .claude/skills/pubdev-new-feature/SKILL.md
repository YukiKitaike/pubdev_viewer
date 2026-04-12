---
name: pubdev-new-feature
description: >
  pubdev_viewer に新しい feature を追加する際のステップバイステップガイド。
  新しいスクリーン・機能・API データを追加する場合に使用。
  models → repository → notifier → screen の全レイヤーを網羅する。
---

# 新 Feature の追加手順

このアプリは Feature-First + Riverpod アーキテクチャ。
新 feature は必ず `lib/features/<feature_name>/` 配下に 4 つのサブディレクトリで構成する。

## ディレクトリ構成

```
lib/features/<feature_name>/
├── models/
│   ├── <feature_name>_response.dart   # API レスポンスモデル（fromJson あり）
│   └── <feature_name>_state.dart      # UI 状態モデル（fromJson なし）
├── repository/
│   └── <feature_name>_repository.dart
├── notifiers/
│   └── <feature_name>_notifier.dart
└── screens/
    ├── <feature_name>_screen.dart
    └── widgets/
        └── （必要なら小分け Widget を追加）
```

---

## Step 1: モデル作成 → `/pubdev-models`

Response モデル（`fromJson` あり）と State モデル（`fromJson` なし）を作成する。
Freezed + json_serializable のパターン・命名規約・snake_case マッピングは `/pubdev-models` を参照。

コード生成: `fvm dart run build_runner build -d`

---

## Step 2: Repository 作成 → `/pubdev-api-client`

具象クラスのみ（CLAUDE.md の No interfaces ルール参照）。
API クライアントの継承パターン・新エンドポイント追加は `/pubdev-api-client` を参照。

```dart
// lib/features/<feature_name>/repository/<feature_name>_repository.dart
part '<feature_name>_repository.g.dart';

class FeatureNameRepository {
  FeatureNameRepository(this._apiClient);
  final PubDevApiClient _apiClient;

  Future<FeatureNameResponse> getFeature({String? pageUrl}) async {
    final json = await _apiClient.getFeature(pageUrl: pageUrl);
    return FeatureNameResponse.fromJson(json);
  }
}

@riverpod
FeatureNameRepository featureNameRepository(Ref ref) {
  return FeatureNameRepository(ref.watch(pubDevApiClientProvider));
}
```

コード生成: `fvm dart run build_runner build -d`

---

## Step 3: Notifier 作成 → `/pubdev-state`

AsyncNotifier の build/loadMore/refresh/エラーハンドリングは `/pubdev-state` を参照。

コード生成: `fvm dart run build_runner build -d`

---

## Step 4: Screen 作成 → `/pubdev-ui`

`HookConsumerWidget` + `asyncState.when` で loading/error/data を分岐する。
デザイントークン（AppSpacing・AppRadius・context.tokens）は `/pubdev-ui` を参照。

### 文字列定数

画面に表示するラベル・エラーメッセージ等は `lib/core/strings/app_strings.dart` に定義する。

- 新しい文言を追加する前に、既存の `AppStrings` に同じ意味の定数がないか確認する
- 変数名は文言の意味をそのまま使う（例: `retry`, `share`, `networkErrorTitle`）

### Core Utils

`lib/core/utils/` に汎用ユーティリティ関数がある。feature 内で同等の処理を再実装しない。

| ファイル | 関数 | 用途 |
|----------|------|------|
| `date_formatter.dart` | `formatDate(DateTime)` | `yyyy-MM-dd` 形式の日付表示 |
| `json_converters.dart` | `dateTimeFromIso8601` / `dateTimeToIso8601` | `@JsonKey` 用 ISO 8601 DateTime 変換 |
| `gradient_selector.dart` | `selectGradientByName(String)` | アバターグラデーション選択 |
| `url_utils.dart` | `pubDevPackageUrl(String)` / `isHttpUrl(String?)` | pub.dev URL 構築・HTTP URL バリデーション |

---

## Step 5: ルート登録 → `/pubdev-navigation`

`lib/app/router.dart` に型安全ルートを追加する。
TypedGoRoute・GoRouteData・パスパラメータ・遷移方法は `/pubdev-navigation` を参照。

コード生成: `fvm dart run build_runner build -d`

---

## Step 6: テスト作成 → `/pubdev-testing`

Fake パターン・フィクスチャビルダー・createTestApp・package:checks・タグ分類は `/pubdev-testing` を参照。
`test/features/<feature_name>/` 配下に `lib/` と同じ階層構造でテストを配置。

テスト準備:
1. `test/helpers/fakes.dart` に Fake クラスを追加
2. `test/helpers/fixtures.dart` に const JSON マップ + 型付きビルダー関数を追加
3. Notifier テスト → Repository テスト → Screen ウィジェットテストの順で作成

---

## やってはいけないこと

```dart
// ❌ feature 固有モデルを最初から core/models/ に置く（2 feature で共有されてから昇格）
lib/core/models/my_new_feature_response.dart

// ❌ Repository にインターフェースを定義する（具象クラスのみ。テストは Fake implements）
abstract class FeatureNameRepository { ... }

// ❌ UseCase 中間クラスを挟む（Notifier → Repository 直接）
class GetFeatureUseCase { ... }

// ❌ Screen が Repository を直接参照する（依存方向違反: screens → notifiers → repository）
class FeatureNameScreen extends HookConsumerWidget {
  final repo = ref.watch(featureNameRepositoryProvider); // NG
}
```

---

## チェックリスト

- [ ] models/ に Response + State モデルを作成（`/pubdev-models` 準拠）
- [ ] repository/ に具象クラス + `@riverpod` 関数を作成
- [ ] notifiers/ に `@riverpod class` を作成（`/pubdev-state` 準拠）
- [ ] screens/ に `HookConsumerWidget` を作成（`/pubdev-ui` 準拠）
- [ ] router.dart にルート追加
- [ ] テスト作成（`/pubdev-testing` 準拠）
- [ ] 各レイヤー追加後に `fvm dart run build_runner build -d` 実行
- [ ] `fvm dart analyze` でエラー 0 件確認
- [ ] `fvm flutter test` で既存テスト PASS 確認
