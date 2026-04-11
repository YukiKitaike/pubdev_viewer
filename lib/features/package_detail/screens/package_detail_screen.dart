import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/design_system/design_system.dart';
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
class PackageDetailScreen extends ConsumerWidget {
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
          onRetry: () => ref
              .read(packageDetailNotifierProvider(packageName).notifier)
              .refresh(),
        ),
        data: (state) => RefreshIndicator(
          onRefresh: () => ref
              .read(
                packageDetailNotifierProvider(packageName).notifier,
              )
              .refresh(),
          child: SingleChildScrollView(
            physics: switch (Theme.of(context).platform) {
              .iOS => const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              _ => const ClampingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
            },
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
                  versions: [...state.detail.versions]
                    ..sort((a, b) => b.published.compareTo(a.published)),
                ),
                SizedBox(
                  height: AppSpacing.lg + MediaQuery.paddingOf(context).bottom,
                ),
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
    final tokens = context.tokens;

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
          bottom: BorderSide(color: tokens.border),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xxl,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
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
          const Gap(AppSpacing.sm),
          Text(
            detail.latest.version,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: primary,
            ),
          ),
          if (publisher.publisherId != null) ...[
            const Gap(AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_outlined,
                    size: 13,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                  const Gap(AppSpacing.xs),
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
      onPressed: () {
        final uri = Uri.tryParse('https://pub.dev/packages/$packageName');
        if (uri == null) {
          return;
        }
        SharePlus.instance.share(ShareParams(uri: uri));
      },
    );
  }
}

class _ExternalLinkButton extends StatelessWidget {
  const _ExternalLinkButton({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url case final String u when u.isNotEmpty) {
      final parsed = Uri.tryParse(u);
      // http も許可: 古い pubspec.yaml では homepage が http:// で登録されている場合がある。
      if (parsed != null &&
          (parsed.scheme == 'https' || parsed.scheme == 'http')) {
        return IconButton(
          icon: const Icon(Icons.open_in_new),
          tooltip: '外部サイトで開く',
          onPressed: () async {
            final success = await launchUrl(
              parsed,
              mode: LaunchMode.externalApplication,
            );
            if (!success && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('リンクを開けませんでした')),
              );
            }
          },
        );
      }
    }
    return const SizedBox.shrink();
  }
}
