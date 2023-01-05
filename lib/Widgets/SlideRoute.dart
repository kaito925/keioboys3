import 'package:flutter/material.dart';

Route slideRoute(newPage) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => newPage,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: animation.drive(
          Tween(
            begin: Offset(1.0, 0.0),
            end: Offset(0.0, 0.0),
          ).chain(
            CurveTween(curve: Curves.ease),
          ),
        ),
        child: child,
      );
    },
  );
}
