import 'dart:async';

import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';
import 'package:learn_arabic/blocs/models/BookInfo.dart';
import 'package:learn_arabic/blocs/models/MemoModel.dart';
import 'package:learn_arabic/blocs/models/bookModel.dart';
import 'package:learn_arabic/blocs/util.dart';

class TextWidget extends StatefulWidget {
  final JLine line;
  final TextAlign textAlign;
  final MemoModel memo;
  final BookModel bookModel;
  final int lineNo;
  TextWidget(
      {Key key,
      this.line,
      this.bookModel,
      this.memo,
      this.textAlign,
      this.lineNo})
      : super(key: key);

  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  StreamSubscription _memoSubscription;
  MemoModel _memo;
  List<TapGestureRecognizer> _gestures;

  @override
  void initState() {
    _memo = widget.memo;
    _gestures = List<TapGestureRecognizer>();
    _memoSubscription = select<MemoModel>('memo').listen((data) {
      _memo = data;
      if (widget.line.words
              .where((w) =>
                  Util.getWordIndex(w.id, widget.bookModel) ==
                  Util.getWordIndex(
                      data?.prevSelectedWordId ?? 0, widget.bookModel))
              .length >
          0) {
        setState(() {});
      } else if (widget.line.words
              .where((w) =>
                  Util.getWordIndex(w.id, widget.bookModel) == _memo.wordIndex)
              .length >
          0) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _memoSubscription.cancel();
    _gestures.forEach((ges) {
      ges.dispose();
    });
    _gestures.clear();
    super.dispose();
  }

  String getArabicNumber(String str) {
    if (str.length == 1) {
      return '${String.fromCharCode(str.codeUnitAt(0) + 1584)}) ';
    }
    return '${String.fromCharCode(str.codeUnitAt(0) + 1584)}${String.fromCharCode(str.codeUnitAt(1) + 1584)}) ';
  }

  @override
  Widget build(BuildContext context) {
    return widget.lineNo != null
        ? Row(
            children: <Widget>[
              Expanded(
                child: RichText(
                  textAlign: widget.textAlign ?? TextAlign.start,
                  textDirection: TextDirection
                      .rtl, //  Util.getDirection(widget.line.direction),
                  text: TextSpan(children: getSpansChildren(context)),
                ),
              ),
              Container(
                child: Text(
                  getArabicNumber(widget.lineNo.toString()),
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 22,
                    color: Theme.of(context).backgroundColor,
                    height: 1.9,
                  ),
                ),
              )
            ],
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: RichText(
              textAlign: widget.textAlign ?? TextAlign.start,
              textDirection: Util.getDirection(widget.line.words[0].word),
              text: TextSpan(
                  style: TextStyle(height: 1.9),
                  //text: '  ',
                  children: getSpansChildren(context)),
            ),
          );
  }

  List<TextSpan> getSpansChildren(BuildContext context) {
    var lastWord = widget.line.words.last;
    return widget.line.words
        .fold(List<JWord>(), (List<JWord> previousValue, element) {
          previousValue.add(element);
          if (element != lastWord)
            previousValue.add(JWord.empty(text: widget.memo.getWordSpace));
          return previousValue;
        })
        .map((word) => Util.getTextSpan(
            word, _memo, widget.bookModel, _getGesture, context))
        .toList();
  }

  _selectWord(JWord word) {
    dispatch(ActionTypes.SELECT_WORD, {
      'word': word,
      'wordIndex': Util.getWordIndex(word.id, widget.bookModel)
    });
  }

  _speak(String text) async {
    await Util.flutterTts.speak(text);
    //var lan = await flutterTts.getLanguages;
    //print(lan);
    setState(() {});
  }

  _getGesture(JWord word) {
    var ges = TapGestureRecognizer()
      ..onTap = () {
        _selectWord(word);
        if (!Util.isArabic(word.english) && _memo.tts) {
          _speak(word.english);
        } else
          setState(() {});
      };
    _gestures.add(ges);
    return ges;
  }
}
