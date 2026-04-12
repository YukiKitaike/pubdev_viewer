import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
class PackageListRoute extends GoRouteData with _$PackageListRoute {
  const PackageListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PackageListScreen();
  }
}

@immutable
class PackageDetailRoute extends GoRouteData with _$PackageDetailRoute {
  const PackageDetailRoute({required this.name});

  final String name;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PackageDetailScreen(packageName: name);
  }
}

final router = GoRouter(
  initialLocation: '/',
  routes: $appRoutes,
);
