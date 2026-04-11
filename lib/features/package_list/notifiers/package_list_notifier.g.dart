// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$packageListNotifierHash() =>
    r'167cdd76fd8a5f168d5963715b19839ad22b481e';

/// パッケージ一覧の状態管理を担当する Notifier。
///
/// 初回読み込み、ページネーション、リフレッシュを管理する。
///
/// Copied from [PackageListNotifier].
@ProviderFor(PackageListNotifier)
final packageListNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      PackageListNotifier,
      PackageListState
    >.internal(
      PackageListNotifier.new,
      name: r'packageListNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$packageListNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PackageListNotifier = AutoDisposeAsyncNotifier<PackageListState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
