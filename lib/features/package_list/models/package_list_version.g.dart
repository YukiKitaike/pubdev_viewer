// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_list_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PackageListVersion _$PackageListVersionFromJson(Map<String, dynamic> json) =>
    _PackageListVersion(
      version: json['version'] as String,
      pubspec: Pubspec.fromJson(json['pubspec'] as Map<String, dynamic>),
      archiveUrl: json['archive_url'] as String,
      packageUrl: json['package_url'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$PackageListVersionToJson(_PackageListVersion instance) =>
    <String, dynamic>{
      'version': instance.version,
      'pubspec': instance.pubspec,
      'archive_url': instance.archiveUrl,
      'package_url': instance.packageUrl,
      'url': instance.url,
    };
