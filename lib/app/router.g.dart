// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$packageListRoute];

RouteBase get $packageListRoute => GoRouteData.$route(
  path: '/',
  factory: $PackageListRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'packages/:name',
      factory: $PackageDetailRoute._fromState,
    ),
  ],
);

mixin $PackageListRoute on GoRouteData {
  static PackageListRoute _fromState(GoRouterState state) =>
      const PackageListRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PackageDetailRoute on GoRouteData {
  static PackageDetailRoute _fromState(GoRouterState state) =>
      PackageDetailRoute(name: state.pathParameters['name']!);

  PackageDetailRoute get _self => this as PackageDetailRoute;

  @override
  String get location =>
      GoRouteData.$location('/packages/${Uri.encodeComponent(_self.name)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
