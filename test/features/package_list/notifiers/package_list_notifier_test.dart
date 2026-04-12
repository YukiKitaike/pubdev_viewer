import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/error/app_exception.dart';
import 'package:pubdev_viewer/features/package_list/models/package_list_response.dart';
import 'package:pubdev_viewer/features/package_list/notifiers/package_list_notifier.dart';
import 'package:pubdev_viewer/features/package_list/repository/package_list_repository.dart';

import '../../../helpers/fakes.dart';
import '../../../helpers/fixtures.dart';

PackageListResponse _firstPage() => PackageListResponse.fromJson(
  Map<String, dynamic>.from(packageListResponseJson),
);

PackageListResponse _lastPage() => PackageListResponse.fromJson(
  Map<String, dynamic>.from(packageListResponseLastPageJson),
);

void main() {
  late FakePackageListRepository fakeRepository;
  late ProviderContainer container;

  setUp(() {
    fakeRepository = FakePackageListRepository();
    container = ProviderContainer(
      overrides: [
        packageListRepositoryProvider.overrideWithValue(fakeRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('PackageListNotifier', () {
    test('build が初期パッケージを取得する', () async {
      fakeRepository.onGetPackages = ({String? pageUrl}) async => _firstPage();

      final state = await container.read(
        packageListNotifierProvider.future,
      );

      expect(state.packages, hasLength(2));
      expect(state.packages[0].name, 'http');
      expect(state.nextUrl, isNotNull);
    });

    test('loadMore がパッケージを追加する', () async {
      var callCount = 0;
      fakeRepository.onGetPackages = ({String? pageUrl}) async {
        callCount++;
        if (callCount == 1) {
          return _firstPage();
        }
        return _lastPage();
      };

      await container.read(packageListNotifierProvider.future);

      await container.read(packageListNotifierProvider.notifier).loadMore();

      final state = container.read(packageListNotifierProvider).valueOrNull;
      expect(state?.packages, hasLength(2));
      expect(state?.nextUrl, isNull);
    });

    test('nextUrl が null のとき loadMore は何もしない', () async {
      fakeRepository.onGetPackages = ({String? pageUrl}) async => _lastPage();

      await container.read(packageListNotifierProvider.future);

      await container.read(packageListNotifierProvider.notifier).loadMore();

      // Only 1 call: the initial build
      expect(fakeRepository.getPackagesCallCount, 1);
    });

    test('repository が例外を投げると build が AsyncError になる', () async {
      fakeRepository.onGetPackages = ({String? pageUrl}) =>
          throw const NetworkException();

      await container
          .read(packageListNotifierProvider.future)
          .then((_) => null)
          .catchError((_) => null);

      final asyncValue = container.read(packageListNotifierProvider);
      expect(asyncValue.hasError, isTrue);
      expect(asyncValue.error, isA<NetworkException>());
    });

    test('loadMore はエラー時に既存データを保持する', () async {
      var callCount = 0;
      fakeRepository.onGetPackages = ({String? pageUrl}) async {
        callCount++;
        if (callCount == 1) {
          return _firstPage();
        }
        throw const NetworkException();
      };

      await container.read(packageListNotifierProvider.future);

      await container.read(packageListNotifierProvider.notifier).loadMore();

      final state = container.read(packageListNotifierProvider).valueOrNull;
      expect(state, isNotNull);
      expect(state!.packages, hasLength(2));
      expect(state.isLoadingMore, isFalse);
      expect(state.loadMoreError, isA<NetworkException>());
    });

    test('refresh が再ビルドをトリガーする', () async {
      fakeRepository.onGetPackages = ({String? pageUrl}) async => _firstPage();

      await container.read(packageListNotifierProvider.future);
      expect(fakeRepository.getPackagesCallCount, 1);

      await container.read(packageListNotifierProvider.notifier).refresh();
      expect(fakeRepository.getPackagesCallCount, 2);
    });

    test('clearLoadMoreError が loadMoreError を null にリセットする', () async {
      var callCount = 0;
      fakeRepository.onGetPackages = ({String? pageUrl}) async {
        callCount++;
        if (callCount == 1) {
          return _firstPage();
        }
        throw const NetworkException();
      };

      await container.read(packageListNotifierProvider.future);
      await container.read(packageListNotifierProvider.notifier).loadMore();

      final before = container.read(packageListNotifierProvider).valueOrNull;
      expect(before, isNotNull);
      expect(before!.loadMoreError, isA<NetworkException>());

      container.read(packageListNotifierProvider.notifier).clearLoadMoreError();

      final after = container.read(packageListNotifierProvider).valueOrNull;
      expect(after!.loadMoreError, isNull);
    });

    test('loadMore 実行中に再度 loadMore を呼んでも無視される', () async {
      fakeRepository.onGetPackages = ({String? pageUrl}) async => _firstPage();
      await container.read(packageListNotifierProvider.future);

      // Suspend the second getPackages call via Completer
      final completer = Completer<PackageListResponse>();
      fakeRepository.getPackagesCompleter = completer;

      // First loadMore starts but is suspended — isLoadingMore becomes true
      unawaited(
        container.read(packageListNotifierProvider.notifier).loadMore(),
      );

      // Second call must be a no-op because isLoadingMore is already true
      await container.read(packageListNotifierProvider.notifier).loadMore();

      // callCount: 1 (build) + 1 (first loadMore) = 2; second loadMore is no-op
      expect(fakeRepository.getPackagesCallCount, 2);

      completer.complete(_lastPage());
    });
  });
}
