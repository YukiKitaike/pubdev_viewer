import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/pub_dev_api_client.dart';
import '../models/package_detail_response.dart';
import '../models/package_publisher_response.dart';

part 'package_detail_repository.g.dart';

/// パッケージ詳細データの取得を担当する Repository。
class PackageDetailRepository {
  /// [PubDevApiClient] を使用してインスタンスを生成する。
  PackageDetailRepository(this._apiClient);

  final PubDevApiClient _apiClient;

  /// 指定パッケージの詳細情報を取得する。
  Future<PackageDetailResponse> getPackageDetail(
    String name,
  ) async {
    final json = await _apiClient.getPackageDetail(name);
    return PackageDetailResponse.fromJson(json);
  }

  /// 指定パッケージのパブリッシャー情報を取得する。
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
