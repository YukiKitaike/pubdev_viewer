import 'package:freezed_annotation/freezed_annotation.dart';

import 'package_detail_response.dart';
import 'package_publisher_response.dart';

part 'package_detail_state.freezed.dart';

@freezed
abstract class PackageDetailState with _$PackageDetailState {
  const factory PackageDetailState({
    required PackageDetailResponse detail,
    required PackagePublisherResponse publisher,
  }) = _PackageDetailState;
}
