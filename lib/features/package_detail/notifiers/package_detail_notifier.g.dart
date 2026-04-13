// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PackageDetailNotifier)
final packageDetailProvider = PackageDetailNotifierFamily._();

final class PackageDetailNotifierProvider
    extends $AsyncNotifierProvider<PackageDetailNotifier, PackageDetailState> {
  PackageDetailNotifierProvider._({
    required PackageDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'packageDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$packageDetailNotifierHash();

  @override
  String toString() {
    return r'packageDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PackageDetailNotifier create() => PackageDetailNotifier();

  @override
  bool operator ==(Object other) {
    return other is PackageDetailNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$packageDetailNotifierHash() =>
    r'7dbc52f78c8ddc960516036d7aa75b2195d37b13';

final class PackageDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          PackageDetailNotifier,
          AsyncValue<PackageDetailState>,
          PackageDetailState,
          FutureOr<PackageDetailState>,
          String
        > {
  PackageDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'packageDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PackageDetailNotifierProvider call(String packageName) =>
      PackageDetailNotifierProvider._(argument: packageName, from: this);

  @override
  String toString() => r'packageDetailProvider';
}

abstract class _$PackageDetailNotifier
    extends $AsyncNotifier<PackageDetailState> {
  late final _$args = ref.$arg as String;
  String get packageName => _$args;

  FutureOr<PackageDetailState> build(String packageName);
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
    element.handleCreate(ref, () => build(_$args));
  }
}
