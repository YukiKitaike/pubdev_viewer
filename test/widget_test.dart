import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/features/package_list/models/package_list_response.dart';
import 'package:pubdev_viewer/features/package_list/repository/package_list_repository.dart';
import 'package:pubdev_viewer/main.dart';

import 'helpers/fakes.dart';
import 'helpers/fixtures.dart';

void main() {
  testWidgets('App renders home screen', (tester) async {
    final fakeRepo = FakePackageListRepository()
      ..onGetPackages = ({String? pageUrl}) async =>
          PackageListResponse.fromJson(
            Map<String, dynamic>.from(packageListResponseJson),
          );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          packageListRepositoryProvider.overrideWithValue(fakeRepo),
        ],
        child: const PubDevViewerApp(),
      ),
    );

    expect(find.text('pub.dev Viewer'), findsOneWidget);
  });
}
