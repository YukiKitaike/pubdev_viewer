// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PackageListItem _$PackageListItemFromJson(Map<String, dynamic> json) =>
    _PackageListItem(
      name: json['name'] as String,
      latest: PackageListVersion.fromJson(
        json['latest'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$PackageListItemToJson(_PackageListItem instance) =>
    <String, dynamic>{'name': instance.name, 'latest': instance.latest};
