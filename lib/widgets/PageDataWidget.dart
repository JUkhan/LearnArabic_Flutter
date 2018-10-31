import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../blocs/util.dart';
import '../pages/BookPage.dart';
import './SlideRoute.dart';
import '../blocs/models/AsyncData.dart';
import '../blocs/models/BookInfo.dart';
import '../blocs/StateMgmtBloc.dart';
import '../blocs/SettingBloc.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PageDataWidget extends StatefulWidget {
  final AsyncData<JPage> page;
  final StateMgmtBloc bloc;

  PageDataWidget(this.bloc, this.page);
  @override
  _ViewPageDataWidgetState createState() => new _ViewPageDataWidgetState();
}

class _ViewPageDataWidgetState extends State<PageDataWidget> {
  final _gestureList = List<TapGestureRecognizer>();
  ScrollController _scrollController;
  JWord _selectedWord;  
  BuildContext _context;
  FlutterTts flutterTts;
  int _gestureCounter = 0;
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
    '٢٢'
  ];
  var wordSpace='';
  @override
  void initState() {
    super.initState();  
    _scrollController=ScrollController();  
    Util.initId();
    if(widget.bloc.bookBloc.tts){   
      flutterTts = FlutterTts();
      initTts();
    }
    wordSpace=widget.bloc.settingBloc.wordSpace;    
  }
  initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.7);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.5);    
  }

  @override
  void dispose() {       
    _gestureList.forEach((ges) => ges.dispose());
    _gestureList.clear();
    
    if(flutterTts!=null){
      flutterTts.stop();      
    }    
    _scrollController?.dispose();
    super.dispose();    
  }
  _speak(String text) async {
     await flutterTts.speak(text); 
     setState(() {});   
  }
  
  _getGesture(JWord word) {
    if (_gestureCounter < _gestureList.length) {
      var temp =  _gestureList[_gestureCounter];
      
      /*temp.onTap = () {
        widget.bloc.bookBloc.selectWord(word);
        _selectedWord = word;
        if(!_isArabic(word.english) && widget.bloc.bookBloc.tts) _speak(word.english);
        else setState(() {});
      };*/
      _gestureCounter++;
      return temp;
    }
    var temp = TapGestureRecognizer();
    temp.onTap = () {
      _selectWord(word);      
      if(!_isArabic(word.english) && widget.bloc.bookBloc.tts) _speak(word.english);
      else setState(() {});
    };
    _gestureList.add(temp);
    _gestureCounter++;
    return temp;
  }
  _selectWord(JWord word){
    widget.bloc.bookBloc.selectWord(word);
    _selectedWord = word;  
    if(_scrollController.offset>0.0){
     widget.bloc.bookBloc.setOffset(_scrollController.offset);
    }
  }
  double startPx;
  bool _hasPage;
  _dragStart(DragStartDetails details) {    
    startPx=details.globalPosition.dx;
    _hasPage = false;    
  }

  _dragUpdate(DragUpdateDetails details) {
    if (_hasPage == false) {      
      double dx=details.globalPosition.dx;
      if (startPx<dx&&(dx-startPx)>100) {
        _hasPage = true;
        Navigator.pushReplacement(
            context,
            SlideRoute(
                widget: BookPage(), sildeDirection: SlideDirection.Right));
        widget.bloc.bookBloc.prev();
      } else if(startPx>dx&&(startPx-dx)>100) {
        _hasPage = true;
        Navigator.pushReplacement(
            context,
            SlideRoute(
                widget: BookPage(), sildeDirection: SlideDirection.Left));
        widget.bloc.bookBloc.next();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _gestureCounter = 0;
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
    /*return AnimatedOpacity(
      opacity: widget.page.asyncStatus == AsyncStatus.loaded ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: GestureDetector(
        child: ListView(
          children: _getListItem(widget.page.data),
        ),
        onHorizontalDragStart: _dragStart,
        onHorizontalDragUpdate: _dragUpdate,
      ),
    );*/
  }
  Future<Null> _launchUrl( String url) async {    
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
     Util.alert(context:context, message: 'Could not launch $url');
    }
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
      if((v.id==null ||v.id.isEmpty) && v.title.isNotEmpty){
        list.add(_getLessonMode(JLine(height: 45.0,words:[JWord(word: v.title, english:"")])));
      }
      else{
        list.add(Card(
          child: ListTile(
            leading: Icon(Icons.play_circle_filled),
            title: Text(v.title),
            onTap:(){_launchUrl('https://youtube.com/embed/${v.id}');},            
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
        case 'text': list.add(_getText(line));break;
        default:
          list.add(_getReadAndWrite(line));
      }
    });
    return list;
  }

  Widget _getQA(JLine line, [double padding = 10.0]) {
    var widgets = List<Widget>();
    if (line.words.length > 0) {
      widgets.add(RichText(
        textDirection: _getDirection('ltr'),
        text: TextSpan(
            children: line.words
                .where((d) => d.direction == 'ltr')
                .map((word) => _getTextSpan(word, word.direction))
                .toList()),
      ));
      widgets.add(RichText(
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
      if(line.lineno==1){
      spans.add(TextSpan(
          text: _nums[lineNo] + ')' + wordSpace,
          style: widget.bloc.settingBloc.getTextTheme(_context, 'ltr')));
      }
      //before
      if (line.mode == 'b') {
        spans.add(TextSpan(
            text: '..........' + wordSpace,
            style: widget.bloc.settingBloc
                .getTextTheme(_context, line.direction)));
      }
      spans.addAll(
          l.words.map((word) => _getTextSpan(word, line.direction)).toList());

      //after
      if (line.mode == 'a') {
        spans.add(TextSpan(
            text: '............',
            style: widget.bloc.settingBloc
                .getTextTheme(_context, line.direction)));
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
            style: Theme.of(_context).textTheme.title,
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
              style: Theme.of(_context).textTheme.title,
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
    final fontSize = widget.bloc.settingBloc.getFontSize();
    if (fontSize == 3.0) return height + height * 0.10;
    if (fontSize == 4.0) return height + height * 0.35;
    return height;
  }

  Widget _getVocabMode(JLine line) {
    var children = List<Widget>();
    int i = 0, l = line.words.length;

    do {
      var rc = List<Widget>();
      rc.add(RichText(
        textDirection: _getDirection(line.direction),
        text: _getTextSpan(line.words[i], line.direction),
      ));
      i++;
      if (i < l) {
        rc.add(RichText(
          textDirection: _getDirection(line.direction),
          text: _getTextSpan(line.words[i], line.direction),
        ));
      }
      i++;
      children.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: rc,
      ));
      if(line.height==1.0) children.add(Divider());
    } while (i < l);
    return Column(
      children: children,
    );
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
          case 'text': return _getText(line);
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
  
  TextSpan _textSpan({String text, dynamic recognizer, bool hasColor=true, bool hasWordSpac=false}){         
      return TextSpan(
            recognizer: recognizer,
            text:hasWordSpac? text + wordSpace:text,
            style: hasColor? TextStyle(color: Util.getColor(text)):null);
  }
  
  TextSpan _getTextSpan(JWord word, String direction) {
    if(word.english.isNotEmpty){      
      if(_selectedWord==null && widget.bloc.bookBloc.hasSelectedWord(word.id)){
        _selectWord(word);
        if(widget.bloc.bookBloc.scrollOffset>0.0)
        _scrollController.animateTo(widget.bloc.bookBloc.scrollOffset, duration: new Duration(seconds: 2), curve: Curves.ease);
        
      }
    }
    final txtSpans = List<TextSpan>();
    if(direction == 'rtl' && !_isArabic(word.word))direction='ltr';
    var gesture = word.english.isNotEmpty  ? _getGesture(word) : null;
    if (word.sp != null) {
      int len = word.sp.length;
      if (len == 1) {
        txtSpans.add(_textSpan(recognizer: gesture, text: word.word.substring(0, word.sp[0]), hasColor: false));
        txtSpans.add(_textSpan(
            recognizer: gesture,
            text: word.word.substring(word.sp[0]),
            hasWordSpac: true));
      } else {
        int i = 0, pairIndex;
        bool isFirst = true;
        if(word.sp[0]>0)
        txtSpans.add(_textSpan(recognizer: gesture, text: word.word.substring(0, word.sp[0]), hasColor: false));
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
            if (word.sp[pairIndex] == word.sp[i] && i+1<len) {
              txtSpans.add(_textSpan(
                  recognizer: gesture,
                  text: word.word.substring(word.sp[i], word.sp[i + 1]),
                  ));
              pairIndex = i + 1;
              i += 2;
            } else {
              txtSpans.add(_textSpan(
                  recognizer: gesture,hasColor: false,
                  text: word.word.substring(word.sp[pairIndex], word.sp[i])));
              if (len % 2 == 0||i+1<len)
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
              recognizer: gesture, hasWordSpac: true,hasColor: false,
              text: word.word.substring(word.sp[pairIndex])));
        }
      }
    } else {
      txtSpans.add(_textSpan(recognizer: gesture, text: word.word , hasWordSpac: true, hasColor: false));
    }
    //Colors.grey[400]:Colors.black.withOpacity(0.9)
    return TextSpan(
        style: word == _selectedWord
            ? widget.bloc.settingBloc
                .getTextTheme(_context, direction)
                .copyWith(                  
                   background: Paint()                   
                   ..blendMode=widget.bloc.settingBloc.theme == Themes.light?BlendMode.darken:BlendMode.color
                   ..color=widget.bloc.settingBloc.theme == Themes.light?Colors.lime[400]:Colors.purple[400]
                   )
            : widget.bloc.settingBloc.getTextTheme(_context, direction),
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
      child:RichText(
        textDirection: _getDirection(line.direction),
        text: TextSpan(
            children: line.words
                .map((word) => _getTextSpan(word, line.direction))
                .toList()),
      ),
    );
  }

  bool _isArabic(String str){
    if(str.trim().isEmpty)return false;
    return str.codeUnitAt(0)>1000;
  }

  LinearGradient _getGradient() => LinearGradient(
        //begin: Alignment.centerRight, 
        //end: Alignment.centerLeft, 
       begin: FractionalOffset.topCenter,
       end: FractionalOffset.bottomCenter,        
        stops: [ 0.1, 0.9],
        colors: [          
          Colors.pink.withOpacity(0.4),
          Colors.pink.withOpacity(0.7)
        ],
      );

  LinearGradient _getGradient2() => LinearGradient(
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
}
