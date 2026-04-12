import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'api_client.dart';

part 'pub_dev_api_client.g.dart';

/// pub.dev API のエンドポイント定義。
///
/// [ApiClient] を継承し、pub.dev 固有の URL 構築を担当する。
class PubDevApiClient extends ApiClient {
  /// [Dio] インスタンスを受け取って API クライアントを生成する。
  PubDevApiClient(super.dio);

  static const _baseUrl = 'https://pub.dev';

  /// パッケージ一覧を取得する。
  ///
  /// [pageUrl] を指定するとそのページのデータを取得する（ページネーション）。
  Future<Map<String, dynamic>> getPackages({
    String? pageUrl,
  }) {
    final url = pageUrl ?? '$_baseUrl/api/packages';
    return get(url);
  }

  /// 指定パッケージの詳細情報を取得する。
  Future<Map<String, dynamic>> getPackageDetail(
    String name,
  ) {
    return get('$_baseUrl/api/packages/$name');
  }

  /// 指定パッケージのパブリッシャー情報を取得する。
  Future<Map<String, dynamic>> getPackagePublisher(
    String name,
  ) {
    return get('$_baseUrl/api/packages/$name/publisher');
  }
}

@Riverpod(keepAlive: true)
PubDevApiClient pubDevApiClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  return PubDevApiClient(dio);
}
