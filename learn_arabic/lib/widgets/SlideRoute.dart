import 'package:flutter/material.dart';

enum SlideDirection { Left, Right }

// class SlideRoute extends PageRouteBuilder {
//   final Widget widget;
//   final SlideDirection sildeDirection;
//   SlideRoute({this.widget, this.sildeDirection})
//       : super(pageBuilder: (BuildContext context, Animation<double> animation,
//             Animation<double> secondaryAnimation) {
//           return widget;
//         }, transitionsBuilder: (BuildContext context,
//             Animation<double> animation,
//             Animation<double> secondaryAnimation,
//             Widget child) {
//           return SlideTransition(
//             position: Tween(
//               begin: SlideDirection.Left == sildeDirection
//                   ? const Offset(1.0, 0.0)
//                   : const Offset(-1.0, 0.0),
//               end: Offset.zero,
//             ).chain(CurveTween(curve: Curves.easeIn)).animate(animation),
//             child: child,
//           );
//         });
// }

Route createRoute(Widget widget, SlideDirection sildeDirection) =>
    PageRouteBuilder(pageBuilder: (BuildContext context,
        Animation<double> animation, Animation<double> secondaryAnimation) {
      return widget;
    }, transitionsBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return SlideTransition(
        position: Tween(
          begin: SlideDirection.Left == sildeDirection
              ? const Offset(1.0, 0.0)
              : const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeIn)).animate(animation),
        child: child,
      );
    });
