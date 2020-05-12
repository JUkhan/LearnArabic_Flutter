import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/models/BookInfo.dart';
import 'package:learn_arabic/blocs/models/MemoModel.dart';
import 'package:learn_arabic/blocs/models/bookModel.dart';
import 'package:learn_arabic/blocs/util.dart';
import 'package:learn_arabic/widgets/AnsWidget.dart';

import 'TextWidget.dart';

class QaWidget extends StatefulWidget {
  final JLine line;
  final MemoModel memo;
  final BookModel bookModel;
  final double padding;
  QaWidget({Key key, this.line, this.memo, this.bookModel, this.padding})
      : super(key: key);

  @override
  _QaWidgetState createState() => _QaWidgetState();
}

class _QaWidgetState extends State<QaWidget> {
  @override
  Widget build(BuildContext context) {
    //print('-------------------qa--------------');
    return _getWidget(widget.line, widget.padding);
  }

  Widget _getWidget(JLine line, double padding) {
    var widgets = List<Widget>();
    var titleContainer = List<Widget>();
    if (line.words.length > 0) {
      titleContainer.add(TextWidget(
        line: line.copyWith(
            direction: 'ltr',
            words: line.words.where((d) => d.direction == 'ltr').toList()),
        textAlign: TextAlign.justify,
        memo: widget.memo,
        bookModel: widget.bookModel,
      ));

      titleContainer.add(TextWidget(
        line: line.copyWith(
            direction: 'rtl',
            words: line.words.where((d) => d.direction == 'rtl').toList()),
        memo: widget.memo,
        bookModel: widget.bookModel,
      ));
    }

    if (line.lines.length > 0) {
      if (line.words.length > 0) {
        widgets.add(Divider());
      }
      if (line.lines.length > 2) {
        Util.setWidget(widgets, line, widget.memo, widget.bookModel);
      } else {
        if (line.lines[0].mode != 'match' && line.lines[0].words.length > 0) {
          widgets.add(TextWidget(
            line: line.lines[0],
            memo: widget.memo,
            bookModel: widget.bookModel,
          ));
        }
        if (line.lines[0].lines.length > 0) {
          if (line.lines[0].mode == 'match') {
            widgets.add(_getMatchMode(line.lines[0]));
          } else {
            Util.setWidget(
                widgets, line.lines[0], widget.memo, widget.bookModel);
          }
        }
      }
    }
    if (line.lines.length == 2) {
      widgets.add(AnsWidget(
        line: line.lines[1],
        memo: widget.memo,
        bookModel: widget.bookModel,
      ));
    }

    if (titleContainer.length > 0) {
      titleContainer.add(Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: widgets,
      ));
      return Container(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: titleContainer,
        ),
      );
    }
    return Container(
      padding: EdgeInsets.all(widget.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: widgets,
      ),
    );
  }

  Widget _getMatchHeader(JWord word) {
    return Expanded(
        child: TextWidget(
      line: JLine(
        words: [word],
        direction: 'rtl',
      ),
      memo: widget.memo,
      bookModel: widget.bookModel,
    ));
  }

  Widget _getMatchMode(JLine line) {
    var children = List<Widget>();
    int i = 0, l = line.lines.length, count = 1;
    if (line.words.length == 2) {
      var rc = List<Widget>();
      rc.add(_getMatchHeader(line.words[0]));
      rc.add(_getMatchHeader(line.words[1]));
      children.add(Row(
        children: rc.reversed.toList(),
      ));
    } else {
      var rc = List<Widget>();
      rc.add(_getMatchHeader(JWord.empty(text: '( أ )')));
      rc.add(_getMatchHeader(JWord.empty(text: '( ب )')));
      children.add(Row(
        children: rc.reversed.toList(),
      ));
    }
    do {
      var rc = List<Widget>();
      rc.add(Expanded(
          child: TextWidget(
        line: line.lines[i],
        lineNo: count,
        memo: widget.memo,
        bookModel: widget.bookModel,
      )));
      i++;

      if (i < l) {
        rc.add(Expanded(
            child: TextWidget(
          line: line.lines[i],
          lineNo: count,
          memo: widget.memo,
          bookModel: widget.bookModel,
        )));
      }
      i++;
      count++;
      children.add(Row(
        children: rc.reversed.toList(),
      ));
      children.add(Divider());
    } while (i < l);
    return Column(
      children: children,
    );
  }
}
