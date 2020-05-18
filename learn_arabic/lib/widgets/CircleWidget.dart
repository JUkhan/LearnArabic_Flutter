import 'dart:math';

import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/models/MemoModel.dart';
import 'package:learn_arabic/blocs/util.dart';

class CircleProgress extends CustomPainter {
  double currentProgress;
  Themes theme;
  CircleProgress(this.currentProgress, this.theme);

  @override
  void paint(Canvas canvas, Size size) {
    //this is base circle
    Paint outerCircle = Paint()
      ..strokeWidth = 2
      ..color = Themes.light == theme ? Colors.black : Colors.white
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = 2
      ..color = Colors.red
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
  final Themes theme;
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
              foregroundPainter: CircleProgress(snapshot.data, theme),
              child: Icon(
                Icons.play_arrow,
                size: 18,
                color: snapshot.data == 0 ? Colors.blueAccent : Colors.red,
              ),
            ),
          );
        },
      ),
    );
  }
}
/*class CircleProgressWidget extends StatefulWidget {
  final String vid;
  final Themes theme;
  CircleProgressWidget({Key key, this.vid, this.theme})
      : super(key: key);

  @override
  _CircleProgressWidgetState createState() => _CircleProgressWidgetState();
}

class _CircleProgressWidgetState extends State<CircleProgressWidget>
    with SingleTickerProviderStateMixin {
  AnimationController progressController;
  Animation animation;

  @override
  void initState() {
    super.initState();
    progressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animation =
        Tween(begin: 0, end: widget.currentProgress).animate(progressController)
          ..addListener(() {
            setState(() {});
          });
    progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 40,
        height: 40,
        child: CustomPaint(
          //size: Size.fromHeight(30),
          foregroundPainter: CircleProgress(animation.value.toDouble(),
              widget.theme), // this will add custom painter after child
          child: Icon(
            Icons.play_arrow,
            size: 18,
            color: widget.currentProgress == 0 ? Colors.blueAccent : Colors.red,
          ),
        ));
  }

  @override
  void dispose() {
    progressController.dispose();
    super.dispose();
  }
}
*/
