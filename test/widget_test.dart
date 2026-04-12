@Tags(['widget'])
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubdev_viewer/app/app.dart';
import 'package:pubdev_viewer/features/package_list/models/package_list_response.dart';
import 'package:pubdev_viewer/features/package_list/repository/package_list_repository.dart';

import 'helpers/fakes.dart';
import 'helpers/fixtures.dart';

void main() {
  testWidgets('アプリがホーム画面を描画する', (tester) async {
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

    await tester.pump();
    expect(find.text('pub.dev Viewer', findRichText: true), findsOneWidget);
  });
}
