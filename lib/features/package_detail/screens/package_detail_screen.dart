import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pubdev_viewer/core/design_system/design_system.dart';
import 'package:pubdev_viewer/core/strings/app_strings.dart';
import 'package:pubdev_viewer/core/utils/url_utils.dart';
import 'package:pubdev_viewer/core/widgets/error_view.dart';
import 'package:pubdev_viewer/core/widgets/loading_view.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_detail_response.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_publisher_response.dart';
import 'package:pubdev_viewer/features/package_detail/notifiers/package_detail_notifier.dart';
import 'package:pubdev_viewer/features/package_detail/screens/widgets/overview_section.dart';
import 'package:pubdev_viewer/features/package_detail/screens/widgets/versions_section.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PackageDetailScreen extends ConsumerWidget {
  const PackageDetailScreen({
    required this.packageName,
    super.key,
  });

  final String packageName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(
      packageDetailProvider(packageName),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(packageName),
        actions: [
          if (asyncState.value != null) ...[
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
          onRetry: () =>
              ref.read(packageDetailProvider(packageName).notifier).refresh(),
        ),
        data: (state) => RefreshIndicator(
          onRefresh: () => ref
              .read(
                packageDetailProvider(packageName).notifier,
              )
              .refresh(),
          child: SingleChildScrollView(
            // iOS は Bouncing、他は Clamping でプラットフォーム標準に合わせる。
            // Always を parent にし RefreshIndicator を常に有効にする。
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
                  versions: state.sortedVersions,
                ),
                Gap(
                  AppSpacing.lg + MediaQuery.paddingOf(context).bottom,
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

  static const _titleLetterSpacing = -0.5;
  static const _publisherIconSize = 13.0;

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
        crossAxisAlignment: .start,
        children: [
          Text(
            detail.name,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: .w700,
              letterSpacing: _titleLetterSpacing,
            ),
          ),
          const Gap(AppSpacing.sm),
          Text(
            detail.latest.version,
            style: GoogleFonts.jetBrainsMono(
              fontSize: AppTextSize.mono14,
              fontWeight: .w500,
              color: primary,
            ),
          ),
          if (publisher.publisherId != null) ...[
            const Gap(AppSpacing.md),
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    Icon(
                      Icons.verified_outlined,
                      size: _publisherIconSize,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                    const Gap(AppSpacing.xs),
                    Text(
                      publisher.publisherId!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                        fontWeight: .w500,
                      ),
                    ),
                  ],
                ),
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
      tooltip: AppStrings.share,
      onPressed: () {
        SharePlus.instance.share(
          ShareParams(uri: pubDevPackageUrl(packageName)),
        );
      },
    );
  }
}

class _ExternalLinkButton extends StatelessWidget {
  const _ExternalLinkButton({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (!isHttpUrl(url)) {
      return const SizedBox.shrink();
    }
    return IconButton(
      icon: const Icon(Icons.open_in_new),
      tooltip: AppStrings.openExternal,
      onPressed: () async {
        final success = await launchUrl(
          Uri.parse(url!),
          mode: .externalApplication,
        );
        if (!success && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.linkOpenFailed),
            ),
          );
        }
      },
    );
  }
}
