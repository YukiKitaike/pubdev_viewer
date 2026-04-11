import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../models/package_detail_state.dart';
import '../notifiers/package_detail_notifier.dart';
import 'widgets/overview_section.dart';
import 'widgets/versions_section.dart';

class PackageDetailScreen extends HookConsumerWidget {
  const PackageDetailScreen({
    required this.packageName,
    super.key,
  });

  final String packageName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(
      packageDetailNotifierProvider(packageName),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(packageName),
        actions: [
          if (asyncState.valueOrNull != null) ...[
            _buildShareButton(asyncState.requireValue),
            _buildExternalLinkButton(
              asyncState.requireValue,
            ),
          ],
        ],
      ),
      body: asyncState.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(
            packageDetailNotifierProvider(packageName),
          ),
        ),
        data: (state) => RefreshIndicator(
          onRefresh: () => ref
              .read(
                packageDetailNotifierProvider(packageName).notifier,
              )
              .refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                OverviewSection(
                  detail: state.detail,
                  publisher: state.publisher,
                ),
                VersionsSection(
                  versions: state.detail.versions,
                ),
                const Gap(16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShareButton(PackageDetailState state) {
    return IconButton(
      icon: const Icon(Icons.share),
      onPressed: () => SharePlus.instance.share(
        ShareParams(
          uri: Uri.parse(
            'https://pub.dev/packages/${state.detail.name}',
          ),
        ),
      ),
    );
  }

  Widget _buildExternalLinkButton(
    PackageDetailState state,
  ) {
    final url =
        state.detail.latest.pubspec.homepage ??
        state.detail.latest.pubspec.repository;

    if (url == null || url.isEmpty) {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: const Icon(Icons.open_in_new),
      onPressed: () => launchUrl(Uri.parse(url)),
    );
  }
}
