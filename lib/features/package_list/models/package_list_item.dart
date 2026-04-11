import 'package:freezed_annotation/freezed_annotation.dart';

import 'package_list_version.dart';

part 'package_list_item.freezed.dart';
part 'package_list_item.g.dart';

@freezed
abstract class PackageListItem with _$PackageListItem {
  const factory PackageListItem({
    required String name,
    required PackageListVersion latest,
  }) = _PackageListItem;

  factory PackageListItem.fromJson(
    Map<String, dynamic> json,
  ) => _$PackageListItemFromJson(json);
}
