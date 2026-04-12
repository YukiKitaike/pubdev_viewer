import 'package:freezed_annotation/freezed_annotation.dart';

import 'package_list_item.dart';

part 'package_list_response.freezed.dart';
part 'package_list_response.g.dart';

/// パッケージ一覧 API のレスポンスモデル。
@freezed
abstract class PackageListResponse with _$PackageListResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PackageListResponse({
    String? nextUrl,
    required List<PackageListItem> packages,
  }) = _PackageListResponse;

  factory PackageListResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$PackageListResponseFromJson(json);
}
