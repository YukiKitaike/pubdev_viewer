// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pubspec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Pubspec _$PubspecFromJson(Map<String, dynamic> json) => _Pubspec(
  name: json['name'] as String,
  version: json['version'] as String,
  description: json['description'] as String,
  homepage: json['homepage'] as String?,
  repository: json['repository'] as String?,
  issueTracker: json['issue_tracker'] as String?,
  topics: (json['topics'] as List<dynamic>?)?.map((e) => e as String).toList(),
  environment: (json['environment'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  dependencies: json['dependencies'] as Map<String, dynamic>?,
  devDependencies: json['dev_dependencies'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$PubspecToJson(_Pubspec instance) => <String, dynamic>{
  'name': instance.name,
  'version': instance.version,
  'description': instance.description,
  'homepage': instance.homepage,
  'repository': instance.repository,
  'issue_tracker': instance.issueTracker,
  'topics': instance.topics,
  'environment': instance.environment,
  'dependencies': instance.dependencies,
  'dev_dependencies': instance.devDependencies,
};
