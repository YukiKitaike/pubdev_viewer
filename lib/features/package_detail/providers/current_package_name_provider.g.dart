// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_package_name_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 詳細画面で表示中のパッケージ名を提供する。
/// PackageDetailRoute が ProviderScope.overrides で値を注入する。

@ProviderFor(currentPackageName)
final currentPackageNameProvider = CurrentPackageNameProvider._();

/// 詳細画面で表示中のパッケージ名を提供する。
/// PackageDetailRoute が ProviderScope.overrides で値を注入する。

final class CurrentPackageNameProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// 詳細画面で表示中のパッケージ名を提供する。
  /// PackageDetailRoute が ProviderScope.overrides で値を注入する。
  CurrentPackageNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentPackageNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentPackageNameHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return currentPackageName(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$currentPackageNameHash() =>
    r'db8c13452f8eee929524ca4a92070b9a85468093';
