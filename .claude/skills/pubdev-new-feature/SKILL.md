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

## Step 1: モデル作成

詳細パターンは `/pubdev-models` スキルを参照。

**APIレスポンスモデル**（`fromJson` あり、`part *.g.dart` あり）:
```dart
// lib/features/<feature_name>/models/<feature_name>_response.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '<feature_name>_response.freezed.dart';
part '<feature_name>_response.g.dart';

@freezed
abstract class FeatureNameResponse with _$FeatureNameResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory FeatureNameResponse({
    String? nextUrl,
    required List<FeatureNameItem> items,
  }) = _FeatureNameResponse;

  factory FeatureNameResponse.fromJson(Map<String, dynamic> json) =>
      _$FeatureNameResponseFromJson(json);
}
```

> **snake_case マッピング**: `@JsonKey(name: 'snake_case')` を個別に書くのではなく、
> ファクトリコンストラクタに `@JsonSerializable(fieldRename: FieldRename.snake)` を付けて一括変換する。

**UI ステートモデル**（`fromJson` なし、`part *.g.dart` なし）:
```dart
// lib/features/<feature_name>/models/<feature_name>_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/app_exception.dart';

part '<feature_name>_state.freezed.dart';

@freezed
abstract class FeatureNameState with _$FeatureNameState {
  const factory FeatureNameState({
    @Default([]) List<FeatureNameItem> items,
    String? nextUrl,
    @Default(false) bool isLoadingMore,
    AppException? loadMoreError,
  }) = _FeatureNameState;
  // fromJson は書かない
}
```

コード生成: `fvm dart run build_runner build -d`

---

## Step 2: Repository 作成

具象クラスのみ（CLAUDE.md の No interfaces ルール参照）。

```dart
// lib/features/<feature_name>/repository/<feature_name>_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/pub_dev_api_client.dart';
import '../models/<feature_name>_response.dart';

part '<feature_name>_repository.g.dart';

class FeatureNameRepository {
  FeatureNameRepository(this._apiClient);
  final PubDevApiClient _apiClient;

  Future<FeatureNameResponse> getFeature({String? pageUrl}) async {
    final json = await _apiClient.getFeature(pageUrl: pageUrl);
    return FeatureNameResponse.fromJson(json);
  }
}

// Provider はファイル末尾に関数形式で定義
@riverpod
FeatureNameRepository featureNameRepository(Ref ref) {
  return FeatureNameRepository(ref.watch(pubDevApiClientProvider));
}
```

コード生成: `fvm dart run build_runner build -d`

---

## Step 3: Notifier 作成

詳細パターンは `/pubdev-state` スキルを参照。

```dart
// lib/features/<feature_name>/notifiers/<feature_name>_notifier.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/<feature_name>_state.dart';
import '../repository/<feature_name>_repository.dart';

part '<feature_name>_notifier.g.dart';

@riverpod
class FeatureNameNotifier extends _$FeatureNameNotifier {
  @override
  Future<FeatureNameState> build() async {
    final repository = ref.watch(featureNameRepositoryProvider); // build() 内は watch
    final response = await repository.getFeature();
    return FeatureNameState(items: response.items, nextUrl: response.nextUrl);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
```

コード生成: `fvm dart run build_runner build -d`

---

## Step 4: Screen 作成

```dart
// lib/features/<feature_name>/screens/<feature_name>_screen.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../notifiers/<feature_name>_notifier.dart';

class FeatureNameScreen extends HookConsumerWidget {
  const FeatureNameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(featureNameNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Feature')),
      body: asyncState.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(featureNameNotifierProvider),
        ),
        data: (state) => ListView.builder(
          padding: EdgeInsets.only(
            top: 8,
            bottom: 16 + MediaQuery.paddingOf(context).bottom,
          ),
          itemCount: state.items.length,
          itemBuilder: (context, index) =>
              _ItemTile(item: state.items[index]),
        ),
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({required this.item});
  final FeatureNameItem item;

  @override
  Widget build(BuildContext context) {
    // UI 実装
    return const SizedBox.shrink();
  }
}
```

UI トークンの使い方は `/pubdev-ui` スキルを参照。

### 文字列定数

画面に表示するラベル・エラーメッセージ等は `lib/core/strings/app_strings.dart` に定義する。
別画面で似た文言を重複定義しない（表記揺れ防止）。

- 新しい文言を追加する前に、既存の `AppStrings` に同じ意味の定数がないか確認する
- 変数名は文言の意味をそのまま使う（例: `retry`, `share`, `networkErrorTitle`）
  - `label` / `error` / `message` 等のプレフィックスは付けない

---

## Core Utils の活用

`lib/core/utils/` に汎用ユーティリティ関数がある。feature 内で同等の処理を再実装せず、既存の util を使う。

| ファイル | 関数 | 用途 |
|----------|------|------|
| `date_formatter.dart` | `formatDate(DateTime)` | `yyyy-MM-dd` 形式の日付表示 |
| `json_converters.dart` | `dateTimeFromIso8601` / `dateTimeToIso8601` | `@JsonKey` 用 ISO 8601 DateTime 変換 |
| `gradient_selector.dart` | `selectGradientByName(String)` | 文字列ハッシュによるアバターグラデーション選択 |
| `url_utils.dart` | `pubDevPackageUrl(String)` / `isHttpUrl(String?)` | pub.dev URL 構築・HTTP URL バリデーション |

```dart
import 'package:pubdev_viewer/core/utils/date_formatter.dart';
import 'package:pubdev_viewer/core/utils/json_converters.dart';
import 'package:pubdev_viewer/core/utils/gradient_selector.dart';
import 'package:pubdev_viewer/core/utils/url_utils.dart';
```

新しい汎用関数が必要な場合は `core/utils/` に追加する。feature 固有のヘルパーは feature 内に留める。

---

## Step 5: ルート登録

`lib/app/router.dart` に型安全ルートを追加:

```dart
@TypedGoRoute<FeatureNameRoute>(path: '/feature')
class FeatureNameRoute extends GoRouteData {
  const FeatureNameRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FeatureNameScreen();
}
```

コード生成: `fvm dart run build_runner build -d`

---

## Step 6: テスト作成

テストは `/pubdev-testing` スキルを参照。
`test/features/<feature_name>/` 配下に `lib/` と同じ階層構造でテストを配置。

---

## チェックリスト

- [ ] models/ に Response モデル（fromJson あり）と State モデル（fromJson なし）を作成
- [ ] repository/ に具象クラス + `@riverpod` 関数を作成（インターフェース不要）
- [ ] notifiers/ に `@riverpod class` を作成（build() で初期ロード）
- [ ] screens/ に `HookConsumerWidget` を作成
- [ ] router.dart にルート追加
- [ ] 各レイヤー追加後に `fvm dart run build_runner build -d` 実行
- [ ] `fvm dart analyze` でエラー 0 件確認
- [ ] `fvm flutter test` で既存テスト PASS 確認

