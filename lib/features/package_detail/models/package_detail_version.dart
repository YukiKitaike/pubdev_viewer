import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:pubdev_viewer/core/models/pubspec.dart';
import 'package:pubdev_viewer/core/utils/json_converters.dart';

part 'package_detail_version.freezed.dart';
part 'package_detail_version.g.dart';

@freezed
abstract class PackageDetailVersion with _$PackageDetailVersion {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PackageDetailVersion({
    required String version,
    required Pubspec pubspec,
    required String archiveUrl,
    required String archiveSha256,
    @JsonKey(fromJson: dateTimeFromIso8601, toJson: dateTimeToIso8601)
    required DateTime published,
  }) = _PackageDetailVersion;

  factory PackageDetailVersion.fromJson(
    Map<String, dynamic> json,
  ) => _$PackageDetailVersionFromJson(json);
}
