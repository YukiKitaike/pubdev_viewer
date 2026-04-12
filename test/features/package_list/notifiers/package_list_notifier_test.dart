@Tags(['unit'])
library;

import 'dart:async';

import 'package:checks/checks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/core/error/app_exception.dart';
import 'package:pubdev_viewer/features/package_list/models/package_list_response.dart';
import 'package:pubdev_viewer/features/package_list/notifiers/package_list_notifier.dart';
import 'package:pubdev_viewer/features/package_list/repository/package_list_repository.dart';

import '../../../helpers/fakes.dart';
import '../../../helpers/fixtures.dart';

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
      fakeRepository.onGetPackages = ({String? pageUrl}) async =>
          firstPageResponse();

      final state = await container.read(
        packageListNotifierProvider.future,
      );

      check(state.packages).length.equals(2);
      check(state.packages[0].name).equals('http');
      check(state.nextUrl).isNotNull();
    });

    test('loadMore がパッケージを追加する', () async {
      var callCount = 0;
      fakeRepository.onGetPackages = ({String? pageUrl}) async {
        callCount++;
        if (callCount == 1) {
          return firstPageResponse();
        }
        return lastPageResponse();
      };

      await container.read(packageListNotifierProvider.future);

      await container.read(packageListNotifierProvider.notifier).loadMore();

      final state = container.read(packageListNotifierProvider).valueOrNull;
      check(state).isNotNull();
      check(state!.packages).length.equals(2);
      check(state.nextUrl).isNull();
    });

    test('nextUrl が null のとき loadMore は何もしない', () async {
      fakeRepository.onGetPackages = ({String? pageUrl}) async =>
          lastPageResponse();

      await container.read(packageListNotifierProvider.future);

      await container.read(packageListNotifierProvider.notifier).loadMore();

      check(fakeRepository.getPackagesCallCount).equals(1);
    });

    test('repository が例外を投げると build が AsyncError になる', () async {
      fakeRepository.onGetPackages = ({String? pageUrl}) =>
          throw const NetworkException();

      await container
          .read(packageListNotifierProvider.future)
          .then((_) => null)
          .catchError((_) => null);

      final asyncValue = container.read(packageListNotifierProvider);
      check(asyncValue.hasError).isTrue();
      check(asyncValue.error).isA<NetworkException>();
    });

    test('loadMore はエラー時に既存データを保持する', () async {
      var callCount = 0;
      fakeRepository.onGetPackages = ({String? pageUrl}) async {
        callCount++;
        if (callCount == 1) {
          return firstPageResponse();
        }
        throw const NetworkException();
      };

      await container.read(packageListNotifierProvider.future);

      await container.read(packageListNotifierProvider.notifier).loadMore();

      final state = container.read(packageListNotifierProvider).valueOrNull;
      check(state).isNotNull();
      check(state!.packages).length.equals(2);
      check(state.isLoadingMore).isFalse();
      check(state.loadMoreError).isA<NetworkException>();
    });

    test('refresh が再ビルドをトリガーする', () async {
      fakeRepository.onGetPackages = ({String? pageUrl}) async =>
          firstPageResponse();

      await container.read(packageListNotifierProvider.future);
      check(fakeRepository.getPackagesCallCount).equals(1);

      await container.read(packageListNotifierProvider.notifier).refresh();
      check(fakeRepository.getPackagesCallCount).equals(2);
    });

    test('clearLoadMoreError が loadMoreError を null にリセットする', () async {
      var callCount = 0;
      fakeRepository.onGetPackages = ({String? pageUrl}) async {
        callCount++;
        if (callCount == 1) {
          return firstPageResponse();
        }
        throw const NetworkException();
      };

      await container.read(packageListNotifierProvider.future);
      await container.read(packageListNotifierProvider.notifier).loadMore();

      final before = container.read(packageListNotifierProvider).valueOrNull;
      check(before).isNotNull();
      check(before!.loadMoreError).isA<NetworkException>();

      container.read(packageListNotifierProvider.notifier).clearLoadMoreError();

      final after = container.read(packageListNotifierProvider).valueOrNull;
      check(after!.loadMoreError).isNull();
    });

    test('loadMore 実行中に再度 loadMore を呼んでも無視される', () async {
      fakeRepository.onGetPackages = ({String? pageUrl}) async =>
          firstPageResponse();
      await container.read(packageListNotifierProvider.future);

      // Completer で 2 回目の getPackages を保留する
      final completer = Completer<PackageListResponse>();
      fakeRepository.getPackagesCompleter = completer;

      // 1 回目の loadMore は保留中 — isLoadingMore が true になる
      unawaited(
        container.read(packageListNotifierProvider.notifier).loadMore(),
      );

      // 2 回目は isLoadingMore が true のため no-op
      await container.read(packageListNotifierProvider.notifier).loadMore();

      // callCount: 1 (build) + 1 (first loadMore) = 2
      check(fakeRepository.getPackagesCallCount).equals(2);

      completer.complete(lastPageResponse());
    });
  });
}
