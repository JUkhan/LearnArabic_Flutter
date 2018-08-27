import 'package:flutter/material.dart';
import '../blocs/StateMgmtBloc.dart';
import '../widgets/DrawerWidget.dart';
import '../blocs/AppStateProvider.dart';

class BookMarkPage extends StatefulWidget {
  @override
  _BookMarkPageState createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = AppStateProvider.of(context);

    return Scaffold(
        drawer: DrawerWidget(bloc),
        appBar: AppBar(
          title: const Text('Bookmarks'),
        ),
        body: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 1000),
          child: ListView(
            children: _getItems(bloc, context),
          ),
        ));
  }

  List<Widget> _getItems(StateMgmtBloc bloc, BuildContext context) {
    var items = List<Widget>();
    for (var book in bloc.bookBloc.books) {
      items.add(ListTile(selected: true, title: Text('Book ${book.id}'),));
      for (var lesson in book.lessons) {
        for (var page in lesson.pages) {
          items.add(ListTile(
            leading: CircleAvatar(
                child: Text('${lesson.id}',),
              ) ,
              title: Text('Lesson ${lesson.id}'),
              subtitle: Text('Page $page'),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){
                //print('Book${book.id}, lesson${lesson.id}, page$page');
                bloc.bookBloc.openBookMark(book.id, lesson.id, page);
                Navigator.pushReplacementNamed(context, '/book');
              },
          ));
        }
        
      }
    }
    return items;
  }
}
