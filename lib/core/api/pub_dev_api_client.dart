import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'api_client.dart';

part 'pub_dev_api_client.g.dart';

class PubDevApiClient extends ApiClient {
  PubDevApiClient(super.dio);

  static const _baseUrl = 'https://pub.dev';

  Future<Map<String, dynamic>> getPackages({
    String? pageUrl,
  }) {
    final url = pageUrl ?? '$_baseUrl/api/packages';
    return get(url);
  }

  Future<Map<String, dynamic>> getPackageDetail(
    String name,
  ) {
    return get('$_baseUrl/api/packages/$name');
  }

  Future<Map<String, dynamic>> getPackagePublisher(
    String name,
  ) {
    return get('$_baseUrl/api/packages/$name/publisher');
  }
}

// Dio を keepAlive でアプリ存続中保持する。
// リクエストごとに生成すると HTTP コネクションプールが再利用されず遅延が増す。
@Riverpod(keepAlive: true)
PubDevApiClient pubDevApiClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      // pub.dev API は通常 1〜2 秒で応答する。
      // 10 秒は余裕を持ちつつ無応答時にユーザーを長く待たせない妥協値。
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  return PubDevApiClient(dio);
}
