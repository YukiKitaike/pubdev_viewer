import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/package_detail_state.dart';
import '../repository/package_detail_repository.dart';

part 'package_detail_notifier.g.dart';

@riverpod
class PackageDetailNotifier extends _$PackageDetailNotifier {
  @override
  Future<PackageDetailState> build(String packageName) async {
    final repository = ref.watch(
      packageDetailRepositoryProvider,
    );
    // detail と publisher は独立した API。Records + .wait で並列取得し応答時間を短縮する。
    final (detail, publisher) = await (
      repository.getPackageDetail(packageName),
      repository.getPackagePublisher(packageName),
    ).wait;
    // バージョンを build() 内で一度だけソート。リビルドごとの再計算を避けるため state に保持する。
    final sortedVersions = [...detail.versions]
      ..sort((a, b) => b.published.compareTo(a.published));
    return PackageDetailState(
      detail: detail,
      publisher: publisher,
      sortedVersions: sortedVersions,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
