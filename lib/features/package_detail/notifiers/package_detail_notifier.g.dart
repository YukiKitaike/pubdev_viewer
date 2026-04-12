// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PackageDetailNotifier)
final packageDetailProvider = PackageDetailNotifierProvider._();

final class PackageDetailNotifierProvider
    extends $AsyncNotifierProvider<PackageDetailNotifier, PackageDetailState> {
  PackageDetailNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'packageDetailProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentPackageNameProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          PackageDetailNotifierProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = currentPackageNameProvider;

  @override
  String debugGetCreateSourceHash() => _$packageDetailNotifierHash();

  @$internal
  @override
  PackageDetailNotifier create() => PackageDetailNotifier();
}

String _$packageDetailNotifierHash() =>
    r'cdea479cbbf061768d268bb869caead8065ed9b7';

abstract class _$PackageDetailNotifier
    extends $AsyncNotifier<PackageDetailState> {
  FutureOr<PackageDetailState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<PackageDetailState>, PackageDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PackageDetailState>, PackageDetailState>,
              AsyncValue<PackageDetailState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
