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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(packageListNotifierProvider);
    final scrollController = useScrollController();

    useEffect(
      () {
        void onScroll() {
          // 底辺 200px 手前で発火。スクロール慣性で底に達する前にロード開始し待ち時間を感じさせない。
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

    // loadMoreError は state に一時保持 → SnackBar 表示 → 即クリア。
    // クリアしないと再構築のたびに再表示される。
    ref.listen(
      packageListNotifierProvider,
      (_, next) {
        final error = next.valueOrNull?.loadMoreError;
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.loadMoreFailed),
            ),
          );
          ref.read(packageListNotifierProvider.notifier).clearLoadMoreError();
        }
      },
    );

    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: theme.textTheme.titleLarge,
            children: [
              TextSpan(
                text: AppStrings.appTitlePub,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const TextSpan(
                text: AppStrings.appTitleDotDev,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              TextSpan(
                text: AppStrings.appTitleViewer,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
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
            onPressed: () =>
                ref.read(themeModeNotifierProvider.notifier).toggle(),
          ),
        ],
      ),
      body: asyncState.when(
        loading: () => const SkeletonListView(),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () =>
              ref.read(packageListNotifierProvider.notifier).refresh(),
        ),
        data: (state) => RefreshIndicator(
          onRefresh: () =>
              ref.read(packageListNotifierProvider.notifier).refresh(),
          child: ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppSpacing.sm,
              bottom: AppSpacing.lg + MediaQuery.paddingOf(context).bottom,
            ),
            itemCount: state.packages.length + (state.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.packages.length) {
                return const Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
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
