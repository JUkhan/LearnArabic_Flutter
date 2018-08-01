
import 'package:flutter/material.dart';
import '../widgets/DrawerWidget.dart';
import '../blocs/AppStateProvider.dart';

class HomePage extends StatelessWidget  {
  @override
  Widget build(BuildContext context) {
    final block=AppStateProvider.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Pleasure of Allah'),),
      body: Container(child: Text('Home page'),),
      drawer: DrawerWidget(block),
    );
  }

  
}