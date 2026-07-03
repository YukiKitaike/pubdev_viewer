---
name: pubdev-models
description: >
  pubdev_viewer の Freezed + json_serializable モデル定義パターンを提供する。
  API Response モデル（fromJson あり）と State モデル（fromJson なし）の
  クラス構造・@JsonKey・DateTime コンバーター・core/models/ 昇格基準を扱う。
  「モデルを作って」「Freezed」「fromJson」「JsonKey」と言われたときに参照。
  State を扱う Notifier 側の実装（loadMore 等）は /pubdev-state が扱う。
---

# Model パターン（pubdev_viewer）

## 2 種類のモデル

| 種別 | 用途 | fromJson | `*.g.dart` |
|------|------|----------|------------|
| **API Response モデル** | API レスポンスを Dart クラスにマッピング | あり | あり |
| **State モデル** | UI の状態を表現（ページネーション情報など） | なし | なし |

Entity クラスや Domain クラスを別に作らない。API の形状と UI の必要が実際に異なる場合のみ変換クラスを作る。

---

## API Response モデル テンプレート

snake_case → camelCase の一括変換には `@JsonSerializable(fieldRename: FieldRename.snake)` を使う。

```dart
// lib/features/<feature>/models/<name>_response.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '<name>_response.freezed.dart';
part '<name>_response.g.dart';

@freezed
abstract class NameResponse with _$NameResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory NameResponse({
    required String fieldName,     // field_name → fieldName に自動変換
    String? optionalField,
  }) = _NameResponse;

  factory NameResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$NameResponseFromJson(json);
}
```

実例: `lib/features/package_list/models/package_list_response.dart`, `lib/features/package_detail/models/package_detail_version.dart`

---

## State モデル テンプレート

`part *.g.dart` は不要。`fromJson` は書かない。

```dart
// lib/features/<feature>/models/<name>_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:pubdev_viewer/core/error/app_exception.dart';

part '<name>_state.freezed.dart';

@freezed
abstract class NameState with _$NameState {
  const factory NameState({
    @Default([]) List<Item> items,
    @Default(false) bool isLoadingMore,
    AppException? loadMoreError,
  }) = _NameState;
}
```

実例: `lib/features/package_list/models/package_list_state.dart`, `lib/features/package_detail/models/package_detail_state.dart`

---

## `@JsonKey` の使い方

`fieldRename: FieldRename.snake` で対応できない例外ケースのみ `@JsonKey` を使う:

```dart
// DateTime の変換（共有コンバーターを使う）
import 'package:pubdev_viewer/core/utils/json_converters.dart';

@JsonKey(fromJson: dateTimeFromIso8601, toJson: dateTimeToIso8601)
required DateTime published,

// API がフィールドを省略する可能性がある場合のデフォルト値
@JsonKey(defaultValue: <String>[]) List<String> topics,
```

DateTime コンバーターは `lib/core/utils/json_converters.dart` に定義済み。feature 内に private コンバーター (`_publishedFromJson` 等) を作らない。

---

## 共有モデルの昇格タイミング

昇格基準は CLAUDE.md Critical Rules の「No premature core promotion」が定義本体。
実例: `Pubspec` → `lib/core/models/pubspec.dart`（package_list と package_detail の両方で使用された時点で昇格）

---

## よくある間違い

```dart
// ❌ State モデルに fromJson を書く（不要）
factory PackageListState.fromJson(Map<String, dynamic> json) => ...

// ❌ @JsonKey(name: 'next_url') を個別に書く（fieldRename で一括変換する）
@JsonKey(name: 'next_url') String? nextUrl,

// ❌ 相対 import を使う
import '../../../core/error/app_exception.dart';
// ✅ 絶対 import を使う
import 'package:pubdev_viewer/core/error/app_exception.dart';

// ❌ 不要な toJson を定義する（実際に必要になるまで書かない）
Map<String, dynamic> toJson() => _$MyModelToJson(this);
```
