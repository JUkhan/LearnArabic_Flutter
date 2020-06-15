import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/models/PainterModel.dart';

class Painter extends CustomPainter {
  PainterModel pModel;
  Painter(this.pModel);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < pModel.points.length - 1; i++) {
      if (pModel.points[i].offset != null &&
          pModel.points[i + 1].offset != null &&
          pModel.points[i].offset.dy > 0) {
        paint.color = pModel.points[i].color;
        paint.strokeWidth = pModel.points[i].strokeWidth;
        canvas.drawLine(
            pModel.points[i].offset, pModel.points[i + 1].offset, paint);
      } else if (pModel.points[i].offset != null &&
          pModel.points[i + 1].offset == null &&
          pModel.points[i].offset.dy > 0) {
        paint.color = pModel.points[i].color;
        paint.strokeWidth =
            pModel.strokeWidth < 2 ? 2.0 : pModel.points[i].strokeWidth;
        canvas.drawPoints(PointMode.points, [pModel.points[i].offset], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Painter painter) =>
      true; // painter.points.length != points.length;
}
