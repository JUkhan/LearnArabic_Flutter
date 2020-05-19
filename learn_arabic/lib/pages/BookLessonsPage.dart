import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';
import 'package:learn_arabic/blocs/models/AsyncData.dart';
import 'package:learn_arabic/blocs/models/BookInfo.dart';
import 'package:learn_arabic/blocs/models/bookModel.dart';
import 'package:learn_arabic/widgets/DrawerWidget.dart';
import 'package:learn_arabic/widgets/JErrorWidget.dart';
import 'package:learn_arabic/widgets/LoadingWidget.dart';

class BookLessonsPage extends StatelessWidget {
  final bookInfo$ = select<BookModel>('book').map((data) => data.lessons);

  @override
  Widget build(BuildContext context) {
    //final bloc = AppStateProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lessons'),
      ),
      body: StreamBuilder<AsyncData<BookInfo>>(
        initialData: AsyncData.loading(),
        //stream: bloc.bookBloc.bookInfo,
        stream: bookInfo$,
        builder: (_, snapshot) {
          return Container(
            child: Stack(
              children: <Widget>[
                LoadingWidget(snapshot.data),
                JErrorWidget(snapshot.data),
                LessonWidget(snapshot.data)
              ],
            ),
          );
        },
      ),
      drawer: DrawerWidget(),
    );
  }
}

class LessonWidget extends StatelessWidget {
  //final StateMgmtBloc bloc;
  final AsyncData book;
  LessonWidget(this.book);
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: book.asyncStatus == AsyncStatus.loaded ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      child: ListView.builder(
        itemCount: book.data?.lessons ?? 0,
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).backgroundColor,
            child: Text(
              '${index + 1}',
            ),
          ),
          title: Text('Lesson ${index + 1}'),
          trailing: Icon(Icons.arrow_forward),
          //selected: bloc.bookBloc.selectedLessonIndex == index + 1,
          onTap: () {
            //bloc.bookBloc.moveToLesson(index + 1);
            dispatch(ActionTypes.SET_LESSON_NO, index + 1);
            Navigator.pushReplacementNamed(context, '/page');
          },
        ),
      ),
    );
  }
}
