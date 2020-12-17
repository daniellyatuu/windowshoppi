import 'package:flutter/material.dart';

class FadeRoute extends PageRouteBuilder {
  final Widget widget;

  FadeRoute({this.widget})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}