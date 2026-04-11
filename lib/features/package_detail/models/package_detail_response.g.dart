// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PackageDetailResponse _$PackageDetailResponseFromJson(
  Map<String, dynamic> json,
) => _PackageDetailResponse(
  name: json['name'] as String,
  latest: PackageDetailVersion.fromJson(json['latest'] as Map<String, dynamic>),
  versions: (json['versions'] as List<dynamic>)
      .map((e) => PackageDetailVersion.fromJson(e as Map<String, dynamic>))
      .toList(),
  advisoriesUpdated: json['advisoriesUpdated'] as String?,
);

Map<String, dynamic> _$PackageDetailResponseToJson(
  _PackageDetailResponse instance,
) => <String, dynamic>{
  'name': instance.name,
  'latest': instance.latest,
  'versions': instance.versions,
  'advisoriesUpdated': instance.advisoriesUpdated,
};
