import 'package:freezed_annotation/freezed_annotation.dart';

import 'package_detail_response.dart';
import 'package_detail_version.dart';
import 'package_publisher_response.dart';

part 'package_detail_state.freezed.dart';

/// パッケージ詳細画面の UI 状態を表すデータクラス。
@freezed
abstract class PackageDetailState with _$PackageDetailState {
  const factory PackageDetailState({
    required PackageDetailResponse detail,
    required PackagePublisherResponse publisher,

    /// 公開日の降順でソート済みのバージョンリスト。
    /// Notifier の build() で一度だけソートし、リビルドごとの再計算を避ける。
    required List<PackageDetailVersion> sortedVersions,
  }) = _PackageDetailState;
}
