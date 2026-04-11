import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../notifiers/package_detail_notifier.dart';
import 'widgets/overview_section.dart';
import 'widgets/versions_section.dart';

/// パッケージ詳細画面。
///
/// パッケージの概要、バージョン一覧、パブリッシャー情報を表示する。
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
            _ShareButton(packageName: asyncState.requireValue.detail.name),
            _ExternalLinkButton(
              url:
                  asyncState.requireValue.detail.latest.pubspec.homepage ??
                  asyncState.requireValue.detail.latest.pubspec.repository,
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
}

class _ShareButton extends StatelessWidget {
  const _ShareButton({required this.packageName});

  final String packageName;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.share),
      tooltip: '共有',
      onPressed: () => SharePlus.instance.share(
        ShareParams(
          uri: Uri.parse('https://pub.dev/packages/$packageName'),
        ),
      ),
    );
  }
}

class _ExternalLinkButton extends StatelessWidget {
  const _ExternalLinkButton({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: const Icon(Icons.open_in_new),
      tooltip: '外部サイトで開く',
      onPressed: () => launchUrl(Uri.parse(url!)),
    );
  }
}
