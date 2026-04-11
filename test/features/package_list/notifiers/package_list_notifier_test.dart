import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pubdev_viewer/features/package_list/models/package_list_response.dart';
import 'package:pubdev_viewer/features/package_list/notifiers/package_list_notifier.dart';
import 'package:pubdev_viewer/features/package_list/repository/package_list_repository.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

PackageListResponse _firstPage() =>
    PackageListResponse.fromJson(
      Map<String, dynamic>.from(packageListResponseJson),
    );

PackageListResponse _lastPage() =>
    PackageListResponse.fromJson(
      Map<String, dynamic>.from(
        packageListResponseLastPageJson,
      ),
    );

void main() {
  late MockPackageListRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockPackageListRepository();
    container = ProviderContainer(
      overrides: [
        packageListRepositoryProvider
            .overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('PackageListNotifier', () {
    test('build fetches initial packages', () async {
      when(
        () => mockRepository.getPackages(
          pageUrl: any(named: 'pageUrl'),
        ),
      ).thenAnswer((_) async => _firstPage());

      final state = await container.read(
        packageListNotifierProvider.future,
      );

      expect(state.packages, hasLength(2));
      expect(state.packages[0].name, 'http');
      expect(state.nextUrl, isNotNull);
    });

    test('loadMore appends packages', () async {
      var callCount = 0;
      when(
        () => mockRepository.getPackages(
          pageUrl: any(named: 'pageUrl'),
        ),
      ).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) {
          return _firstPage();
        }
        return _lastPage();
      });

      // Wait for initial load
      await container.read(
        packageListNotifierProvider.future,
      );

      // Load more
      await container
          .read(packageListNotifierProvider.notifier)
          .loadMore();

      final state = container.read(
        packageListNotifierProvider,
      );
      expect(state.valueOrNull?.packages, hasLength(2));
      expect(state.valueOrNull?.nextUrl, isNull);
    });

    test(
      'loadMore does nothing when nextUrl is null',
      () async {
        when(
          () => mockRepository.getPackages(
            pageUrl: any(named: 'pageUrl'),
          ),
        ).thenAnswer((_) async => _lastPage());

        await container.read(
          packageListNotifierProvider.future,
        );

        await container
            .read(packageListNotifierProvider.notifier)
            .loadMore();

        // Only 1 call: the initial build
        verify(
          () => mockRepository.getPackages(
            pageUrl: any(named: 'pageUrl'),
          ),
        ).called(1);
      },
    );
  });
}
