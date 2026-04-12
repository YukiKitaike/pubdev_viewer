---
name: pubdev-models
description: >
  pubdev_viewer の Freezed + json_serializable モデルパターン。
  データモデル・APIレスポンスクラス・UIステートクラスを作成・編集する際に使用。
  このアプリで使われている具体的な規約とコード例を提供する。
---

# Model パターン（pubdev_viewer）

## 2 種類のモデル

| 種別 | 用途 | fromJson | `*.g.dart` |
|------|------|----------|------------|
| **API Response モデル** | API レスポンスを Dart クラスにマッピング | ✅ あり | ✅ あり |
| **State モデル** | UI の状態を表現（ページネーション情報など） | ❌ なし | ❌ なし |

Entity クラスや Domain クラスを別に作らない。API の形状と UI の必要が実際に異なる場合のみ変換クラスを作る。

---

## API Response モデル

`part *.g.dart` を含む。`fromJson` ファクトリを定義する。

```dart
// lib/features/package_list/models/package_list_response.dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package_list_item.dart';

part 'package_list_response.freezed.dart';
part 'package_list_response.g.dart';  // ← json_serializable が生成

@freezed
abstract class PackageListResponse with _$PackageListResponse {
  const factory PackageListResponse({
    @JsonKey(name: 'next_url') String? nextUrl,  // snake_case → camelCase
    required List<PackageListItem> packages,
  }) = _PackageListResponse;

  factory PackageListResponse.fromJson(Map<String, dynamic> json) =>
      _$PackageListResponseFromJson(json);
}
```

実際のファイル: [lib/features/package_list/models/package_list_response.dart](lib/features/package_list/models/package_list_response.dart)

---

## State モデル

`part *.g.dart` は不要。`fromJson` は書かない。

```dart
// lib/features/package_list/models/package_list_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/app_exception.dart';
import 'package_list_item.dart';

part 'package_list_state.freezed.dart';  // ← .g.dart は不要

@freezed
abstract class PackageListState with _$PackageListState {
  const factory PackageListState({
    @Default([]) List<PackageListItem> packages,
    String? nextUrl,
    @Default(false) bool isLoadingMore,
    AppException? loadMoreError,
  }) = _PackageListState;
  // fromJson は書かない
}
```

実際のファイル: [lib/features/package_list/models/package_list_state.dart](lib/features/package_list/models/package_list_state.dart)

---

## `@JsonKey` の使い方

JSON キーが Dart フィールド名と異なる場合のみ使用する。

```dart
@JsonKey(name: 'published_at') DateTime? publishedAt,  // ✅ 必要な場合のみ
String? version,                                        // ✅ 同名なら不要
```

### DateTime フィールドの JSON 変換

pub.dev API は DateTime を ISO 8601 文字列で返す。`core/utils/json_converters.dart` の共有コンバーターを使う:

```dart
import 'package:pubdev_viewer/core/utils/json_converters.dart';

@JsonKey(fromJson: dateTimeFromIso8601, toJson: dateTimeToIso8601)
required DateTime published,
```

feature 内に private コンバーター (`_publishedFromJson` 等) を作らない。

---

## ネストしたモデル

ネストしたオブジェクトも同様に `@freezed` で定義する。

```dart
// lib/features/package_list/models/package_list_item.dart
@freezed
abstract class PackageListItem with _$PackageListItem {
  const factory PackageListItem({
    required String name,
    required PackageListVersion latest,  // ネストした freezed クラス
  }) = _PackageListItem;

  factory PackageListItem.fromJson(Map<String, dynamic> json) =>
      _$PackageListItemFromJson(json);
}
```

---

## 共有モデルの昇格タイミング

- feature 固有モデルは最初から `core/models/` に置かない
- **2 つ以上の feature で共有される時点で昇格させる**
- 例: `Pubspec` → `lib/core/models/pubspec.dart`（package_list と package_detail の両方で使用）

---

## コード生成コマンド

モデルを作成・変更したら必ず実行:

```bash
fvm dart run build_runner build -d
```

生成されるファイル（手動編集禁止）:
- `<model>.freezed.dart` — `copyWith`・`==`・`toString` 等
- `<model>.g.dart` — `fromJson`・`toJson`（Response モデルのみ）

---

## よくある間違い

```dart
// ❌ State モデルに fromJson を書く
factory PackageListState.fromJson(Map<String, dynamic> json) => ...

// ❌ @JsonSerializable を直接使う（@freezed が内部で呼ぶので不要）
@JsonSerializable()
class MyModel { ... }

// ❌ 不要な toJson を定義する（ローカル保存などで実際に必要になるまで書かない）
Map<String, dynamic> toJson() => _$MyModelToJson(this);
```

---

### WHY コメントの典型例

- カスタム `@JsonKey(fromJson: ...)` を使う理由（API の返却形式が想定と異なる等）
- `@JsonSerializable(fieldRename: FieldRename.snake)` を選んだ理由
