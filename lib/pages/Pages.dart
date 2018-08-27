import 'package:flutter/material.dart';
import '../blocs/AppStateProvider.dart';

import '../widgets/DrawerWidget.dart';


class Pages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = AppStateProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title:StreamBuilder<String>(
          initialData: 'Pleasure of Allah',
          stream: bloc.bookBloc.pageTitle,
          builder: (_, snapshot) => Text(snapshot.data),
        ),
      ),
      body:ListView.builder(
        itemCount:bloc.bookBloc.totalPage,
        itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                child: Text('${index+1}',),
              ) ,
              title: Text('Page ${index+1}'),
              trailing: Icon(Icons.arrow_forward),
              //selected: bloc.bookBloc.selectedLessonIndex==index+1,
              onTap: (){
                bloc.bookBloc.moveToPage(index+1);                
                Navigator.pushReplacementNamed(context, '/book');
              },
            ),
      ),            
      drawer: DrawerWidget(bloc),
    );
  }

}
