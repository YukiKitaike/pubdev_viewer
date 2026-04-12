import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_package_name_provider.g.dart';

/// 詳細画面で表示中のパッケージ名を提供する。
/// PackageDetailRoute が ProviderScope.overrides で値を注入する。
@riverpod
String currentPackageName(Ref ref) =>
    throw UnimplementedError('currentPackageNameProvider must be overridden');
