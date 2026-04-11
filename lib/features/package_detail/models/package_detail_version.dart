import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/pubspec.dart';

part 'package_detail_version.freezed.dart';
part 'package_detail_version.g.dart';

@freezed
abstract class PackageDetailVersion with _$PackageDetailVersion {
  const factory PackageDetailVersion({
    required String version,
    required Pubspec pubspec,
    @JsonKey(name: 'archive_url') required String archiveUrl,
    @JsonKey(name: 'archive_sha256') required String archiveSha256,
    required String published,
  }) = _PackageDetailVersion;

  factory PackageDetailVersion.fromJson(
    Map<String, dynamic> json,
  ) => _$PackageDetailVersionFromJson(json);
}
