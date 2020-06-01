import 'package:flutter/material.dart';

class PainterModel {
  final Color color;
  final List<OffsetStatus> points;
  final int totalLines;
  final int currentIndex;
  final bool colorPickerOpened;
  PainterModel(this.color, this.points, this.totalLines, this.currentIndex,
      this.colorPickerOpened);
  factory PainterModel.init() => PainterModel(Colors.black, [], 0, 0, false);
  PainterModel copyWith(
          {Color color,
          List<OffsetStatus> points,
          int totalLines,
          bool colorPickerOpened,
          int currentIndex}) =>
      PainterModel(
          color ?? this.color,
          points ?? this.points,
          totalLines ?? this.totalLines,
          currentIndex ?? this.currentIndex,
          colorPickerOpened ?? this.colorPickerOpened);
}

class OffsetStatus {
  final Offset offset;
  final Color color;
  OffsetStatus(this.offset, this.color);
}
