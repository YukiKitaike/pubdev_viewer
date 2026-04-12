import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:pubdev_viewer/core/models/pubspec.dart';

part 'package_list_version.freezed.dart';
part 'package_list_version.g.dart';

@freezed
abstract class PackageListVersion with _$PackageListVersion {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PackageListVersion({
    required String version,
    required Pubspec pubspec,
    required String archiveUrl,
    required String packageUrl,
    required String url,
  }) = _PackageListVersion;

  factory PackageListVersion.fromJson(
    Map<String, dynamic> json,
  ) => _$PackageListVersionFromJson(json);
}
