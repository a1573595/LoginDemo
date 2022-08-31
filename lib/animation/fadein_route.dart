import 'package:flutter/material.dart';

// https://juejin.cn/post/6844903854371241997
class FadeInRoute extends PageRouteBuilder {
  final Widget enterPage;

  FadeInRoute(this.enterPage)
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              enterPage,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              Stack(
            children: <Widget>[
              FadeTransition(
                opacity: animation,
                child: enterPage,
              ),
            ],
          ),
        );
}
