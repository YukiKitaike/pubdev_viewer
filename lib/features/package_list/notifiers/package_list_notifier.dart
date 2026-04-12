import 'package:pubdev_viewer/core/error/app_exception.dart';
import 'package:pubdev_viewer/features/package_list/models/package_list_state.dart';
import 'package:pubdev_viewer/features/package_list/repository/package_list_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'package_list_notifier.g.dart';

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

    // エラー時も既存一覧を保持するため AsyncData 内で isLoadingMore を管理する。
    // AsyncError にすると一覧データが消え画面全体がエラー表示になる。
    state = AsyncData(
      current.copyWith(isLoadingMore: true),
    );

    try {
      // build() 以外では ref.read。watch にすると loadMore 中にリポジトリが再生成され途中結果が消える。
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
      final error = e is AppException ? e : NetworkException(e.toString());
      state = AsyncData(
        current.copyWith(isLoadingMore: false, loadMoreError: error),
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
