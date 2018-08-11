import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../widgets/VideoPlay.dart';
import '../blocs/models/AsyncData.dart';
import '../blocs/models/BookInfo.dart';
import '../blocs/StateMgmtBloc.dart';
import '../blocs/SettingBloc.dart';

class PageDataWidget extends StatefulWidget {
  final AsyncData<JPage> page;
  final StateMgmtBloc bloc;

  PageDataWidget(this.bloc, this.page);
  @override
  _ViewPageDataWidgetState createState() => new _ViewPageDataWidgetState();
}

class _ViewPageDataWidgetState extends State<PageDataWidget> {
  final _gestureList = List<TapGestureRecognizer>();
  static const String WORD_SPACE = '  ';
  BuildContext _context;
  int _gestureCounter = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    print('dispose all recognizers');
    _gestureList.forEach((ges) => ges.dispose());
    super.dispose();
  }

  _getGesture(JWord word) {
    if (_gestureCounter < _gestureList.length) {
      final temp = _gestureList[_gestureCounter];
      temp.onTap = () {
        widget.bloc.bookBloc.selectWord(word);
      };
      _gestureCounter++;
      return temp;
    }
    final temp = TapGestureRecognizer();
    temp.onTap = () {
      widget.bloc.bookBloc.selectWord(word);
    };
    _gestureList.add(temp);
    _gestureCounter++;
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    _gestureCounter = 0;
    _context = context;

    return AnimatedOpacity(
      opacity: widget.page.asyncStatus == AsyncStatus.loaded ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      child: ListView(
        children: _getListItem(widget.page.data),
      ),
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
    page.videos.forEach((v) {
      list.add(Card(
        child: ListTile(
          leading: Icon(Icons.play_circle_filled),
          title: Text(v.title),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => VideoPlay(
                    title: v.title,
                    videoId: v.id,
                  ))),
        ),
      ));
    });
    page.lines.forEach((line) {
      switch (line.mode) {
        case 'img-sentence':
          list.add(_getImgSentence(line));
          break;
        case 'read-and-write':
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
        default:
      }
    });
    return list;
  }

  double _getHeight(double height) {
    final fontSize = widget.bloc.settingBloc.getFontSize();
    if (fontSize == 3.0) return height + height * 0.10;
    if (fontSize == 4.0) return height + height * 0.35;
    return height;
  }
  Widget _getVocabMode(JLine line){
    return Expanded(child:  GridView.count(  
  crossAxisCount: 2,  
  children: List.generate(line.words.length, (index) {
    print(line.words[index].word+'-->');
    return Center(
      child: Text(
        'بَيْتٌ',//line.words[index].word,
         textDirection: _getDirection(line.direction),
        style:widget.bloc.settingBloc.getTextTheme(_context, line.direction) ,
      ),
    );
  }),
));
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
    if (line.words.length > 0 ) {
      list.add(Divider());
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
          padding: const EdgeInsets.all(10.0),
      child: Column(
        children: list,
      )
    ));
  }

  Widget _getLessonMode(JLine line) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      height: _getHeight(line.height),
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: widget.bloc.settingBloc.theme == Themes.light
              ? _getGradient()
              : _getGradient2()),
      child: Center(
        child: RichText(
          textDirection: _getDirection(line.direction),
          text: TextSpan(
              style: Theme.of(_context).textTheme.title,
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

  TextSpan _getTextSpan(JWord word, String direction) {
    final txtSpans = List<TextSpan>();
    if (word.hasStartSubstr > 0) {
      txtSpans.add(TextSpan(
          text: word.word.substring(0, word.hasStartSubstr),
          style: TextStyle(color: Colors.pinkAccent)));
    }
    txtSpans.add(TextSpan(
      recognizer: direction == 'rtl' ? _getGesture(word) : null,
      text: word.word.substring(
              word.hasStartSubstr, word.word.length - word.hasEndSubstr) +
          (word.hasEndSubstr > 0 ? '' : WORD_SPACE),
    ));
    if (word.hasEndSubstr > 0) {
      txtSpans.add(TextSpan(
          text: word.word.substring(word.word.length - word.hasEndSubstr) +
              WORD_SPACE,
          style: TextStyle(color: Colors.redAccent)));
    }

    return TextSpan(
        style: widget.bloc.settingBloc.getTextTheme(_context, direction),
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
    if (line.words.length > 0 || line.lines.length > 0) {
      list.add(Divider());
    }
    return Container(
      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 5.0),
      child: Column(
        children: list,
      ),
    );
  }

  Widget _getReadAndWrite(JLine line) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
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
        end: Alignment.topRight,
        begin: Alignment.bottomLeft,
        stops: [0.1, 0.5, 0.7, 0.9],
        colors: [
          Colors.amber[800],
          Colors.amber[700],
          Colors.amber[600],
          Colors.amber[400],
        ],
      );

  LinearGradient _getGradient2() => LinearGradient(
        end: Alignment.topRight,
        begin: Alignment.bottomLeft,
        stops: [0.1, 0.5, 0.7, 0.9],
        colors: [
          Colors.indigo[800],
          Colors.indigo[700],
          Colors.indigo[600],
          Colors.indigo[400],
        ],
      );
}
