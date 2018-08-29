import 'package:flutter/material.dart';
import '../widgets/BookImageWidget.dart';
import '../widgets/DrawerWidget.dart';
import '../blocs/AppStateProvider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = AppStateProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Pleasure of Allah'),
      ),
      body: GridView.count(
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
      ),
      drawer: DrawerWidget(bloc),
    );
  }
}
