import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pubdev_viewer/app/theme_mode_notifier.dart';
import 'package:pubdev_viewer/core/design_system/design_system.dart';
import 'package:pubdev_viewer/core/strings/app_strings.dart';
import 'package:pubdev_viewer/core/widgets/error_view.dart';
import 'package:pubdev_viewer/core/widgets/skeleton_list_view.dart';
import 'package:pubdev_viewer/features/package_list/notifiers/package_list_notifier.dart';
import 'package:pubdev_viewer/features/package_list/screens/widgets/package_list_tile.dart';

class PackageListScreen extends HookConsumerWidget {
  const PackageListScreen({super.key});

  static const _loadMoreThreshold = 200.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(packageListProvider);
    final scrollController = useScrollController();

    useEffect(
      () {
        void onScroll() {
          // 底辺 200px 手前で発火。スクロール慣性で底に達する前にロード開始し待ち時間を感じさせない。
          if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - _loadMoreThreshold) {
            ref.read(packageListProvider.notifier).loadMore();
          }
        }

        scrollController.addListener(onScroll);
        return () => scrollController.removeListener(onScroll);
      },
      [scrollController],
    );

    // loadMoreError は state に一時保持 → SnackBar 表示 → 即クリア。
    // クリアしないと再構築のたびに再表示される。
    ref.listen(
      packageListProvider,
      (_, next) {
        final error = next.value?.loadMoreError;
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.loadMoreFailed),
            ),
          );
          ref.read(packageListProvider.notifier).clearLoadMoreError();
        }
      },
    );

    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        // RichText は TextSpan 単位で読み上げられるため、統合した label を親に
        // 与え、配下のスパンはセマンティクスから除外する。
        title: Semantics(
          label: AppStrings.appTitle,
          header: true,
          child: ExcludeSemantics(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.titleLarge,
                children: [
                  TextSpan(
                    text: AppStrings.appTitlePub,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: .w700,
                    ),
                  ),
                  const TextSpan(
                    text: AppStrings.appTitleDotDev,
                    style: TextStyle(fontWeight: .w700),
                  ),
                  TextSpan(
                    text: AppStrings.appTitleViewer,
                    style: TextStyle(
                      fontWeight: .w400,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              switch (themeMode) {
                .dark => Icons.light_mode_outlined,
                _ => Icons.dark_mode_outlined,
              },
            ),
            tooltip: switch (themeMode) {
              .dark => AppStrings.lightMode,
              _ => AppStrings.darkMode,
            },
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
          ),
        ],
      ),
      body: asyncState.when(
        loading: () => const SkeletonListView(),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.read(packageListProvider.notifier).refresh(),
        ),
        data: (state) => RefreshIndicator(
          onRefresh: () => ref.read(packageListProvider.notifier).refresh(),
          child: ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppSpacing.sm,
              bottom: AppSpacing.lg + MediaQuery.paddingOf(context).bottom,
            ),
            itemCount: state.packages.length + (state.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.packages.length) {
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Center(
                    // ページネーション時の追加ロード中であることを読み上げる。
                    child: Semantics(
                      label: AppStrings.loadingMore,
                      container: true,
                      child: const CircularProgressIndicator.adaptive(),
                    ),
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
