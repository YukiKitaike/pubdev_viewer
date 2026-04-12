import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/pub_dev_api_client.dart';
import '../models/package_list_response.dart';

part 'package_list_repository.g.dart';

class PackageListRepository {
  PackageListRepository(this._apiClient);

  final PubDevApiClient _apiClient;

  Future<PackageListResponse> getPackages({
    String? pageUrl,
  }) async {
    final json = await _apiClient.getPackages(
      pageUrl: pageUrl,
    );
    return PackageListResponse.fromJson(json);
  }
}

@riverpod
PackageListRepository packageListRepository(Ref ref) {
  return PackageListRepository(
    ref.watch(pubDevApiClientProvider),
  );
}
