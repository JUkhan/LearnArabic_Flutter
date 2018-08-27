import 'package:flutter/material.dart';
import '../widgets/DrawerWidget.dart';
import '../blocs/AppStateProvider.dart';
import '../blocs/StateMgmtBloc.dart';
import '../blocs/models/AsyncData.dart';
import '../blocs/models/BookInfo.dart';
import '../widgets/LoadingWidget.dart';
import '../widgets/JErrorWidget.dart';
import '../widgets/PageDataWidget.dart';

class BookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = AppStateProvider.of(context);
    return Scaffold(
      appBar: new AppBar(
        title: StreamBuilder<String>(
          initialData: 'Pleasure of Allah',
          stream: bloc.bookBloc.pageTitle,
          builder: (_, snapshot) => Text(snapshot.data),
        ),
        actions: <Widget>[IconButton(
          onPressed: bloc.bookBloc.bookMark, 
          tooltip: 'Toggle Book Marks',         
          icon: StreamBuilder<bool>(
            initialData: false,
            stream: bloc.bookBloc.bookMarkStream,
            builder: (_, snapshot)=>Icon(Icons.star, color:snapshot.data? Colors.pink[400]:null,),
          ))], //Icon(Icons.star, color: Colors.pink[400],),)],
      ),
      body: StreamBuilder<AsyncData<JPage>>(
        initialData: AsyncData.loading(),
        stream: bloc.bookBloc.pageData,
        builder: (_, snapshot) {
          return Container(
            child: Stack(
              children: <Widget>[
                LoadingWidget(snapshot.data),
                JErrorWidget(snapshot.data),
                PageDataWidget(bloc, snapshot.data)
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _navBar(bloc, context),
      drawer: DrawerWidget(bloc),
    );
  }

  Widget _navBar(StateMgmtBloc bloc, BuildContext context) {
    return BottomAppBar(
      //color: Colors.black45,
      //elevation: 37.0,
      //hasNotch: true,
      child: Row(
        children: <Widget>[
          StreamBuilder<bool>(
            initialData: false,
            stream: bloc.bookBloc.hasPrev,
            builder: (_, snapshot) => IconButton(
                  tooltip: 'Previous page',
                  icon: Icon(
                    Icons.arrow_back,
                    //color: Colors.pink[500],
                  ),
                  onPressed: snapshot.data
                      ? () {
                          bloc.bookBloc.prev();
                          Navigator.pushReplacementNamed(context, '/book');
                        }
                      : null,
                ),
          ),
          StreamBuilder<bool>(
            initialData: false,
            stream: bloc.bookBloc.hasNext,
            builder: (_, snapshot) => IconButton(
                  tooltip: 'Next page',
                  icon: Icon(Icons.arrow_forward),
                  onPressed: snapshot.data
                      ? () {
                          Navigator.pushReplacementNamed(context, '/book');
                          bloc.bookBloc.next();
                        }
                      : null,
                ),
          ),
          Expanded(
              child: StreamBuilder<JWord>(
            initialData: JWord.empty(),
            stream: bloc.bookBloc.selectedWord,
            builder: (_, snapshot) => snapshot.data.word.isEmpty
                ? const Text('')
                : Text(
                    _getMeaning(snapshot.data),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.title,
                  ),
          )),
          StreamBuilder<JWord>(
              initialData: JWord.empty(),
              stream: bloc.bookBloc.selectedWord,
              builder: (_, snapshot) {
                if (snapshot.data.word.isNotEmpty) {
                  return IconButton(
                    tooltip: 'Details meaning',
                    icon: Icon(Icons.details),
                    onPressed: () {
                      _showBottomSheet(context, snapshot.data);
                    },
                  );
                }
                return const Text('');
              }),
        ],
      ),
    );
  }
  String _getMeaning(JWord word){
    StringBuffer buffer=StringBuffer();
    if(word.word.startsWith('الْ')||word.word.startsWith('ال')){
      buffer.write('the ');
    }
    else if(word.word.startsWith('وَالْ')|| word.word.startsWith('وَال')){
      buffer.write('and the ');
    }
    buffer.write(word.english);
    return buffer.toString();
  }
  void _showBottomSheet(BuildContext context, JWord word) {
    int ss=word.hasStartSubstr;
    int es=word.hasEndSubstr;
    var hasAl=false;
    if(ss==0){
      if(word.word.startsWith('الْ')){ ss=3; hasAl=true;}
      else if(word.word.startsWith('ال')){ss=2; hasAl=true;}
      else if(word.word.startsWith('وَالْ')){ ss=5; hasAl=true;}
      else if(word.word.startsWith('وَال')){ss=4; hasAl=true;}
    }
    if(es==0){
     //if(hasAl)es=2;
    }
    word=JWord(
      word: word.word,
      english: word.english,
      bangla: word.bangla,
      hasStartSubstr: ss,
      hasEndSubstr: es,
      wordSpace: word.wordSpace
    );
    showModalBottomSheet(
        context: context,
        builder: (bc) {
          return Container(
            //color: Colors.greenAccent,
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                RichText(
                  textDirection: TextDirection.rtl,
                  text: _getTextSpan(context, word),
                ),
                Divider(),
                _getStartSubstring(context, word),
                _getEndSubstring(context, word),
                Divider(),
                _getDetails(context, word),
              ],
            ),
          );
        });
  }
  String _getSubStringMeaning(String val){
    switch (val) {
      case 'الْ':
      case 'ال': return 'the ';
      case 'وَالْ':
      case 'وَال': return 'and the ';  
      default: return '';
    }
  }
  Widget _getStartSubstring(BuildContext context, JWord word) {
    if (word.hasStartSubstr > 0) {
      var subStr=word.word.substring(0, word.hasStartSubstr);
      return RichText(
          text: TextSpan(
              text: subStr,
              children: [TextSpan(text: ' : '+_getSubStringMeaning(subStr))],
              style: TextStyle(fontSize: 26.0, color: Colors.pinkAccent)));
    }
    return Container();
  }

  Widget _getEndSubstring(BuildContext context, JWord word) {
    if (word.hasEndSubstr > 0) {
      var subStr= word.word.substring(word.word.length - word.hasEndSubstr);
      return RichText(
          text: TextSpan(
              text:subStr,
              children: [TextSpan(text: ' : '+_getSubStringMeaning(subStr))],
              style: TextStyle(fontSize: 26.0, color: Colors.redAccent)));
    }
    return Container();
  }

  Widget _getDetails(BuildContext context, JWord word) {
    return RichText(
        text: TextSpan(
            text:_getMeaning(word), //word.word.substring(word.hasStartSubstr, word.word.length - word.hasEndSubstr),
            //children: [TextSpan(text: _getMeaning(word))],
            style: Theme.of(context).textTheme.title));
  }

  TextSpan _getTextSpan(BuildContext context, JWord word) {
    final txtSpans = List<TextSpan>();
    if (word.hasStartSubstr > 0) {
      txtSpans.add(TextSpan(
          text: word.word.substring(0, word.hasStartSubstr),
          style: TextStyle(color: Colors.pinkAccent)));
    }
    txtSpans.add(TextSpan(
      text: word.word
          .substring(word.hasStartSubstr, word.word.length - word.hasEndSubstr),
    ));
    if (word.hasEndSubstr > 0) {
      txtSpans.add(TextSpan(
          text: word.word.substring(word.word.length - word.hasEndSubstr),
          style: TextStyle(color: Colors.redAccent)));
    }

    return TextSpan(
        style: Theme.of(context).textTheme.display1, children: txtSpans);
  }
}
