import 'dart:async';

import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';
import 'package:learn_arabic/blocs/models/AsyncData.dart';
import 'package:learn_arabic/blocs/models/BookInfo.dart';
import 'package:learn_arabic/blocs/models/MemoModel.dart';
import 'package:learn_arabic/blocs/models/bookModel.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:learn_arabic/blocs/util.dart';
import 'package:learn_arabic/pages/BookPage.dart';
import 'package:learn_arabic/pages/PlayerPage.dart';
import 'package:learn_arabic/widgets/CircleWidget.dart';
import 'package:learn_arabic/widgets/SlideRoute.dart';

class PageDataWidget extends StatefulWidget {
  final AsyncData<JPage> page;
  //final StateMgmtBloc bloc;

  PageDataWidget(this.page);
  @override
  _ViewPageDataWidgetState createState() => new _ViewPageDataWidgetState();
}

class _ViewPageDataWidgetState extends State<PageDataWidget> {
  //final _gestureList = List<TapGestureRecognizer>();
  ScrollController _scrollController;
  //JWord _selectedWord;
  BuildContext _context;
  FlutterTts flutterTts;
  BookModel _bookModel;
  StreamSubscription _bookModelSubscription, _memoSubscription;

  //int _gestureCounter = 0;
  var _nums = [
    '٠',
    '١',
    '٢',
    '٣',
    '٤',
    '٥',
    '٦',
    '٧',
    '٨',
    '٩',
    '١٠',
    '١١',
    '١٢',
    '١٣',
    '١٤',
    '١٥',
    '١٦',
    '١٧',
    '١٨',
    '١٩',
    '٢٠',
    '٢١',
    '٢٢',
    '٢٣',
    '٢٤',
    '٢٥'
  ];
  var wordSpace = '';
  MemoModel _memo;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _bookModelSubscription = select<BookModel>('book').listen((data) {
      _bookModel = data;
    });
    _memoSubscription = select<MemoModel>('memo').listen((data) {
      _memo = data;
      wordSpace = data.getWordSpace;
      if (data.tts && flutterTts == null) {
        flutterTts = FlutterTts();
        initTts();
      }
    });
    if (Util.isFirstRender) {
      _animateScroll();
      Util.isFirstRender = false;
    }
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

  bool hasSelectedWord(int id) => _memo?.wordIndex == getWordIndex(id);

  String getWordIndex(int id) =>
      '$id${_bookModel.lessonIndex}${_bookModel.pageIndex}';

  initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.7);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.5);
  }

  @override
  void dispose() {
    _bookModelSubscription.cancel();
    _memoSubscription.cancel();

    if (flutterTts != null) {
      flutterTts.stop();
    }
    _scrollController?.dispose();
    super.dispose();
  }

  _speak(String text) async {
    await flutterTts.speak(text);
    //var lan = await flutterTts.getLanguages;
    //print(lan);
    setState(() {});
  }

  _getGesture(JWord word) {
    return TapGestureRecognizer()
      ..onTap = () {
        _selectWord(word);
        if (!Util.isArabic(word.english) && _memo.tts)
          _speak(word.english);
        else
          setState(() {});
      };
  }

  _selectWord(JWord word) {
    dispatch(ActionTypes.SELECT_WORD,
        {'word': word, 'wordIndex': getWordIndex(word.id)});
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
        Navigator.pushReplacement(
            context,
            SlideRoute(
                widget: BookPage(), sildeDirection: SlideDirection.Right));

        dispatch(ActionTypes.SLIDE_PAGE, true);
      } else if (startPx > dx && (startPx - dx) > 100) {
        _hasPage = true;
        Navigator.pushReplacement(
            context,
            SlideRoute(
                widget: BookPage(), sildeDirection: SlideDirection.Left));

        dispatch(ActionTypes.SLIDE_PAGE, false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
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
    var eindex = page.videos.indexWhere((el) => el.title == 'English Lecture');
    if (_bookModel?.bookName != 'Book 0' && videos.length > 2 && eindex > 0) {
      if (_memo?.lectureCategory == 1) {
        videos = page.videos.sublist(eindex);
      } else if (_memo?.lectureCategory == 2) {
        videos = page.videos.sublist(
            page.videos.indexWhere((el) => el.title == 'Bangla Lecture'),
            eindex);
      }
    }

    videos.forEach((v) {
      if ((v.id == null || v.id.isEmpty) && v.title.isNotEmpty) {
        list.add(_getLessonMode(
            JLine(height: 45.0, words: [JWord(word: v.title, english: "")])));
      } else {
        list.add(Card(
          child: ListTile(
            leading: CircleProgressWidget(
              vid: v.id,
              theme: _memo.theme,
            ),
            title: Text(v.title),
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
            height: line.height,
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
    var widgets = List<Widget>();
    var titleContainer = List<Widget>();
    if (line.words.length > 0) {
      titleContainer.add(RichText(
        textAlign: TextAlign.justify,
        textDirection: _getDirection('ltr'),
        text: TextSpan(
            children: line.words
                .where((d) => d.direction == 'ltr')
                .map((word) => _getTextSpan(word, word.direction))
                .toList()),
      ));
      titleContainer.add(RichText(
        textDirection: _getDirection('rtl'),
        text: TextSpan(
            children: line.words
                .where((d) => d.direction == 'rtl')
                .map((word) => _getTextSpan(word, word.direction))
                .toList()),
      ));
    }

    if (line.lines.length > 0) {
      if (line.words.length > 0) {
        widgets.add(Divider());
      }
      if (line.lines.length > 2) {
        _setWidget(widgets, line);
      } else {
        if (line.lines[0].mode != 'match' && line.lines[0].words.length > 0) {
          widgets.add(RichText(
            textDirection: _getDirection(line.lines[0].direction),
            text: TextSpan(
                children: line.lines[0].words
                    .map((word) => _getTextSpan(word, line.lines[0].direction))
                    .toList()),
          ));
        }
        if (line.lines[0].lines.length > 0) {
          if (line.lines[0].mode == 'match') {
            widgets.add(_getMatchMode(line.lines[0]));
          } else {
            _setWidget(widgets, line.lines[0]);
          }
        }
      }
    }
    if (line.lines.length == 2) {
      widgets.add(RaisedButton(
        child: const Text('Ans'),
        onPressed: () {
          line.isHide = !line.isHide;
          setState(() {});
        },
      ));
    }

    if (line.isHide) {
      widgets.add(Divider(
        color: Colors.blue,
        height: 25.0,
      ));
      if (line.lines[1] != null && line.lines[1].words.length > 0) {
        widgets.add(RichText(
          textDirection: _getDirection(line.lines[1].direction),
          text: TextSpan(
              children: line.lines[1].words
                  .map((word) => _getTextSpan(word, line.lines[1].direction))
                  .toList()),
        ));
      }

      if (line.lines[1] != null && line.lines[1].lines.length > 0) {
        _setWidget(widgets, line.lines[1]);
      }
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
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: widgets,
      ),
    );
  }

  void _setWidget(List<Widget> widgets, JLine line) {
    int lineNo = 1;

    for (var l in line.lines) {
      var spans = List<TextSpan>();
      if (line.lineno == 1) {
        spans.add(TextSpan(
            text: _nums[lineNo] + ')' + wordSpace,
            style: Util.getTextTheme(_context, 'ltr', _memo.fontSize)));
      }
      //before
      if (line.mode == 'b') {
        spans.add(TextSpan(
            text: '..........' + wordSpace,
            style:
                Util.getTextTheme(_context, line.direction, _memo.fontSize)));
      }
      spans.addAll(
          l.words.map((word) => _getTextSpan(word, line.direction)).toList());

      //after
      if (line.mode == 'a') {
        spans.add(TextSpan(
          text: '............',
          //style: widget.bloc.settingBloc.getTextTheme(_context, line.direction)
        ));
      }
      widgets.add(RichText(
        textDirection: _getDirection(line.direction),
        text: TextSpan(children: spans),
      ));
      widgets.add(Divider());
      lineNo++;
    }
  }

  Widget _getMatchHeader(JWord word) {
    return Expanded(
        child: RichText(
      maxLines: 7,
      textDirection: _getDirection('rtl'),
      text: _getTextSpan(word, 'rtl'),
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
          child: RichText(
        maxLines: 7,
        textDirection: _getDirection(line.direction),
        text: TextSpan(
            style: Theme.of(_context).textTheme.headline,
            text: '${_nums[count]}) ',
            children: line.lines[i].words
                .map((word) => _getTextSpan(word, line.direction))
                .toList()),
      )));
      i++;

      if (i < l) {
        rc.add(Expanded(
            child: RichText(
          maxLines: 7,
          textDirection: _getDirection(line.direction),
          text: TextSpan(
              style: Theme.of(_context).textTheme.headline,
              text: '${_nums[count]}) ',
              children: line.lines[i].words
                  .map((word) => _getTextSpan(word, line.direction))
                  .toList()),
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

  double _getHeight(double height) {
    final fontSize = _memo.fontSize;
    if (fontSize == 3.0) return height + height * 0.10;
    if (fontSize == 4.0) return height + height * 0.35;
    return height;
  }

  Widget _getVocabMode(JLine line) {
    var children = List<Widget>();
    int i = 0, l = line.words.length;

    do {
      var rc = List<Widget>();
      rc.add(Expanded(
          child: RichText(
        textAlign: TextAlign.center,
        textDirection: _getDirection(line.direction),
        text: _getTextSpan(line.words[i], line.direction),
      )));
      i++;
      if (i < l) {
        rc.add(Expanded(
            child: RichText(
          textAlign: TextAlign.center,
          textDirection: _getDirection(line.direction),
          text: _getTextSpan(line.words[i], line.direction),
        )));
      }
      i++;
      children.add(Row(
        children: rc,
      ));
      if (line.height == 1.0) children.add(Divider());
    } while (i < l);
    return Column(children: children);
  }

  Widget _getCardMode(JLine line) {
    final list = List<Widget>();
    if (line.words.length > 0) {
      list.add(RichText(
        textDirection: _getDirection(line.direction),
        text: TextSpan(
            children: line.words
                .map((word) => _getTextSpan(word, line.direction))
                .toList()),
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
            return RichText(
              textDirection: _getDirection(l.direction),
              text: TextSpan(
                  children: l.words
                      .map((word) => _getTextSpan(word, l.direction))
                      .toList()),
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

  Widget _getLessonMode(JLine line, [double padding = 10.0]) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding),
      height: _getHeight(line.height),
      width: double.infinity,
      decoration: BoxDecoration(
          gradient:
              _memo.theme == Themes.light ? _getGradient() : _getGradient2()),
      child: Center(
        child: RichText(
          textDirection: _getDirection(line.direction),
          text: TextSpan(
              style: Theme.of(_context).textTheme.headline,
              children: line.words
                  .map<TextSpan>((word) => _getTextSpan(word, line.direction))
                  .toList()),
        ),
      ),
    );
  }

  TextDirection _getDirection(String direction) {
    return direction == 'rtl' ? TextDirection.rtl : TextDirection.ltr;
  }

  TextSpan _textSpan(
      {String text,
      dynamic recognizer,
      bool hasColor = true,
      bool hasWordSpac = false}) {
    return TextSpan(
        recognizer: recognizer,
        text: hasWordSpac ? text + wordSpace : text,
        style: hasColor ? TextStyle(color: Util.getColor(text)) : null);
  }

  TextSpan _getTextSpan(JWord word, String direction) {
    if (word.english.isNotEmpty) {
      if (hasSelectedWord(word.id)) {
        if (_memo.selectedWord == null) {
          dispatch(ActionTypes.SELECT_WORD_ONLY, word);
        }
      }
    }
    final txtSpans = List<TextSpan>();
    if (direction == 'rtl' && !Util.isArabic(word.word)) direction = 'ltr';
    var gesture = word.english.isNotEmpty ? _getGesture(word) : null;
    if (word.sp != null) {
      int len = word.sp.length;
      if (len == 1) {
        txtSpans.add(_textSpan(
            recognizer: gesture,
            text: word.word.substring(0, word.sp[0]),
            hasColor: false));
        txtSpans.add(_textSpan(
            recognizer: gesture,
            text: word.word.substring(word.sp[0]),
            hasWordSpac: true));
      } else {
        int i = 0, pairIndex;
        bool isFirst = true;
        if (word.sp[0] > 0)
          txtSpans.add(_textSpan(
              recognizer: gesture,
              text: word.word.substring(0, word.sp[0]),
              hasColor: false));
        do {
          if (isFirst) {
            isFirst = false;
            txtSpans.add(_textSpan(
              recognizer: gesture,
              text: word.word.substring(word.sp[i], word.sp[i + 1]),
            ));
            pairIndex = i + 1;
            i += 2;
          } else {
            if (word.sp[pairIndex] == word.sp[i] && i + 1 < len) {
              txtSpans.add(_textSpan(
                recognizer: gesture,
                text: word.word.substring(word.sp[i], word.sp[i + 1]),
              ));
              pairIndex = i + 1;
              i += 2;
            } else {
              txtSpans.add(_textSpan(
                  recognizer: gesture,
                  hasColor: false,
                  text: word.word.substring(word.sp[pairIndex], word.sp[i])));
              if (len % 2 == 0 || i + 1 < len)
                isFirst = true;
              else {
                i++;
                pairIndex = i;
              }
            }
          }
        } while (i < len);
        if (len % 2 != 0) {
          txtSpans.add(_textSpan(
              recognizer: gesture,
              text: word.word.substring(word.sp[len - 1]),
              hasWordSpac: true));
        } else if (i < word.word.length && pairIndex < len) {
          txtSpans.add(_textSpan(
              recognizer: gesture,
              hasWordSpac: true,
              hasColor: false,
              text: word.word.substring(word.sp[pairIndex])));
        }
      }
    } else {
      txtSpans.add(_textSpan(
          recognizer: gesture,
          text: word.word,
          hasWordSpac: true,
          hasColor: false));
    }
    //Colors.grey[400]:Colors.black.withOpacity(0.9)
    //gesture = word.english.isNotEmpty ? _getGesture(word) : null;
    return TextSpan(
        style: hasSelectedWord(word.id)
            ? Util.getTextTheme(_context, direction, _memo.fontSize).copyWith(
                shadows: [
                  Shadow(
                    color: _memo.theme == Themes.light
                        ? Colors.yellow
                        : Colors.blue,
                    blurRadius: 10.0,
                    offset: Offset(5.0, 5.0),
                  ),
                  Shadow(
                    color: _memo.theme == Themes.light
                        ? Colors.yellowAccent
                        : Colors.yellow,
                    blurRadius: 10.0,
                    offset: Offset(-5.0, 5.0),
                  ),
                ],
              )
            : Util.getTextTheme(_context, direction, _memo.fontSize),
        children: txtSpans);
  }

  Widget _getImgSentence(JLine line) {
    final list = List<Widget>()..add(Image.asset('assets/images/${line.img}'));

    if (line.words.length > 0 || line.lines.length > 0) {
      list.add(Divider());
    }
    if (line.words.length > 0) {
      list.add(RichText(
        textDirection: _getDirection(line.direction),
        text: TextSpan(
            children: line.words
                .map((word) => _getTextSpan(word, line.direction))
                .toList()),
      ));
    }
    if (line.lines.length > 0) {
      list.addAll(line.lines.map((l) => RichText(
            textDirection: _getDirection(l.direction),
            text: TextSpan(
                children: l.words
                    .map((word) => _getTextSpan(word, l.direction))
                    .toList()),
          )));
    }
    return Card(
        child: Container(
      padding: const EdgeInsets.only(
          top: 10.0, left: 10.0, right: 5.0, bottom: 10.0),
      child: Column(
        children: list,
      ),
    ));
  }

  Widget _getText(JLine line) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Center(
            child: RichText(
          textDirection: _getDirection(line.direction),
          text: TextSpan(
              children: line.words
                  .map((word) => _getTextSpan(word, line.direction))
                  .toList()),
        )));
  }

  Widget _getReadAndWrite(JLine line, [double padding = 10.0]) {
    return Container(
      padding: EdgeInsets.all(padding),
      child: RichText(
        textDirection: _getDirection(line.direction),
        text: TextSpan(
            children: line.words
                .map((word) => _getTextSpan(word, line.direction))
                .toList()),
      ),
    );
  }

  LinearGradient _getGradient() => LinearGradient(
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter,
        stops: [0.1, 0.5, 0.7, 0.9],
        colors: [
          Colors.blue[400],
          Colors.blue[700],
          Colors.blue[600],
          Colors.blue[400]
        ],
      );
  LinearGradient _getGradient2() => LinearGradient(
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter,
        stops: [0.1, 0.5, 0.7, 0.9],
        colors: [
          Colors.black12,
          Colors.black54,
          Colors.black54,
          Colors.black26
        ],
      );
}
