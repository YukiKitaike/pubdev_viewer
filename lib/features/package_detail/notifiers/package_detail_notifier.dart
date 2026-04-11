import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/package_detail_state.dart';
import '../repository/package_detail_repository.dart';

part 'package_detail_notifier.g.dart';

/// パッケージ詳細の状態管理を担当する Notifier。
///
/// 詳細情報とパブリッシャー情報を並列に取得する。
@riverpod
class PackageDetailNotifier extends _$PackageDetailNotifier {
  @override
  Future<PackageDetailState> build(String packageName) async {
    final repository = ref.watch(
      packageDetailRepositoryProvider,
    );
    final (detail, publisher) = await (
      repository.getPackageDetail(packageName),
      repository.getPackagePublisher(packageName),
    ).wait;
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
