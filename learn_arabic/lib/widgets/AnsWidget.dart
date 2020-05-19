import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/models/BookInfo.dart';
import 'package:learn_arabic/blocs/models/MemoModel.dart';
import 'package:learn_arabic/blocs/models/bookModel.dart';
import 'package:learn_arabic/blocs/util.dart';
import 'package:learn_arabic/widgets/TextWidget.dart';

class AnsWidget extends StatefulWidget {
  final JLine line;
  final MemoModel memo;
  final BookModel bookModel;
  AnsWidget({Key key, this.line, this.memo, this.bookModel}) : super(key: key);

  @override
  _AnsWidgetState createState() => _AnsWidgetState();
}

class _AnsWidgetState extends State<AnsWidget> {
  bool _isHidden = true;
  Color _endColor = Colors.red;
  @override
  Widget build(BuildContext context) {
    //print('------------------ansWidget---------------');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: _getWigets(widget.line),
    );
  }

  List<Widget> _getWigets(JLine line) {
    List<Widget> widgets = List<Widget>();
    widgets.add(RaisedButton(
      child: const Text('Ans'),
      color: _isHidden ? Theme.of(context).accentColor : Colors.red,
      onPressed: () {
        setState(() {
          _endColor = Colors.red;
          _isHidden = !_isHidden;
        });
      },
    ));
    if (!_isHidden) {
      widgets.add(TweenAnimationBuilder(
        duration: Duration(seconds: 2),
        tween: ColorTween(begin: Colors.blue, end: _endColor),
        onEnd: () {
          setState(() {
            _endColor = _endColor == Colors.red ? Colors.blue : Colors.red;
          });
        },
        builder: (_, color, __) => Divider(
          color: color,
          height: 20.0,
          //thickness: 2.0,
        ),
      ));
      /*widgets.add(Divider(
        color: Colors.blue,
      ));*/
      if (line.words.length > 0) {
        widgets.add(TextWidget(
          line: line,
          memo: widget.memo,
          bookModel: widget.bookModel,
        ));
      }

      if (line.lines.length > 0) {
        Util.setWidget(widgets, line, widget.memo, widget.bookModel);
      }
    }
    return widgets;
  }
}
