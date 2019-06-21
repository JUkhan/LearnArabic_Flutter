import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';
import 'package:learn_arabic/blocs/models/bookModel.dart';
import 'package:learn_arabic/widgets/DrawerWidget.dart';

class Pages extends StatelessWidget {
  final pageTitle$ =
      store().select<BookModel>('book').map((book) => book.pageTitle);
  final totalPage$ =
      store().select<BookModel>('book').map((book) => book.totalPage);
  @override
  Widget build(BuildContext context) {
    //final bloc = AppStateProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
          initialData: 'Pages',
          //stream: bloc.bookBloc.pageTitle,
          stream: pageTitle$,
          builder: (_, snapshot) => Text(snapshot.data),
        ),
      ),
      body: StreamBuilder<int>(
        initialData: 0,
        //stream: bloc.bookBloc.totalPageStream,
        stream: totalPage$,
        builder: (_, snapshot) => ListView.builder(
              itemCount: snapshot.data,
              itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        '${index + 1}',
                      ),
                    ),
                    title: Text('Page ${index + 1}'),
                    trailing: Icon(Icons.arrow_forward),
                    //selected: bloc.bookBloc.selectedLessonIndex==index+1,
                    onTap: () {
                      //bloc.bookBloc.moveToPage(index + 1);
                      dispatch(
                          actionType: ActionTypes.SET_PAGE_No,
                          payload: index + 1);
                      Navigator.pushReplacementNamed(context, '/book');
                    },
                  ),
            ),
      ),
      drawer: DrawerWidget(),
    );
  }
}
