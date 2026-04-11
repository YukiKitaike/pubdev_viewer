import 'package:freezed_annotation/freezed_annotation.dart';

import 'package_list_item.dart';

part 'package_list_state.freezed.dart';

/// パッケージ一覧画面の UI 状態を表すデータクラス。
@freezed
abstract class PackageListState with _$PackageListState {
  const factory PackageListState({
    @Default([]) List<PackageListItem> packages,
    String? nextUrl,
    @Default(false) bool isLoadingMore,
    Object? loadMoreError,
  }) = _PackageListState;
}
