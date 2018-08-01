import 'package:flutter/material.dart';
import '../widgets/DrawerWidget.dart';
import '../blocs/AppStateProvider.dart';
import '../blocs/StateMgmtBloc.dart';
import '../blocs/models/AsyncData.dart';
import '../blocs/models/BookInfo.dart';
import '../widgets/LoadingWidget.dart';
import '../widgets/JErrorWidget.dart';

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
                ViewPageData(bloc, snapshot.data)
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
                  onPressed: snapshot.data ?(){ 
                    bloc.bookBloc.prev();
                    Navigator.pushReplacementNamed(context, '/book');
                   }: null,
                ),
          ),
          StreamBuilder<bool>(
            initialData: false,
            stream: bloc.bookBloc.hasNext,
            builder: (_, snapshot) => IconButton(
                  tooltip: 'Next page',
                  icon: Icon(Icons.arrow_forward),
                  onPressed: snapshot.data ?(){ 
                    Navigator.pushReplacementNamed(context, '/book');
                    bloc.bookBloc.next();
                  } : null,
                ),
          ),
          Expanded(
              child: Text(
            'jasim khan test',
            textAlign: TextAlign.center,
            //style: ThemeData.dark().textTheme.body2,
            // style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontStyle: FontStyle.italic,
            //     //color: Colors.white24,
            //     //fontSize: 20.0
            //     ),
          )),
          IconButton(
              tooltip: 'Details meaning',
              icon: Icon(Icons.details),
              onPressed: () {}),
        ],
      ),
    );
  }
}

class ViewPageData extends StatelessWidget {
  final AsyncData<JPage> page;
  final StateMgmtBloc bloc;
  ViewPageData(this.bloc, this.page);
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: page.asyncStatus == AsyncStatus.loaded ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: ListView(
        children: _getListItem(page.data),
      ),
    );
  }

  List<Widget> _getListItem(JPage page) {
    final list = List<Widget>();
    if (page == null) {
      return list;
    }
    page.lines.forEach((line) {
      if ((line.words != null && line.words.length > 0)) {
        var richText = new RichText(
            maxLines: 3, text: TextSpan(text: line.words[0].word ?? ''));

        list.add(new Container(
          padding: EdgeInsets.all(20.0),
          child: richText,
        ));
      }
    });
    return list;
  }
}

//copy listView
/*var exa=ListView(
          children: <Widget>[            
           
            ListTile(
              title: Text('4Hell item'),
            ),
            ListTile(
                title: new RichText(
              //textDirection: TextDirection.rtl,
              text: new TextSpan(
                text: 'Hello ',
                style: TextStyle(color: Colors.blueGrey[400], fontSize: 20.0),
                children: <TextSpan>[
                  new TextSpan(
                      text: 'الْ', style: TextStyle(color: Colors.pink[300])),
                  new TextSpan(
                    text: 'رَّجُلُ',
                    //style: new TextStyle(fontWeight: FontWeight.bold)
                  ),
                ],
              ),
            ))
          ],
        );*/
