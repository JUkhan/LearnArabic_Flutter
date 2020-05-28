import 'package:flutter/material.dart';

class PainterModel {
  final Color color;
  final List<Offset> points;
  final int totalLines;
  final int currentIndex;
  PainterModel(this.color, this.points, this.totalLines, this.currentIndex);
  factory PainterModel.init() => PainterModel(Colors.black, [], 0, 0);
  PainterModel copyWith(
          {Color color,
          List<Offset> points,
          int totalLines,
          int currentIndex}) =>
      PainterModel(color ?? this.color, points ?? this.points,
          totalLines ?? this.totalLines, currentIndex ?? this.currentIndex);
}
