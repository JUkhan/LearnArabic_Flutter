import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';
import 'package:learn_arabic/blocs/models/Bookmarks.dart';
import 'package:learn_arabic/blocs/models/bookModel.dart';
import 'package:learn_arabic/widgets/DrawerWidget.dart';

class BookMarkPage extends StatefulWidget {
  @override
  _BookMarkPageState createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: DrawerWidget(),
        appBar: AppBar(
          title: const Text('Bookmarks'),
        ),
        body: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 1000),
          child: StreamBuilder(
            stream: select<BookModel>('book'),
            builder: (BuildContext context, AsyncSnapshot<BookModel> snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: _getItems(snapshot.data.books, context),
                );
              }
              return Container();
            },
          ),
        ));
  }

  List<Widget> _getItems(List<BMBook> books, BuildContext context) {
    var items = List<Widget>();
    for (var book in books) {
      items.add(ListTile(
        selected: true,
        title: Text('Book ${book.id}'),
      ));
      for (var lesson in book.lessons) {
        for (var page in lesson.pages) {
          items.add(ListTile(
            leading: CircleAvatar(
              child: Text(
                '${lesson.id}',
              ),
            ),
            title: Text('Lesson ${lesson.id}'),
            subtitle: Text('Page $page'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              dispatch(ActionTypes.BOOK_MARK_TO_PAGE, [lesson.id, page]);
              Navigator.pushReplacementNamed(context, '/book');
            },
          ));
        }
      }
    }
    return items;
  }
}
