import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/pubspec.dart';

part 'package_detail_version.freezed.dart';
part 'package_detail_version.g.dart';

DateTime _publishedFromJson(String value) => DateTime.parse(value);
String _publishedToJson(DateTime value) => value.toIso8601String();

/// パッケージ詳細で使用するバージョン情報のデータクラス。
@freezed
abstract class PackageDetailVersion with _$PackageDetailVersion {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PackageDetailVersion({
    required String version,
    required Pubspec pubspec,
    required String archiveUrl,
    required String archiveSha256,
    @JsonKey(fromJson: _publishedFromJson, toJson: _publishedToJson)
    required DateTime published,
  }) = _PackageDetailVersion;

  factory PackageDetailVersion.fromJson(
    Map<String, dynamic> json,
  ) => _$PackageDetailVersionFromJson(json);
}
