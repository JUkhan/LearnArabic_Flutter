import 'dart:async';

import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';
import 'package:learn_arabic/blocs/models/AsyncData.dart';
import 'package:learn_arabic/blocs/models/BookInfo.dart';
import 'package:learn_arabic/blocs/models/MemoModel.dart';
import 'package:learn_arabic/blocs/models/bookModel.dart';

import 'package:learn_arabic/blocs/util.dart';
import 'package:learn_arabic/pages/BookPage.dart';
import 'package:learn_arabic/pages/PlayerPage.dart';
import 'package:learn_arabic/widgets/CircleWidget.dart';
import 'package:learn_arabic/widgets/QaWidget.dart';
import 'package:learn_arabic/widgets/SlideRoute.dart';
import 'package:learn_arabic/widgets/TextWidget.dart';

class PageDataWidget extends StatefulWidget {
  final AsyncData<JPage> page;
  PageDataWidget(this.page);
  @override
  _ViewPageDataWidgetState createState() => new _ViewPageDataWidgetState();
}

class _ViewPageDataWidgetState extends State<PageDataWidget> {
  ScrollController _scrollController;
  BookModel _bookModel;
  StreamSubscription _bookModelSubscription, _memoSubscription;
  MemoModel _memo;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    _bookModelSubscription = select<BookModel>('book').listen((data) {
      _bookModel = data;
    });
    _memoSubscription = select<MemoModel>('memo').listen((data) {
      _memo = data;
      if (_memo.tts && Util.flutterTts == null) {
        Util.initTts();
      }
      if (Util.isFirstRender) {
        _animateScroll();
        Util.isFirstRender = false;
      }
    });
  }

  void _animateScroll() {
    Future.delayed(Duration(seconds: 1), () {
      if (_memo.scrollOffset > 0.0 &&
          _memo.pageIndexPerScroll ==
              '${_bookModel.lessonIndex}${_bookModel.pageIndex}') {
        _scrollController?.removeListener(_scrollListener);
        _scrollController?.animateTo(_memo.scrollOffset,
            duration: new Duration(seconds: 1), curve: Curves.ease);
        Future.delayed(Duration(seconds: 1), () {
          _scrollController?.addListener(_scrollListener);
        });
      }
    });
  }

  @override
  void dispose() {
    _bookModelSubscription.cancel();
    _memoSubscription.cancel();
    _scrollController?.dispose();
    Util.disposeTTS();
    super.dispose();
  }

  _scrollListener() {
    dispatch(ActionTypes.SET_SCROLL_OFFSET, {
      'scroll': _scrollController?.offset ?? 0.0,
      'refPerScroll': '${_bookModel.lessonIndex}${_bookModel.pageIndex}'
    });
  }

  double startPx;
  bool _hasPage;
  _dragStart(DragStartDetails details) {
    startPx = details.globalPosition.dx;
    _hasPage = false;
  }

  _dragUpdate(DragUpdateDetails details) {
    if (_hasPage == false) {
      double dx = details.globalPosition.dx;
      if (startPx < dx && (dx - startPx) > 100) {
        _hasPage = true;
        Navigator.of(context)
            .pushReplacement(createRoute(BookPage(), SlideDirection.Right));
        /* Navigator.pushReplacement(
            context,
            SlideRoute(
                widget: BookPage(), sildeDirection: SlideDirection.Right));*/

        dispatch(ActionTypes.SLIDE_PAGE, true);
      } else if (startPx > dx && (startPx - dx) > 100) {
        _hasPage = true;
        Navigator.of(context)
            .pushReplacement(createRoute(BookPage(), SlideDirection.Left));
        /* Navigator.pushReplacement(
            context,
            SlideRoute(
                widget: BookPage(), sildeDirection: SlideDirection.Left));*/

        dispatch(ActionTypes.SLIDE_PAGE, false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListView(
        //scrollDirection: A,
        controller: _scrollController,
        children: _getListItem(widget.page.data),
      ),
      onHorizontalDragStart: _dragStart,
      onHorizontalDragUpdate: _dragUpdate,
    );
  }

  List<Widget> _getListItem(JPage page) {
    final list = List<Widget>();

    if (page == null) {
      return list;
    }

    if (page.title != null) {
      list.add(_getLessonMode(page.title));
    }
    List<JVideo> videos = page.videos;
    if (_bookModel?.bookName != 'Book 0' &&
        videos.length > 1 &&
        (_memo?.lectureCategory == 1 || _memo?.lectureCategory == 2)) {
      var eindex =
          page.videos.indexWhere((el) => el.title == 'English Lecture');

      if (_memo?.lectureCategory == 1 && eindex >= 0) {
        videos = eindex == -1 ? [] : page.videos.sublist(eindex);
      } else if (_memo?.lectureCategory == 2) {
        var bindex =
            page.videos.indexWhere((el) => el.title == 'Bangla Lecture');
        videos = bindex == -1
            ? []
            : eindex == -1
                ? page.videos.sublist(bindex)
                : page.videos.sublist(bindex, eindex);
      }
    }

    videos.forEach((v) {
      if ((v.id == null || v.id.isEmpty) && v.title.isNotEmpty) {
        if (_memo?.lectureCategory == 3) {
          list.add(_getLessonMode(
              JLine(words: [JWord(word: v.title, english: "")])));
        }
      } else {
        list.add(Card(
          //color: Theme.of(context).backgroundColor,
          child: ListTile(
            leading: CircleProgressWidget(
              vid: v.id,
              theme: _memo.theme,
            ),
            title: Text(v.title.toLowerCase()),
            onTap: () {
              var id = _memo.videoId;
              dispatch(ActionTypes.SET_VIDEO_ID, v.id);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PlayerPage(
                            video: v,
                            videoList: videos,
                            lessRanSeconds:
                                id == v.id ? _memo.lessRanSeconds : 0,
                          )));
            },
          ),
        ));
      }
    });
    page.lines.forEach((line) {
      switch (line.mode) {
        case 'img-sentence':
          list.add(_getImgSentence(line));
          break;
        case 'raw':
          list.add(_getReadAndWrite(line));
          break;
        case 'lesson':
          list.add(_getLessonMode(line));
          break;
        case 'padding':
          list.add(SizedBox(
            height: 45,
          ));
          break;
        case 'card':
          list.add(_getCardMode(line));
          break;
        case 'vocab':
          list.add(_getVocabMode(line));
          break;
        case 'qa':
          list.add(_getQA(line));
          break;
        case 'divider':
          list.add(Divider());
          break;
        case 'text':
          list.add(_getText(line));
          break;
        default:
          list.add(_getReadAndWrite(line));
      }
    });
    return list;
  }

  Widget _getQA(JLine line, [double padding = 10.0]) {
    return QaWidget(
      line: line,
      padding: padding,
      memo: _memo,
      bookModel: _bookModel,
    );
  }

  Widget _getVocabMode(JLine line) {
    var children = List<Widget>();
    var items = List<Widget>();

    line.words.forEach((w) {
      items.add(TextWidget(
        line: line.copyWith(words: [w]),
        memo: _memo,
        bookModel: _bookModel,
      ));
      if (items.length == 2) {
        children.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [items[0], items[1]],
        ));
        items.clear();
      }
    });
    if (items.length > 0) {
      children.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items,
      ));
    }
    return Column(children: children);
  }

  Widget _getCardMode(JLine line) {
    final list = List<Widget>();
    if (line.words.length > 0) {
      list.add(TextWidget(
        line: line,
        memo: _memo,
        bookModel: _bookModel,
      ));
    }
    if (line.words.length > 0) {
      list.add(Divider());
    }
    if (line.lines.length > 0) {
      list.addAll(line.lines.map((l) {
        switch (l.mode) {
          case 'divider':
            return Divider();
          case 'lesson':
            return _getLessonMode(l, 0.0);
          case 'qa':
            return _getQA(l, 0.0);
          case 'raw':
            return _getReadAndWrite(line, 0.0);
          case 'vocab':
            return _getVocabMode(l);
          case 'text':
            return _getText(line);
          default:
            return TextWidget(
              line: l,
              memo: _memo,
              bookModel: _bookModel,
            );
        }
      }));
    }

    return Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: list,
        ));
  }

  List<JLine> _getLines(JLine line) {
    var find = line.words.map((e) => e.word.toLowerCase()).where((element) =>
        element == 'وَاكْتُبْ' ||
        element.contains('read and write') ||
        element.contains('write the') ||
        element.contains('vocabulary'));

    if (find.length > 0) {
      var index = widget.page.data.lines.indexOf(line) + 1;
      var nextLine = widget.page.data.lines[index];
      List<JLine> lines;
      switch (nextLine.mode) {
        case 'qa':
          lines = nextLine.lines[0].lines;
          if (lines.length == 0) {
            lines = nextLine.lines;
          }
          break;
        case 'raw':
        case 'vocab':
        case "":
          lines = nextLine.words.map((e) => JLine(words: [e])).toList();
          break;
        case 'img-sentence':
          lines = widget.page.data.lines
              .sublist(index)
              .map((e) => e.lines[0])
              .toList();
          break;
        case 'card':
          lines = nextLine.lines.where((e) => e.mode != 'divider').toList();
          break;
        default:
          lines = null;
      }
      return lines;
    }
    return null;
  }

  Widget _getLessonMode(JLine line, [double padding = 10.0]) {
    Widget child;
    var lines = _getLines(line);
    if (lines != null) {
      child = Util.getWritingBoardComp(lines, line, context, _memo, _bookModel);
    } else {
      child = TextWidget(
        line: line,
        memo: _memo,
        bookModel: _bookModel,
      );
    }
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(
              padding,
              0, //Util.isArabic(line.words[0].word) ? 0 : 5,
              padding,
              2 //Util.isArabic(line.words[0].word) ? 2 : 8
              ),
          alignment: Alignment.center,
          width: double.infinity,
          color: Theme.of(context).backgroundColor,
          child: child,
        ),
        Container(
          height: 10,
        ),
      ],
    );
  }

  Widget _getImgSentence(JLine line) {
    final list = List<Widget>()..add(Image.asset('assets/images/${line.img}'));

    if (line.words.length > 0 || line.lines.length > 0) {
      list.add(Divider());
    }
    if (line.words.length > 0) {
      list.add(TextWidget(
        line: line,
        memo: _memo,
        bookModel: _bookModel,
      ));
    }
    if (line.lines.length > 0) {
      list.addAll(line.lines.map((l) => TextWidget(
            line: l,
            memo: _memo,
            bookModel: _bookModel,
          )));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          child: Container(
        padding: const EdgeInsets.only(
            top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
        child: Column(
          children: list,
        ),
      )),
    );
  }

  Widget _getText(JLine line) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        alignment: Alignment.center,
        child: TextWidget(
          line: line,
          memo: _memo,
          bookModel: _bookModel,
        ));
  }

  Widget _getReadAndWrite(JLine line, [double padding = 10.0]) {
    return Container(
        padding: EdgeInsets.all(padding),
        child: TextWidget(
          line: line,
          memo: _memo,
          bookModel: _bookModel,
        ));
  }
}
