import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension GoRouterExtension on GoRouter {
  BuildContext? get context => routerDelegate.navigatorKey.currentState?.overlay?.context;

  String get currentLocation {
    final lastMatch = routerDelegate.currentConfiguration.last;
    final matchList = lastMatch is ImperativeRouteMatch ? lastMatch.matches : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
