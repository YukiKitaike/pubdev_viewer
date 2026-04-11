import 'package:mocktail/mocktail.dart';
import 'package:pubdev_viewer/core/api/pub_dev_api_client.dart';
import 'package:pubdev_viewer/features/package_detail/repository/package_detail_repository.dart';
import 'package:pubdev_viewer/features/package_list/repository/package_list_repository.dart';

class MockPubDevApiClient extends Mock implements PubDevApiClient {}

class MockPackageListRepository extends Mock implements PackageListRepository {}

class MockPackageDetailRepository extends Mock
    implements PackageDetailRepository {}
