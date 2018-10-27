import 'dart:async';

import 'package:flutter/material.dart';
import '../blocs/AppStateProvider.dart';
import '../blocs/models/AsyncData.dart';
import '../widgets/LoadingWidget.dart';
import '../widgets/BookImageWidget.dart';
import '../widgets/DrawerWidget.dart';

class HomePage extends StatelessWidget {
  bool isRedirected = false;
  Future<void> redirect(BuildContext context) async {
    new Future.delayed(const Duration(milliseconds: 100), () {
      print('redirected....');
      Navigator.pushReplacementNamed(context, '/book');
    });
  }

  @override
  Widget build(BuildContext context) {
    var bloc = AppStateProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn Arabic'),
      ),
      body: StreamBuilder<String>(
        initialData: '',
        stream: bloc.bookBloc.lessonInfo,
        builder: (_, snapshot) {
          if (snapshot.data.isNotEmpty && !bloc.homePage) {
            if (!isRedirected) {              
              isRedirected = true;
              redirect(context);
            }            
            return LoadingWidget(AsyncData(asyncStatus: AsyncStatus.loading));
          }
          return GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.all(10.0),
            childAspectRatio: 7.0 / 9.0,
            // TODO: Build a grid of cards (102)
            children: <Widget>[
              BookImageWidget(bloc, 'book1'),
              BookImageWidget(bloc, 'book2'),
              BookImageWidget(bloc, 'book3'),
              BookImageWidget(bloc, 'book4'),
              BookImageWidget(bloc, 'book5'),
              BookImageWidget(bloc, 'book6'),
            ],
          );
        },
      ),
      drawer: DrawerWidget(bloc),
    );
  }
}
