import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/package_list_state.dart';
import '../repository/package_list_repository.dart';

part 'package_list_notifier.g.dart';

/// パッケージ一覧の状態管理を担当する Notifier。
///
/// 初回読み込み、ページネーション、リフレッシュを管理する。
@riverpod
class PackageListNotifier extends _$PackageListNotifier {
  @override
  Future<PackageListState> build() async {
    final repository = ref.watch(packageListRepositoryProvider);
    final response = await repository.getPackages();
    return PackageListState(
      packages: response.packages,
      nextUrl: response.nextUrl,
    );
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore || current.nextUrl == null) {
      return;
    }

    state = AsyncData(
      current.copyWith(isLoadingMore: true),
    );

    try {
      final repository = ref.read(
        packageListRepositoryProvider,
      );
      final response = await repository.getPackages(
        pageUrl: current.nextUrl,
      );
      state = AsyncData(
        PackageListState(
          packages: [
            ...current.packages,
            ...response.packages,
          ],
          nextUrl: response.nextUrl,
        ),
      );
    } on Object catch (e) {
      // Exception でない Error（StateError 等）も含めてキャッチする
      state = AsyncData(
        current.copyWith(isLoadingMore: false, loadMoreError: e),
      );
    }
  }

  void clearLoadMoreError() {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    state = AsyncData(current.copyWith(loadMoreError: null));
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
