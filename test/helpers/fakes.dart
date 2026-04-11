import 'dart:async';

import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:pubdev_viewer/core/api/pub_dev_api_client.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_detail_response.dart';
import 'package:pubdev_viewer/features/package_detail/models/package_publisher_response.dart';
import 'package:pubdev_viewer/features/package_detail/repository/package_detail_repository.dart';
import 'package:pubdev_viewer/features/package_list/models/package_list_response.dart';
import 'package:pubdev_viewer/features/package_list/repository/package_list_repository.dart';

/// [Dio] の Fake 実装。
///
/// [onGet] に GET リクエストの挙動を設定する。
/// 呼び出し URL は [getCalls] で検証可能。
class FakeDio extends Fake implements Dio {
  Future<Response<T>> Function<T>(String url)? onGet;
  final List<String> getCalls = [];

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Object? data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    getCalls.add(path);
    return onGet!<T>(path);
  }
}

/// [PubDevApiClient] の Fake 実装。
///
/// 各メソッドの挙動を [onGetPackages] 等のコールバックで設定する。
/// 呼び出し履歴は [getPackagesCalls] 等で確認可能。
class FakePubDevApiClient extends Fake implements PubDevApiClient {
  Future<Map<String, dynamic>> Function({String? pageUrl})? onGetPackages;
  Future<Map<String, dynamic>> Function(String name)? onGetPackageDetail;
  Future<Map<String, dynamic>> Function(String name)? onGetPackagePublisher;

  final List<String?> getPackagesCalls = [];
  final List<String> getPackageDetailCalls = [];
  final List<String> getPackagePublisherCalls = [];

  @override
  Future<Map<String, dynamic>> getPackages({String? pageUrl}) {
    getPackagesCalls.add(pageUrl);
    return onGetPackages!(pageUrl: pageUrl);
  }

  @override
  Future<Map<String, dynamic>> getPackageDetail(String name) {
    getPackageDetailCalls.add(name);
    return onGetPackageDetail!(name);
  }

  @override
  Future<Map<String, dynamic>> getPackagePublisher(String name) {
    getPackagePublisherCalls.add(name);
    return onGetPackagePublisher!(name);
  }
}

/// [PackageListRepository] の Fake 実装。
///
/// [onGetPackages] で返却値やエラーを設定し、
/// [getPackagesCallCount] で呼び出し回数を検証する。
class FakePackageListRepository extends Fake
    implements PackageListRepository {
  Future<PackageListResponse> Function({String? pageUrl})? onGetPackages;
  Completer<PackageListResponse>? getPackagesCompleter;
  int getPackagesCallCount = 0;

  @override
  Future<PackageListResponse> getPackages({String? pageUrl}) {
    getPackagesCallCount++;
    if (getPackagesCompleter != null) {
      return getPackagesCompleter!.future;
    }
    return onGetPackages!(pageUrl: pageUrl);
  }
}

/// [PackageDetailRepository] の Fake 実装。
///
/// 各メソッドの挙動をコールバックで設定し、呼び出し回数を追跡する。
class FakePackageDetailRepository extends Fake
    implements PackageDetailRepository {
  Future<PackageDetailResponse> Function(String name)? onGetPackageDetail;
  Future<PackagePublisherResponse> Function(String name)?
      onGetPackagePublisher;
  Completer<PackageDetailResponse>? getPackageDetailCompleter;
  int getPackageDetailCallCount = 0;
  int getPackagePublisherCallCount = 0;

  @override
  Future<PackageDetailResponse> getPackageDetail(String name) {
    getPackageDetailCallCount++;
    if (getPackageDetailCompleter != null) {
      return getPackageDetailCompleter!.future;
    }
    return onGetPackageDetail!(name);
  }

  @override
  Future<PackagePublisherResponse> getPackagePublisher(String name) {
    getPackagePublisherCallCount++;
    return onGetPackagePublisher!(name);
  }
}
