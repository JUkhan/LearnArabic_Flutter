import 'dart:async';
import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';
import 'package:learn_arabic/blocs/models/BookInfo.dart';
import 'package:learn_arabic/blocs/models/MemoModel.dart';
import 'package:learn_arabic/blocs/models/PainterModel.dart';
import 'package:learn_arabic/blocs/models/bookModel.dart';
import 'package:learn_arabic/pages/BookPage.dart';
import 'package:learn_arabic/widgets/TextWidget.dart';

class Util {
  static int wordMeanCategory = 1;
  static Color getColor(String text) {
    Color color;
    switch (text) {
      case 'وَ':
        color = Colors.green[600];
        break;
      case 'أَ':
      case 'أ':
        color = Colors.blue[600];
        break;
      case 'الْ':
      case 'ال':
      case 'اَلْ':
      case 'لْ':
      case 'ل':
        color = Colors.cyan[600];
        break;

      case 'فِي':
      case 'لَ':
      case 'لِ':
      case 'بِ':
        color = Colors.purple[600];
        break;

      case 'هِ':
      case 'كِ':
      case 'هُمْ':
      case 'هُنَّ':
      case 'كَ':
      case 'هُ':
      case 'هَا':
      case 'ي':
      //subject/doer
      case 'نَ':
      case 'تَ':
      case 'تِ':
      case 'تُ':
      case 'نَا':
      case 'وا':
        color = Colors.indigo[600];
        break;

      default:
        color = Colors.orange[600];
    }
    return color;
  }

  static FlutterTts flutterTts;
  static void disposeTTS() {
    if (flutterTts != null) {
      flutterTts.stop();
      //flutterTts = null;
    }
  }

  static void initTts() async {
    if (flutterTts == null) {
      flutterTts = FlutterTts();
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      //await flutterTts.setPitch(1.5);
      flutterTts.errorHandler = (msg) {
        print('--------------$msg----------');
      };
    }
  }

  static bool isFirstRender = true;
  static String getSplitedText(String text) {
    if (wordMeanCategory == 3) return text;
    if (wordMeanCategory == 1) {
      var ss = text.replaceAll(RegExp(r'[অ-৺ং]'), '').trim();
      if (ss.endsWith(',')) {
        return ss.substring(0, ss.length - 1);
      }
      return ss;
    }
    if (wordMeanCategory == 2) {
      return text.replaceAll(RegExp(r'[a-zA-Z]'), '');
    }
    return '';
  }

  static String getText(String text) {
    switch (text) {
      case 'وَ':
        text += ' : and এবং';
        break;
      case 'أَ':
      case 'أ':
        text += ' : interrogative particle প্রশ্নোত্তর কণা';
        break;
      case 'الْ':
      case 'ال':
      case 'اَلْ':
      case 'لْ':
      case 'ل':
        text += ' - اَلْ : the টি';
        break;

      case 'لَ':
      case 'لِ':
        text += ' : for, belongs to জন্য, সম্পর্কিত';
        break;
      case 'بِ':
        text += ' : in, at মধ্যে';
        break;
      case 'فِي':
        text += ' : in মধ্যে';
        break;

      case 'كَ':
        text += ' : you/your তুমি/তোমার (masculine/পুংলিঙ্গ)';
        break;
      case 'كِ':
        text += ' : you/your তুমি/তোমার (feminine/স্ত্রীলিঙ্গ)';
        break;
      case 'هِ':
      case 'هُ':
        text += ' : him/his/it তাকে/তাহার/এটা';
        break;
      case 'هَا':
        text += ' : her তাকে/তাহার';
        break;
      case 'ي':
        text += ' : me/my আমাকে/আমার';
        break;

      case 'الَّذِي':
        text += ' : who/which কে/যাহা';
        break;
      case 'هُمْ':
        text += ' : they/their তাহারা/তাদের (masculine/পুংলিঙ্গ)';
        break;
      case 'هُنَّ':
        text += ' : they/their তাহারা/তাদের (feminine/স্ত্রীলিঙ্গ)';
        break;

      //subject/doer
      case 'نَ':
        text += ' : [subject/doer] they তাহারা (feminine/স্ত্রীলিঙ্গ)';
        break;
      case 'وا':
        text += ' : [subject/doer] they তাহারা (masculine/পুংলিঙ্গ)';
        break;
      case 'تَ':
        text += ' : [subject/doer] you তুমি (masculine/পুংলিঙ্গ)';
        break;
      case 'تِ':
        text += ' : [subject/doer] you তুমি (feminine/স্ত্রীলিঙ্গ)';
        break;
      case 'تُ':
        text += ' : [subject/doer] i আমি';
        break;
      case 'نَا':
        text += ' : [subject/doer] we আমরা';
        break;

      default:
        text += ' : under construction';
    }
    return text;
  }

  static alert({BuildContext context, String message}) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text('Info'),
                content: Text(message),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ]));
  }

  static int id = 0;
  static initId() {
    return id = 1;
  }

  static int getId() {
    id++;
    return id;
  }

  static TextStyle getTextTheme(
      BuildContext context, String direction, double _fontSize) {
    if (direction == 'ltr') {
      if (_fontSize == 1.0)
        return Theme.of(context).textTheme.subtitle1;
      else if (_fontSize == 2.0) return Theme.of(context).textTheme.headline6;
      return Theme.of(context).textTheme.headline6;
    }
    if (_fontSize == 1.0)
      return Theme.of(context).textTheme.headline6;
    else if (_fontSize == 2.0)
      return Theme.of(context).textTheme.headline5;
    else if (_fontSize == 3.0)
      return Theme.of(context).textTheme.headline4;
    else if (_fontSize == 4.0) return Theme.of(context).textTheme.headline3;

    return Theme.of(context).textTheme.headline5;
  }

  static setDeviceOrientation(bool isLandscape) {
    if (isLandscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  static bool isArabic(String str) {
    if (str.trim().isEmpty) return false;
    return str.codeUnitAt(0) > 1000;
  }

  static TextDirection getDirection(String direction) =>
      direction == 'rtl' ? TextDirection.rtl : TextDirection.ltr;

  static bool hasSelectedWord(int id, MemoModel memo, BookModel bookModel) =>
      memo?.wordIndex == getWordIndex(id, bookModel);

  static String getWordIndex(int id, BookModel bookModel) =>
      '$id${bookModel.lessonIndex}${bookModel.pageIndex}';

  static TextSpan textSpan(
          {String text,
          dynamic recognizer,
          bool hasColor = true,
          MemoModel memo,
          bool hasWordSpac = false}) =>
      TextSpan(
          recognizer: recognizer,
          text: hasWordSpac ? text + memo.getWordSpace : text,
          style: hasColor ? TextStyle(color: Util.getColor(text)) : null);

  static TextSpan getTextSpan(JWord word, String direction, MemoModel memo,
      BookModel bookModel, Function getGesture, BuildContext context) {
    if (word.english.isNotEmpty) {
      if (hasSelectedWord(word.id, memo, bookModel)) {
        if (memo.selectedWord == null) {
          dispatch(ActionTypes.SELECT_WORD_ONLY, word);
        }
      }
    }
    final txtSpans = List<TextSpan>();
    if (direction == 'rtl' && !Util.isArabic(word.word)) direction = 'ltr';
    var gesture = word.english.isNotEmpty ? getGesture(word) : null;
    if (word.sp != null) {
      int len = word.sp.length;
      if (len == 1) {
        txtSpans.add(textSpan(
            recognizer: gesture,
            text: word.word.substring(0, word.sp[0]),
            memo: memo,
            hasColor: false));
        txtSpans.add(textSpan(
            recognizer: gesture,
            text: word.word.substring(word.sp[0]),
            memo: memo,
            hasWordSpac: true));
      } else {
        int i = 0, pairIndex;
        bool isFirst = true;
        if (word.sp[0] > 0)
          txtSpans.add(textSpan(
              recognizer: gesture,
              text: word.word.substring(0, word.sp[0]),
              memo: memo,
              hasColor: false));
        do {
          if (isFirst) {
            isFirst = false;
            txtSpans.add(textSpan(
              recognizer: gesture,
              text: word.word.substring(word.sp[i], word.sp[i + 1]),
              memo: memo,
            ));
            pairIndex = i + 1;
            i += 2;
          } else {
            if (word.sp[pairIndex] == word.sp[i] && i + 1 < len) {
              txtSpans.add(textSpan(
                recognizer: gesture,
                text: word.word.substring(word.sp[i], word.sp[i + 1]),
                memo: memo,
              ));
              pairIndex = i + 1;
              i += 2;
            } else {
              txtSpans.add(textSpan(
                  recognizer: gesture,
                  hasColor: false,
                  memo: memo,
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
          txtSpans.add(textSpan(
              recognizer: gesture,
              memo: memo,
              text: word.word.substring(word.sp[len - 1]),
              hasWordSpac: true));
        } else if (i < word.word.length && pairIndex < len) {
          txtSpans.add(textSpan(
              recognizer: gesture,
              memo: memo,
              hasWordSpac: true,
              hasColor: false,
              text: word.word.substring(word.sp[pairIndex])));
        }
      }
    } else {
      txtSpans.add(textSpan(
          recognizer: gesture,
          memo: memo,
          text: word.word,
          hasWordSpac: true,
          hasColor: false));
    }

    return TextSpan(
        style: hasSelectedWord(word.id, memo, bookModel)
            ? Util.getTextTheme(context, direction, memo.fontSize).copyWith(
                shadows: [
                  Shadow(
                    color: (memo.theme == Colors.yellow.value ||
                            memo.theme == Colors.amber.value ||
                            memo.theme == Colors.lime.value ||
                            memo.theme == 4278190080)
                        ? Colors.green
                        : Colors.yellowAccent,
                    blurRadius: 10.0,
                    offset: Offset(0.0, -10.0),
                  ),
                ],
              )
            : Util.getTextTheme(context, direction, memo.fontSize),
        children: txtSpans);
  }

  static setWidget(
      List<Widget> widgets, JLine line, MemoModel memo, BookModel bookModel) {
    int lineNo = 1;

    for (var l in line.lines) {
      var spans = List<JWord>();

      //before
      if (line.mode == 'b') {
        spans.add(JWord(english: '', word: '..........' + memo.getWordSpace));
      }

      spans.addAll(l.words);

      //after
      if (line.mode == 'a') {
        spans.add(JWord(english: '', word: '..........'));
      }

      widgets.add(TextWidget(
        line: l.copyWith(words: spans),
        lineNo: lineNo,
        memo: memo,
        bookModel: bookModel,
      ));
      widgets.add(Divider());
      lineNo++;
    }
  }

  static void showWritingBoard(
      BuildContext context, List<JLine> lines, MemoModel memo, BookModel book) {
    Timer timer;
    showDialog(
        context: context,
        builder: (bc) {
          return Container(
            padding: const EdgeInsets.only(top: 5),
            /*color: memo.theme == Colors.black.value
                ? Colors.cyan[400]
                : Colors.cyan[400],*/
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        dispatch('painterPrev');
                      },
                      child: _getMaterialButton(
                          context, Icons.navigate_before, memo.theme),
                    ),
                    GestureDetector(
                      onTap: () {
                        dispatch('painterNext');
                      },
                      child: _getMaterialButton(
                          context, Icons.navigate_next, memo.theme),
                    ),
                    GestureDetector(
                      onTap: () {
                        dispatch('clearOffset');
                      },
                      child: _getMaterialButton(
                          context, Icons.clear_all, memo.theme),
                    ),
                    GestureDetector(
                      onTapDown: (h) {
                        if (timer != null && timer.isActive) {
                          timer.cancel();
                        }
                        timer = Timer.periodic(Duration(milliseconds: 50), (t) {
                          dispatch('popOffset');
                        });
                      },
                      onTapUp: (details) {
                        timer.cancel();
                        dispatch('addOffset', null);
                      },
                      child: _getMaterialButton(
                          context, Icons.keyboard_backspace, memo.theme),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: _getMaterialButton(
                            context, Icons.close, memo.theme)),
                  ],
                ),
                Divider(
                  color: Theme.of(context).backgroundColor,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  color: memo.theme == Colors.black.value
                      ? Colors.grey[800]
                      : Colors.black12,
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: StreamBuilder<int>(
                        initialData: 0,
                        stream: select<PainterModel>('painter')
                            .map((event) => event.currentIndex),
                        builder: (context, snapshot) {
                          return lines == null
                              ? Container()
                              : TextWidget(
                                  line: lines[snapshot.data],
                                  memo: memo,
                                  bookModel: book,
                                );
                        }),
                  ),
                ),
                Divider(
                  color: Theme.of(context).backgroundColor,
                ),
                Expanded(
                  child: GestureDetector(
                    onPanUpdate: (DragUpdateDetails details) {
                      RenderBox obj = context.findRenderObject();
                      var offset = obj.globalToLocal(details.globalPosition);
                      dispatch('addOffset', offset.translate(0, -80));
                    },
                    onPanEnd: (DragEndDetails details) {
                      dispatch('addOffset', null);
                    },
                    child: StreamBuilder<PainterModel>(
                        initialData: PainterModel.init(),
                        stream: select('painter'),
                        builder: (context, snapshot) {
                          return CustomPaint(
                            painter: Painter(snapshot.data),
                            size: Size.infinite,
                          );
                        }),
                  ),
                ),
              ],
            ),
          );
        });
  }

  static Material _getMaterialButton(
      BuildContext context, IconData icon, int theme) {
    return Material(
      elevation: 4.0,
      shape: const CircleBorder(),
      child: CircleAvatar(
        radius: 45.0 / 2,
        backgroundColor: Theme.of(context).backgroundColor,
        child: Icon(icon,
            color: theme == Colors.black.value ? Colors.white : Colors.black),
      ),
    );
  }
}

const List<Color> materialColors = const <Color>[
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
  Colors.black
];
