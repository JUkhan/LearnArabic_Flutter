import 'package:flutter/material.dart';
import '../widgets/DrawerWidget.dart';
import '../blocs/AppStateProvider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final block = AppStateProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Pleasure of Allah'),
      ),
      body: new Container(
        height: 150.0,
        width: double.infinity,
        decoration:  BoxDecoration(
          gradient:  LinearGradient(
            end: Alignment.topRight,                                  // new
            begin: Alignment.bottomLeft,            
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [              
              Colors.indigo[800],
              Colors.indigo[700],
              Colors.indigo[600],
              Colors.indigo[400],
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
             Text('اَلدَّرْسُ اْلأَوَّلُ',
        style: Theme.of(context).textTheme.caption,
        ),
        Text('Lesson One',
        style: Theme.of(context).textTheme.title,
        ),
        Text('Lesson One',
        style: Theme.of(context).textTheme.headline,
        )
          ],
        ),
      ),
      drawer: DrawerWidget(block),
    );
  }
}
