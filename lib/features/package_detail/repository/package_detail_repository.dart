import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/pub_dev_api_client.dart';
import '../models/package_detail_response.dart';
import '../models/package_publisher_response.dart';

part 'package_detail_repository.g.dart';

class PackageDetailRepository {
  PackageDetailRepository(this._apiClient);

  final PubDevApiClient _apiClient;

  Future<PackageDetailResponse> getPackageDetail(
    String name,
  ) async {
    final json = await _apiClient.getPackageDetail(name);
    return PackageDetailResponse.fromJson(json);
  }

  Future<PackagePublisherResponse> getPackagePublisher(
    String name,
  ) async {
    final json = await _apiClient.getPackagePublisher(name);
    return PackagePublisherResponse.fromJson(json);
  }
}

@riverpod
PackageDetailRepository packageDetailRepository(Ref ref) {
  return PackageDetailRepository(
    ref.watch(pubDevApiClientProvider),
  );
}
