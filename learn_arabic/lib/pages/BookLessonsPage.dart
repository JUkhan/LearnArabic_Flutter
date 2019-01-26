import 'package:flutter/material.dart';
import '../blocs/AppStateProvider.dart';
import '../blocs/models/BookInfo.dart';
import '../widgets/DrawerWidget.dart';
import '../blocs/StateMgmtBloc.dart';
import '../widgets/LoadingWidget.dart';
import '../widgets/JErrorWidget.dart';
import '../blocs/models/AsyncData.dart';

class BookLessonsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = AppStateProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lessons'),
      ),
      body: StreamBuilder<AsyncData<BookInfo>>(
        initialData: AsyncData.loading(),
        stream: bloc.bookBloc.bookInfo,
        builder: (_, snapshot) {
          return Container(
            child:Stack(
              children: <Widget>[
                LoadingWidget(snapshot.data),
                JErrorWidget(snapshot.data),
                LessonWidget(bloc, snapshot.data)

              ],
            ) ,
            );
        },
      ),
      drawer: DrawerWidget(bloc),
    );
  }

}

class LessonWidget extends StatelessWidget {
  final StateMgmtBloc bloc;
  final AsyncData book;
  LessonWidget(this.bloc, this.book);
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: book.asyncStatus==AsyncStatus.loaded?1.0:0.0,
      duration: const Duration(milliseconds: 1000),
      child: ListView.builder(
        itemCount: book.data?.lessons??0,
        itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                child: Text('${index+1}',),
              ) ,
              title: Text('Lesson ${index+1}'),
              trailing: Icon(Icons.arrow_forward),
              selected: bloc.bookBloc.selectedLessonIndex==index+1,
              onTap: (){
                bloc.bookBloc.moveToLesson(index+1);                
                Navigator.pushReplacementNamed(context, '/page');
              },
            ),
      ),
    );
  }
}
