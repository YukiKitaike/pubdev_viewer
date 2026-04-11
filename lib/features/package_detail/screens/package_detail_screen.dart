import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../models/package_detail_response.dart';
import '../models/package_publisher_response.dart';
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
                _PackageHeroHeader(
                  detail: state.detail,
                  publisher: state.publisher,
                ),
                OverviewSection(
                  detail: state.detail,
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

class _PackageHeroHeader extends StatelessWidget {
  const _PackageHeroHeader({
    required this.detail,
    required this.publisher,
  });

  final PackageDetailResponse detail;
  final PackagePublisherResponse publisher;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final isLight = theme.brightness == Brightness.light;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primary.withValues(alpha: 0.08),
            primary.withValues(alpha: 0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(
          bottom: BorderSide(
            color: isLight ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            detail.name,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const Gap(8),
          Text(
            detail.latest.version,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: primary,
            ),
          ),
          if (publisher.publisherId != null) ...[
            const Gap(12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_outlined,
                    size: 13,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    publisher.publisherId!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
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
    final parsed = url != null && url!.isNotEmpty ? Uri.tryParse(url!) : null;
    if (parsed == null ||
        (parsed.scheme != 'https' && parsed.scheme != 'http')) {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: const Icon(Icons.open_in_new),
      tooltip: '外部サイトで開く',
      onPressed: () => launchUrl(parsed),
    );
  }
}
