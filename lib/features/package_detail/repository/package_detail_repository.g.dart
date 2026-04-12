// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_detail_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(packageDetailRepository)
final packageDetailRepositoryProvider = PackageDetailRepositoryProvider._();

final class PackageDetailRepositoryProvider
    extends
        $FunctionalProvider<
          PackageDetailRepository,
          PackageDetailRepository,
          PackageDetailRepository
        >
    with $Provider<PackageDetailRepository> {
  PackageDetailRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'packageDetailRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$packageDetailRepositoryHash();

  @$internal
  @override
  $ProviderElement<PackageDetailRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PackageDetailRepository create(Ref ref) {
    return packageDetailRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PackageDetailRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PackageDetailRepository>(value),
    );
  }
}

String _$packageDetailRepositoryHash() =>
    r'89d5ea582967afe6e591b24e82dc96e33204d31c';
