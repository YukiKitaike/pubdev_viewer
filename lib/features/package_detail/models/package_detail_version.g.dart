// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_detail_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PackageDetailVersion _$PackageDetailVersionFromJson(
  Map<String, dynamic> json,
) => _PackageDetailVersion(
  version: json['version'] as String,
  pubspec: Pubspec.fromJson(json['pubspec'] as Map<String, dynamic>),
  archiveUrl: json['archive_url'] as String,
  archiveSha256: json['archive_sha256'] as String,
  published: _publishedFromJson(json['published'] as String),
);

Map<String, dynamic> _$PackageDetailVersionToJson(
  _PackageDetailVersion instance,
) => <String, dynamic>{
  'version': instance.version,
  'pubspec': instance.pubspec,
  'archive_url': instance.archiveUrl,
  'archive_sha256': instance.archiveSha256,
  'published': _publishedToJson(instance.published),
};
