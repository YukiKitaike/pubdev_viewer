import 'package:freezed_annotation/freezed_annotation.dart';

part 'package_publisher_response.freezed.dart';
part 'package_publisher_response.g.dart';

/// パッケージパブリッシャー API のレスポンスモデル。
@freezed
abstract class PackagePublisherResponse with _$PackagePublisherResponse {
  const factory PackagePublisherResponse({
    String? publisherId,
  }) = _PackagePublisherResponse;

  factory PackagePublisherResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$PackagePublisherResponseFromJson(json);
}
