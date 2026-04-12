// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pub_dev_api_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pubDevApiClient)
final pubDevApiClientProvider = PubDevApiClientProvider._();

final class PubDevApiClientProvider
    extends
        $FunctionalProvider<PubDevApiClient, PubDevApiClient, PubDevApiClient>
    with $Provider<PubDevApiClient> {
  PubDevApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pubDevApiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pubDevApiClientHash();

  @$internal
  @override
  $ProviderElement<PubDevApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PubDevApiClient create(Ref ref) {
    return pubDevApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PubDevApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PubDevApiClient>(value),
    );
  }
}

String _$pubDevApiClientHash() => r'a2ea57c0c9913b87ffe141ded0459718e32bb137';
