// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PackageListNotifier)
final packageListProvider = PackageListNotifierProvider._();

final class PackageListNotifierProvider
    extends $AsyncNotifierProvider<PackageListNotifier, PackageListState> {
  PackageListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'packageListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$packageListNotifierHash();

  @$internal
  @override
  PackageListNotifier create() => PackageListNotifier();
}

String _$packageListNotifierHash() =>
    r'4b1a5320d5bc82139dfbdfae60bb0503e5086055';

abstract class _$PackageListNotifier extends $AsyncNotifier<PackageListState> {
  FutureOr<PackageListState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<PackageListState>, PackageListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PackageListState>, PackageListState>,
              AsyncValue<PackageListState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
