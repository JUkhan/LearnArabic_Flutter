import 'package:flutter/material.dart';

class PainterModel {
  final Color color;
  final List<OffsetStatus> points;
  final int totalLines;
  final int currentIndex;
  final bool colorPickerOpened;
  final double strokeWidth;
  PainterModel(this.color, this.points, this.totalLines, this.currentIndex,
      this.colorPickerOpened, this.strokeWidth);
  factory PainterModel.init() =>
      PainterModel(Colors.black, [], 0, 0, false, 1.5);
  PainterModel copyWith(
          {Color color,
          List<OffsetStatus> points,
          int totalLines,
          bool colorPickerOpened,
          int currentIndex,
          double strokeWidth}) =>
      PainterModel(
          color ?? this.color,
          points ?? this.points,
          totalLines ?? this.totalLines,
          currentIndex ?? this.currentIndex,
          colorPickerOpened ?? this.colorPickerOpened,
          strokeWidth ?? this.strokeWidth);
}

class OffsetStatus {
  final Offset offset;
  final Color color;
  final double strokeWidth;
  OffsetStatus(this.offset, this.color, this.strokeWidth);
}
