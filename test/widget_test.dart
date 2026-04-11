import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pubdev_viewer/features/package_list/models/package_list_response.dart';
import 'package:pubdev_viewer/features/package_list/repository/package_list_repository.dart';
import 'package:pubdev_viewer/main.dart';

import 'helpers/fixtures.dart';
import 'helpers/mocks.dart';

void main() {
  testWidgets('App renders home screen', (tester) async {
    final mockRepo = MockPackageListRepository();
    when(
      () => mockRepo.getPackages(
        pageUrl: any(named: 'pageUrl'),
      ),
    ).thenAnswer(
      (_) async => PackageListResponse.fromJson(
        Map<String, dynamic>.from(
          packageListResponseJson,
        ),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          packageListRepositoryProvider
              .overrideWithValue(mockRepo),
        ],
        child: const PubDevViewerApp(),
      ),
    );

    expect(find.text('pub.dev Viewer'), findsOneWidget);
  });
}
