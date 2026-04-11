import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/package_list_state.dart';
import '../repository/package_list_repository.dart';

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
    } on Exception catch (e, st) {
      state = AsyncData(
        current.copyWith(isLoadingMore: false),
      );
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
