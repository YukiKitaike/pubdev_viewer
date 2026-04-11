import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../notifiers/package_list_notifier.dart';
import 'widgets/package_list_tile.dart';

class PackageListScreen extends HookConsumerWidget {
  const PackageListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(
      packageListNotifierProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('pub.dev Viewer'),
      ),
      body: asyncState.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(
            packageListNotifierProvider,
          ),
        ),
        data: (state) => RefreshIndicator(
          onRefresh: () => ref
              .read(
                packageListNotifierProvider.notifier,
              )
              .refresh(),
          child: ListView.builder(
            itemCount: state.packages.length +
                (state.nextUrl != null ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.packages.length) {
                SchedulerBinding.instance
                    .addPostFrameCallback((_) {
                  ref
                      .read(
                        packageListNotifierProvider
                            .notifier,
                      )
                      .loadMore();
                });
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child:
                        CircularProgressIndicator(),
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
