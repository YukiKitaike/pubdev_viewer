import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../notifiers/package_list_notifier.dart';
import 'widgets/package_list_tile.dart';

/// パッケージ一覧画面。
///
/// pub.dev API からパッケージ一覧を取得し、無限スクロールで表示する。
class PackageListScreen extends HookConsumerWidget {
  const PackageListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(packageListNotifierProvider);
    final scrollController = useScrollController();

    useEffect(
      () {
        void onScroll() {
          if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200) {
            ref.read(packageListNotifierProvider.notifier).loadMore();
          }
        }

        scrollController.addListener(onScroll);
        return () => scrollController.removeListener(onScroll);
      },
      [scrollController],
    );

    ref.listen(
      packageListNotifierProvider,
      (previous, next) {
        final error = next.valueOrNull?.loadMoreError;
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('追加読み込みに失敗しました'),
            ),
          );
          ref.read(packageListNotifierProvider.notifier).clearLoadMoreError();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('pub.dev Viewer'),
      ),
      body: asyncState.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(packageListNotifierProvider),
        ),
        data: (state) => RefreshIndicator(
          onRefresh: () =>
              ref.read(packageListNotifierProvider.notifier).refresh(),
          child: ListView.builder(
            controller: scrollController,
            itemCount: state.packages.length + (state.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.packages.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return PackageListTile(
                package: state.packages[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
