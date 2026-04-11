// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PackageListResponse _$PackageListResponseFromJson(Map<String, dynamic> json) =>
    _PackageListResponse(
      nextUrl: json['next_url'] as String?,
      packages: (json['packages'] as List<dynamic>)
          .map((e) => PackageListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PackageListResponseToJson(
  _PackageListResponse instance,
) => <String, dynamic>{
  'next_url': instance.nextUrl,
  'packages': instance.packages,
};
