import 'dart:async';

import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/models/AsyncData.dart';
import 'package:learn_arabic/blocs/models/bookModel.dart';
import 'package:learn_arabic/widgets/BookImageWidget.dart';
import 'package:learn_arabic/widgets/DrawerWidget.dart';
import 'package:learn_arabic/widgets/LoadingWidget.dart';

//bool isRedirected = false;

class HomePage extends StatelessWidget {
  static bool isFirstTime = true;

  Future<void> redirect(BuildContext context) async {
    new Future.delayed(const Duration(milliseconds: 100), () {
      isFirstTime = false;
      Navigator.pushReplacementNamed(context, '/book');
    });
  }

  @override
  Widget build(BuildContext context) {
    //var bloc = AppStateProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn Arabic'),
      ),
      body: StreamBuilder<String>(
          initialData: '',
          stream: select<BookModel>('book').map((book) => book.lessonInfo),
          builder: (_, snapshot) {
            if (snapshot.data.isNotEmpty && isFirstTime) {
              //if (!isRedirected) {
              //isRedirected = true;
              redirect(context);
              //}
              return LoadingWidget(AsyncData(asyncStatus: AsyncStatus.loading));
            }
            return GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(10.0),
              childAspectRatio: 7.0 / 9.0,
              children: <Widget>[
                BookImageWidget('book0'),
                BookImageWidget('book1'),
                BookImageWidget('book2'),
                BookImageWidget('book3'),
                BookImageWidget('book4'),
                BookImageWidget('book5'),
                BookImageWidget('book6'),
              ],
            );
          }),
      drawer: DrawerWidget(),
    );
  }
}
