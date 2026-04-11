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
    final (detail, publisher) = await (
      repository.getPackageDetail(packageName),
      repository.getPackagePublisher(packageName),
    ).wait;
    return PackageDetailState(
      detail: detail,
      publisher: publisher,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
