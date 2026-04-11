import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/pub_dev_api_client.dart';
import '../models/package_list_response.dart';

part 'package_list_repository.g.dart';

/// パッケージ一覧データの取得を担当する Repository。
class PackageListRepository {
  /// [PubDevApiClient] を使用してインスタンスを生成する。
  PackageListRepository(this._apiClient);

  final PubDevApiClient _apiClient;

  /// パッケージ一覧を取得する。[pageUrl] でページネーションに対応。
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
