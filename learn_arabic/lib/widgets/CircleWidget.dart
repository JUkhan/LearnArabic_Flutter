import 'dart:math';

import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/models/MemoModel.dart';

class CircleProgress extends CustomPainter {
  double currentProgress;
  int theme;
  CircleProgress(
      this.currentProgress, this.theme, this.outerColor, this.progressColor);
  Color outerColor;
  Color progressColor;
  @override
  void paint(Canvas canvas, Size size) {
    //this is base circle
    Paint outerCircle = Paint()
      ..strokeWidth = 2
      ..color = outerColor == Colors.grey[800] ? Colors.white : outerColor
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = 2
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) - 10;

    canvas.drawCircle(
        center, radius, outerCircle); // this draws main outer circle

    double angle = 2 * pi * (currentProgress / 100);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CircleProgressWidget extends StatelessWidget {
  final String vid;
  final int theme;
  const CircleProgressWidget({Key key, this.vid, this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: StreamBuilder(
        stream: select<MemoModel>('memo')
            .where((m) => m.videoId == vid)
            .map((m) => m.videoProgress),
        initialData: 0.0,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            child: CustomPaint(
              //size: Size.fromHeight(30),
              foregroundPainter: CircleProgress(snapshot.data, theme,
                  Theme.of(context).primaryColor, progressColor(context)),
              child: Icon(
                Icons.play_arrow,
                size: 18,
                color: snapshot.data == 0
                    ? Theme.of(context).primaryColor == Colors.grey[800]
                        ? Colors.white
                        : Theme.of(context).primaryColor
                    : progressColor(context),
              ),
            ),
          );
        },
      ),
    );
  }

  Color progressColor(BuildContext context) =>
      (Theme.of(context).primaryColor.value == Colors.red.value ||
              Theme.of(context).primaryColor.value == Colors.pink.value ||
              Theme.of(context).primaryColor.value == Colors.deepOrange.value)
          ? Colors.purple
          : Colors.red;
}
