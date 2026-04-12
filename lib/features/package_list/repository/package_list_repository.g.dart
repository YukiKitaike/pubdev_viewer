// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_list_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(packageListRepository)
final packageListRepositoryProvider = PackageListRepositoryProvider._();

final class PackageListRepositoryProvider
    extends
        $FunctionalProvider<
          PackageListRepository,
          PackageListRepository,
          PackageListRepository
        >
    with $Provider<PackageListRepository> {
  PackageListRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'packageListRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$packageListRepositoryHash();

  @$internal
  @override
  $ProviderElement<PackageListRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PackageListRepository create(Ref ref) {
    return packageListRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PackageListRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PackageListRepository>(value),
    );
  }
}

String _$packageListRepositoryHash() =>
    r'741b0a3342cff91aae25e6834c18ee0bb310406b';
