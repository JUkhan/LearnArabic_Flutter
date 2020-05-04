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
  @override
  Widget build(BuildContext context) {
    print('------------------ansWidget---------------');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: _getWigets(widget.line),
    );
  }

  List<Widget> _getWigets(JLine line) {
    List<Widget> widgets = List<Widget>();
    widgets.add(RaisedButton(
      child: const Text('Ans'),
      color: _isHidden ? Colors.blue : Colors.red,
      onPressed: () {
        setState(() {
          _isHidden = !_isHidden;
        });
      },
    ));
    if (!_isHidden) {
      widgets.add(Divider(
        color: Colors.blue,
        height: 25.0,
      ));
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
