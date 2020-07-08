import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';
import 'package:learn_arabic/blocs/models/BookInfo.dart';
import 'package:learn_arabic/blocs/models/MemoModel.dart';
import 'package:learn_arabic/blocs/models/bookModel.dart';
import 'package:learn_arabic/widgets/TextWidget.dart';
import 'package:learn_arabic/widgets/WritingBoardWidget.dart';

class Util {
  static int wordMeanCategory = 1;
  static Color getColor(String text) {
    Color color;
    switch (text) {
      case 'وَ':
        color = Colors.green;
        break;
      case 'أَ':
      case 'أ':
        color = Colors.blue;
        break;
      case 'الْ':
      case 'ال':
      case 'اَلْ':
      case 'لْ':
      case 'ل':
        color = Colors.cyan;
        break;

      case 'فِي':
      case 'لَ':
      case 'لِ':
      case 'بِ':
        color = Colors.lightBlue;
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
        color = Colors.orange;
        break;

      default:
        if (text.contains('عَلَ')) {
          color = Colors.lightBlue;
        } else if (text.contains('كُم') ||
            text.contains('كُن') ||
            text.contains('تُن')) {
          color = Colors.orange;
        } else
          color = Colors.red;
    }
    return color;
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
        text += ' : he/him/his/it তাকে/তাহার/এটা';
        break;
      case 'هَا':
        text += ' : she/her/it তাকে/তাহার';
        break;
      case 'ي':
        text += ' : I/me/my আমাকে/আমার';
        break;

      case 'الَّذِي':
        text += ' : who/which কে/যাহা';
        break;
      case 'هُمْ':
        text += ' : they/them/their তাহারা/তাদের (masculine/পুংলিঙ্গ)';
        break;
      case 'هُنَّ':
        text += ' : they/them/their তাহারা/তাদের (feminine/স্ত্রীলিঙ্গ)';
        break;

      //subject/doer
      case 'نَ':
        text += ' : [doer] they/them/their তাহারা (feminine/স্ত্রীলিঙ্গ)';
        break;
      case 'وا':
        text += ' : [doer] they/them/their তাহারা (masculine/পুংলিঙ্গ)';
        break;
      case 'تَ':
        text += ' : [doer] you/your তুমি (masculine/পুংলিঙ্গ)';
        break;
      case 'تِ':
        text += ' : [doer] you/your তুমি (feminine/স্ত্রীলিঙ্গ)';
        break;
      case 'تُ':
        text += ' : [doer] i/me/my আমি';
        break;
      case 'نَا':
        text += ' : [doer] we/us/our আমরা';
        break;

      default:
        if (text.contains('عَلَ'))
          text += ' : on';
        else if (text.contains('كُم')) {
          text += ' : you/your plural (masculine)';
        } else if (text.contains('كُن') || text.contains('تُن')) {
          text += ' : you/your plural (masculine)';
        } else
          text += ' : under construction';
    }
    return text;
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
      ss = ss
          .replaceFirst(' / ', ' ')
          .replaceFirst(' /', ' ')
          .replaceFirst('/)', ')');
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
    return !str.contains(RegExp(r'[a-zA-Z]'));
  }

  static TextDirection getDirection(String str) =>
      isArabic(str) ? TextDirection.rtl : TextDirection.ltr;

  static bool hasSelectedWord(int id, MemoModel memo, BookModel bookModel) =>
      memo?.wordIndex == getWordIndex(id, bookModel);

  static String getWordIndex(int id, BookModel bookModel) =>
      '$id${bookModel.lessonIndex}${bookModel.pageIndex}';

  static TextSpan textSpan({
    String text,
    dynamic recognizer,
    bool hasColor = true,
    //MemoModel memo,
    //bool hasWordSpac = false
  }) =>
      TextSpan(
          recognizer: recognizer,
          //text: hasWordSpac ? text + memo.getWordSpace : text,
          text: text,
          style: hasColor ? TextStyle(color: Util.getColor(text)) : null);

  static TextSpan getTextSpan(JWord word, MemoModel memo, BookModel bookModel,
      Function getGesture, BuildContext context) {
    if (word.english.isNotEmpty) {
      if (hasSelectedWord(word.id, memo, bookModel)) {
        if (memo.selectedWord == null) {
          dispatch(ActionTypes.SELECT_WORD_ONLY, memo.selectedWord ?? word);
        }
      }
    }
    final txtSpans = List<TextSpan>();
    String direction = Util.isArabic(word.word) ? 'rtl' : 'ltr';
    var gesture = word.english.isNotEmpty ? getGesture(word) : null;
    if (word.sp != null) {
      int len = word.sp.length;
      if (len == 1) {
        txtSpans.add(textSpan(
            recognizer: gesture,
            text: word.word.substring(0, word.sp[0]),
            //memo: memo,
            hasColor: false));
        txtSpans.add(textSpan(
          recognizer: gesture,
          text: word.word.substring(word.sp[0]),
          //memo: memo,
          //hasWordSpac: true
        ));
      } else {
        int i = 0, pairIndex;
        bool isFirst = true;
        if (word.sp[0] > 0)
          txtSpans.add(textSpan(
              recognizer: gesture,
              text: word.word.substring(0, word.sp[0]),
              //memo: memo,
              hasColor: false));
        do {
          if (isFirst) {
            isFirst = false;
            txtSpans.add(textSpan(
              recognizer: gesture,
              text: word.word.substring(word.sp[i], word.sp[i + 1]),
              //memo: memo,
            ));
            pairIndex = i + 1;
            i += 2;
          } else {
            if (word.sp[pairIndex] == word.sp[i] && i + 1 < len) {
              txtSpans.add(textSpan(
                recognizer: gesture,
                text: word.word.substring(word.sp[i], word.sp[i + 1]),
                //memo: memo,
              ));
              pairIndex = i + 1;
              i += 2;
            } else {
              txtSpans.add(textSpan(
                  recognizer: gesture,
                  hasColor: false,
                  //memo: memo,
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
            //memo: memo,
            text: word.word.substring(word.sp[len - 1]),
            //hasWordSpac: true
          ));
        } else if (i < word.word.length && pairIndex < len) {
          txtSpans.add(textSpan(
              recognizer: gesture,
              //memo: memo,
              //hasWordSpac: true,
              hasColor: false,
              text: word.word.substring(word.sp[pairIndex])));
        }
      }
    } else {
      txtSpans.add(textSpan(
          recognizer: gesture,
          //memo: memo,
          text: word.word,
          //hasWordSpac: true,
          hasColor: false));
    }

    return TextSpan(
        style: hasSelectedWord(word.id, memo, bookModel)
            ? Util.getTextTheme(context, direction, memo.fontSize).copyWith(
                shadows: [
                  Shadow(
                    color: (memo.theme == Colors.yellow.value ||
                            memo.theme == Colors.amber.value ||
                            memo.theme == Colors.lime.value)
                        ? Colors.green
                        : memo.theme == 4278190080
                            ? Colors.yellow[100]
                            : Colors.yellow,
                    blurRadius: 10.0,
                    offset: Offset(0.0, -15.0),
                  ),
                ],

                foreground: Paint()
                  ..invertColors = true
                  ..color =
                      memo.theme == 4278190080 ? Colors.cyan : Colors.yellow,
                //fontWeight: FontWeight.bold,
              )
            : Util.getTextTheme(context, direction, memo.fontSize).copyWith(
                fontWeight: word.bold ? FontWeight.bold : FontWeight.normal,
                decoration: word.underlined
                    ? TextDecoration.underline
                    : TextDecoration.none,
                color: word.colord ? (Colors.red) : null,
              ),
        children: txtSpans);
  }

  static setWidget(
      List<Widget> widgets, JLine line, MemoModel memo, BookModel bookModel) {
    int lineNo = 1;

    for (var l in line.lines) {
      var spans = List<JWord>();

      //before
      if (line.mode == 'b') {
        spans.add(JWord(
            english: '',
            word: '..........' + memo.getWordSpace,
            colord: false,
            underlined: false,
            bold: false));
      }

      spans.addAll(l.words);

      //after
      if (line.mode == 'a') {
        spans.add(JWord(
            english: '',
            word: '..........',
            colord: false,
            underlined: false,
            bold: false));
      }

      widgets.add(TextWidget(
        line: l.copyWith(words: spans),
        lineNo: line.lineno == 0 ? null : lineNo,
        memo: memo,
        bookModel: bookModel,
      ));
      widgets.add(Divider());
      lineNo++;
    }
  }

  static void showWritingBoard(
      BuildContext context, List<JLine> lines, MemoModel memo, BookModel book) {
    List<Color> colors = materialColors.sublist(0)..add(Colors.white);
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (bc) {
          return WritingBoardWidget(
              colors: colors, memo: memo, lines: lines, book: book);
        });
  }

  static Row getWritingBoardComp(List<JLine> lines, JLine line,
      BuildContext context, MemoModel memo, BookModel book) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FloatingActionButton(
          heroTag: 'tag-${line.hashCode}',
          mini: true,
          tooltip: 'Writing Board',
          child: Icon(Icons.edit),
          onPressed: () {
            dispatch('painterLines', lines?.length ?? 0);
            Util.showWritingBoard(context, lines, memo, book);
          },
        ),
        line.words[0].word.length > 30
            ? Expanded(
                child: Center(
                  child: TextWidget(
                    line: line,
                    memo: memo,
                    bookModel: book,
                  ),
                ),
              )
            : TextWidget(
                line: line,
                memo: memo,
                bookModel: book,
              )
      ],
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
