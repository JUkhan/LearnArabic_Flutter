import 'package:flutter/material.dart';
enum SlideDirection{
  Left, Right
}
class SlideRoute extends PageRouteBuilder {
  final Widget widget;
  final SlideDirection sildeDirection;
  SlideRoute({this.widget, this.sildeDirection})
    : super(
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return widget;
        },
        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
          return new SlideTransition(
            position: new Tween<Offset>(
              begin:SlideDirection.Left== sildeDirection? const Offset(1.0, 0.0):const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
           );
         }
      );
}