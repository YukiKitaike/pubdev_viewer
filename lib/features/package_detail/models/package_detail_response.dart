import 'package:freezed_annotation/freezed_annotation.dart';

import 'package_detail_version.dart';

part 'package_detail_response.freezed.dart';
part 'package_detail_response.g.dart';

/// パッケージ詳細 API のレスポンスモデル。
@freezed
abstract class PackageDetailResponse with _$PackageDetailResponse {
  const factory PackageDetailResponse({
    required String name,
    required PackageDetailVersion latest,
    required List<PackageDetailVersion> versions,
    String? advisoriesUpdated,
  }) = _PackageDetailResponse;

  factory PackageDetailResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$PackageDetailResponseFromJson(json);
}
