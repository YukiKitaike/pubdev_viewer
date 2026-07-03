---
name: pubdev-api-client
description: >
  pubdev_viewer の API クライアント層・エラーハンドリング・Repository パターン。
  Dio ベースの ApiClient 設計、DioException → sealed AppException 変換、
  PubDevApiClient の継承パターン、keepAlive Provider、Repository の fromJson パースを
  実装・編集する際に使用。「API を追加」「エンドポイント追加」「Dio」「エラーハンドリング」
  「Repository を作って」「AppException」「ネットワークエラー」と言われたときに参照。
  新しい feature の API 接続・例外処理を書く場面では必ずこのスキルを確認すること。
  Fake の統一パターン自体は /pubdev-testing が扱う。
---

# API クライアント層パターン（pubdev_viewer）

## アーキテクチャフロー

```
PubDevApiClient extends ApiClient ← Dio (DI, keepAlive)
       ↓ Map<String, dynamic>
Repository ← fromJson でパース（ApiClient にパース処理を書かない）
       ↓ モデル
Notifier → ErrorView（sealed AppException の switch で出し分け）

例外の流れ:
DioException → ApiClient が AppException に変換 → そのまま伝播 → ErrorView
```

## 主要ファイル

| ファイル | 役割 | 読むタイミング |
|---|---|---|
| `lib/core/api/api_client.dart` | DioException → AppException 変換の実装 | エラーハンドリングの詳細を確認したいとき |
| `lib/core/api/pub_dev_api_client.dart` | pub.dev エンドポイント定義 + Provider | メソッド追加時にパターンを確認 |
| `lib/core/error/app_exception.dart` | sealed AppException 定義 | 例外型を追加・変更するとき |
| `lib/core/widgets/error_view.dart` | sealed switch でメッセージ出し分け | エラー表示の挙動を確認したいとき |
| `test/helpers/fakes.dart` | FakeDio / FakePubDevApiClient | テスト Fake のパターンを確認 |

---

## エンドポイント追加手順

新しい pub.dev API エンドポイントを追加する場合、この順序で実装する:

1. **PubDevApiClient にメソッド追加** — 返り値は `Map<String, dynamic>`。パースしない
2. **FakePubDevApiClient にコールバック + 呼び出し履歴を追加** — `test/helpers/fakes.dart`
3. **URL 検証テストを追加** — `test/core/api/pub_dev_api_client_test.dart`
4. **Repository で `fromJson` パースする** — `/pubdev-models` 参照
5. **Notifier から Repository を呼ぶ** — `/pubdev-state` 参照

---

## Repository テンプレート

新しい feature の Repository はこの形に従う。具象クラスのみ（No interfaces）、Provider はファイル末尾。

```dart
// lib/features/<feature_name>/repository/<feature_name>_repository.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:pubdev_viewer/core/api/pub_dev_api_client.dart';
import 'package:pubdev_viewer/features/<feature_name>/models/<response_name>.dart';

part '<feature_name>_repository.g.dart';

class FeatureNameRepository {
  FeatureNameRepository(this._apiClient);
  final PubDevApiClient _apiClient;

  Future<ResponseName> getFeature(String name) async {
    final json = await _apiClient.getFeature(name);
    return ResponseName.fromJson(json);
  }
}

@riverpod
FeatureNameRepository featureNameRepository(Ref ref) {
  return FeatureNameRepository(ref.watch(pubDevApiClientProvider));
}
```

---

## やってはいけないこと

```dart
// ❌ Repository 層で DioException を直接キャッチ（ApiClient が変換済み）
try {
  final json = await _apiClient.getPackages();
} on DioException catch (e) { ... }  // AppException をキャッチすべき

// ❌ ApiClient に fromJson パース処理を書く（Repository の責務）
Future<PackageListResponse> getPackages() async {
  final json = await get(url);
  return PackageListResponse.fromJson(json);  // NG: Repository でやる
}

// ❌ リクエストごとに Dio を new する（コネクションプール無駄）
@riverpod
PubDevApiClient pubDevApiClient(Ref ref) {
  return PubDevApiClient(Dio());  // keepAlive なしは NG
}
```

---

## テスト例

FakeDio / FakePubDevApiClient の定義とテストコードは [test_examples.md](references/test_examples.md) を参照。
