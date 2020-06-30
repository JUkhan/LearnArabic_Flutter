import 'dart:async';

import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';
import 'package:learn_arabic/blocs/models/AsyncData.dart';

import 'package:learn_arabic/blocs/models/BookInfo.dart';
import 'package:learn_arabic/blocs/models/MemoModel.dart';
import 'package:learn_arabic/blocs/models/bookModel.dart';
import 'package:learn_arabic/blocs/util.dart';
import 'package:learn_arabic/widgets/DrawerWidget.dart';
import 'package:learn_arabic/widgets/JErrorWidget.dart';
import 'package:learn_arabic/widgets/LoadingWidget.dart';
import 'package:learn_arabic/widgets/NavBarWidget.dart';
import 'package:learn_arabic/widgets/PageDataWidget.dart';

Stream<BookModel> _book$ = select<BookModel>('book');

class BookPage extends StatelessWidget {
  //static Stream<BookModel> _book$ = select<BookModel>('book');
  final pageTitle$ = _book$.map((book) => book.pageTitle);
  final pageData$ = _book$.map((book) => book.pageData);
  final bookMark$ = _book$.map((book) => book.hasBookMark);
  final theme$ = select<MemoModel>('memo').map((memo) => memo.theme);
  void bookMarkHandler() {
    dispatch(ActionTypes.ADD_BOOKMARK);
  }

  @override
  Widget build(BuildContext context) {
    //final bloc = AppStateProvider.of(context);
    return Scaffold(
      appBar: new AppBar(
        title: StreamBuilder<String>(
          initialData: 'Learn Arabic',
          //stream: bloc.bookBloc.pageTitle,
          stream: pageTitle$,
          builder: (_, snapshot) => Text(snapshot.data),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Writing Board',
            icon: Icon(Icons.edit),
            onPressed: () {
              dispatch('painterLines', 0);
              Util.showWritingBoard(
                  context, null, MemoModel.init(), BookModel());
            },
          ),
          IconButton(
              onPressed: bookMarkHandler,
              tooltip: 'Toggle Book Marks',
              icon: StreamBuilder<bool>(
                initialData: false,
                stream: bookMark$,
                builder: (_, snapshot) => Icon(
                  Icons.star,
                  color: snapshot.data ? Colors.pink[400] : null,
                ),
              ))
        ], //Icon(Icons.star, color: Colors.pink[400],),)],
      ),
      body: StreamBuilder<AsyncData<JPage>>(
        initialData: AsyncData.loading(data: JPage(videos: [], lines: [])),
        //stream: bloc.bookBloc.pageData,
        stream: pageData$,
        builder: (_, snapshot) {
          return Container(
            child: Stack(
              children: <Widget>[
                LoadingWidget(snapshot.data),
                JErrorWidget(snapshot.data),
                PageDataWidget(snapshot.data)
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: NavBarWidget(),
      drawer: DrawerWidget(),
    );
  }
}
