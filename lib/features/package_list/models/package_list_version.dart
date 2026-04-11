import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/pubspec.dart';

part 'package_list_version.freezed.dart';
part 'package_list_version.g.dart';

@freezed
abstract class PackageListVersion with _$PackageListVersion {
  const factory PackageListVersion({
    required String version,
    required Pubspec pubspec,
    @JsonKey(name: 'archive_url') required String archiveUrl,
    @JsonKey(name: 'package_url') required String packageUrl,
    required String url,
  }) = _PackageListVersion;

  factory PackageListVersion.fromJson(
    Map<String, dynamic> json,
  ) => _$PackageListVersionFromJson(json);
}
