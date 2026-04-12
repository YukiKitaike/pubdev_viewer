import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:pubdev_viewer/features/package_detail/providers/current_package_name_provider.dart';
import 'package:pubdev_viewer/features/package_detail/screens/package_detail_screen.dart';
import 'package:pubdev_viewer/features/package_list/screens/package_list_screen.dart';

part 'router.g.dart';

@TypedGoRoute<PackageListRoute>(
  path: '/',
  routes: [
    TypedGoRoute<PackageDetailRoute>(
      path: 'packages/:name',
    ),
  ],
)
@immutable
class PackageListRoute extends GoRouteData with $PackageListRoute {
  const PackageListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PackageListScreen();
  }
}

@immutable
class PackageDetailRoute extends GoRouteData with $PackageDetailRoute {
  const PackageDetailRoute({required this.name});

  final String name;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProviderScope(
      overrides: [
        currentPackageNameProvider.overrideWithValue(name),
      ],
      child: const PackageDetailScreen(),
    );
  }
}

final router = GoRouter(
  initialLocation: '/',
  routes: $appRoutes,
);
