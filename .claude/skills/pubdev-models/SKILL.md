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
snake_case → camelCase の一括変換には `@JsonSerializable(fieldRename: FieldRename.snake)` を使う。

```dart
// lib/features/package_list/models/package_list_response.dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package_list_item.dart';

part 'package_list_response.freezed.dart';
part 'package_list_response.g.dart';  // ← json_serializable が生成

@freezed
abstract class PackageListResponse with _$PackageListResponse {
  @JsonSerializable(fieldRename: FieldRename.snake) // snake_case 一括変換
  const factory PackageListResponse({
    String? nextUrl,                          // next_url → nextUrl に自動変換
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

## snake_case マッピング

API が返す snake_case キーを camelCase フィールドに変換するには、
ファクトリコンストラクタに `@JsonSerializable(fieldRename: FieldRename.snake)` を付けて一括変換する。

```dart
@freezed
abstract class PackageListVersion with _$PackageListVersion {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PackageListVersion({
    required String version,
    String? archiveUrl,    // archive_url → archiveUrl に自動変換
  }) = _PackageListVersion;

  factory PackageListVersion.fromJson(Map<String, dynamic> json) =>
      _$PackageListVersionFromJson(json);
}
```

## `@JsonKey` の使い方（例外ケースのみ）

`fieldRename: FieldRename.snake` で対応できない場合にのみ `@JsonKey` を使う:

```dart
// ✅ fieldRename では変換できない特殊なキー名
@JsonKey(name: 'pub_sub_topic') String? pubSubTopic,

// ✅ DateTime の変換（共有コンバーターを使う）
@JsonKey(fromJson: dateTimeFromIso8601, toJson: dateTimeToIso8601)
required DateTime published,

// ✅ API がフィールドを省略する可能性がある場合のデフォルト値
@JsonKey(defaultValue: <String>[]) List<String> topics,
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

// ❌ @JsonKey(name: 'next_url') を個別に書く（fieldRename で一括変換する）
@JsonKey(name: 'next_url') String? nextUrl,

// ❌ 不要な toJson を定義する（ローカル保存などで実際に必要になるまで書かない）
Map<String, dynamic> toJson() => _$MyModelToJson(this);
```

---

### WHY コメントの典型例

- カスタム `@JsonKey(fromJson: ...)` を使う理由（API の返却形式が想定と異なる等）
- `@JsonSerializable(fieldRename: FieldRename.snake)` を選んだ理由
