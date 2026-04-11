// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$packageDetailNotifierHash() =>
    r'0a3422a94ecacf117f9feb33e51832fee6f0b5de';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$PackageDetailNotifier
    extends BuildlessAutoDisposeAsyncNotifier<PackageDetailState> {
  late final String packageName;

  FutureOr<PackageDetailState> build(String packageName);
}

/// パッケージ詳細の状態管理を担当する Notifier。
///
/// 詳細情報とパブリッシャー情報を並列に取得する。
///
/// Copied from [PackageDetailNotifier].
@ProviderFor(PackageDetailNotifier)
const packageDetailNotifierProvider = PackageDetailNotifierFamily();

/// パッケージ詳細の状態管理を担当する Notifier。
///
/// 詳細情報とパブリッシャー情報を並列に取得する。
///
/// Copied from [PackageDetailNotifier].
class PackageDetailNotifierFamily
    extends Family<AsyncValue<PackageDetailState>> {
  /// パッケージ詳細の状態管理を担当する Notifier。
  ///
  /// 詳細情報とパブリッシャー情報を並列に取得する。
  ///
  /// Copied from [PackageDetailNotifier].
  const PackageDetailNotifierFamily();

  /// パッケージ詳細の状態管理を担当する Notifier。
  ///
  /// 詳細情報とパブリッシャー情報を並列に取得する。
  ///
  /// Copied from [PackageDetailNotifier].
  PackageDetailNotifierProvider call(String packageName) {
    return PackageDetailNotifierProvider(packageName);
  }

  @override
  PackageDetailNotifierProvider getProviderOverride(
    covariant PackageDetailNotifierProvider provider,
  ) {
    return call(provider.packageName);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'packageDetailNotifierProvider';
}

/// パッケージ詳細の状態管理を担当する Notifier。
///
/// 詳細情報とパブリッシャー情報を並列に取得する。
///
/// Copied from [PackageDetailNotifier].
class PackageDetailNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          PackageDetailNotifier,
          PackageDetailState
        > {
  /// パッケージ詳細の状態管理を担当する Notifier。
  ///
  /// 詳細情報とパブリッシャー情報を並列に取得する。
  ///
  /// Copied from [PackageDetailNotifier].
  PackageDetailNotifierProvider(String packageName)
    : this._internal(
        () => PackageDetailNotifier()..packageName = packageName,
        from: packageDetailNotifierProvider,
        name: r'packageDetailNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$packageDetailNotifierHash,
        dependencies: PackageDetailNotifierFamily._dependencies,
        allTransitiveDependencies:
            PackageDetailNotifierFamily._allTransitiveDependencies,
        packageName: packageName,
      );

  PackageDetailNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.packageName,
  }) : super.internal();

  final String packageName;

  @override
  FutureOr<PackageDetailState> runNotifierBuild(
    covariant PackageDetailNotifier notifier,
  ) {
    return notifier.build(packageName);
  }

  @override
  Override overrideWith(PackageDetailNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: PackageDetailNotifierProvider._internal(
        () => create()..packageName = packageName,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        packageName: packageName,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    PackageDetailNotifier,
    PackageDetailState
  >
  createElement() {
    return _PackageDetailNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PackageDetailNotifierProvider &&
        other.packageName == packageName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, packageName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PackageDetailNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<PackageDetailState> {
  /// The parameter `packageName` of this provider.
  String get packageName;
}

class _PackageDetailNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          PackageDetailNotifier,
          PackageDetailState
        >
    with PackageDetailNotifierRef {
  _PackageDetailNotifierProviderElement(super.provider);

  @override
  String get packageName =>
      (origin as PackageDetailNotifierProvider).packageName;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
