import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';
import 'package:learn_arabic/blocs/appService.dart';
import 'package:learn_arabic/blocs/models/Bookmarks.dart';
import 'package:learn_arabic/blocs/models/bookModel.dart';
import 'package:learn_arabic/blocs/util.dart';

class BookState extends BaseState<BookModel> {
  BookState() : super(name: 'book', initialState: BookModel());

  Stream<BookModel> mapActionToState(BookModel state, Action action) async* {
    switch (action.type) {
      case ActionTypes.CHANGE_BOOK_NAME:
        state.bookPath = action.payload;
        yield BookModel.clone(state);
        break;
      case ActionTypes.LOOD_BOOKInfo:
        state.lessons = action.payload;
        state.totalLesson = state.lessons.data.lessons;
        yield BookModel.clone(state);
        break;
      case ActionTypes.SET_LESSON_NO:
        state.lessonIndex = action.payload;
        state.pageIndex = 0;
        AppService.saveInPref(action.payload, AppService.prefkey_lessonIndex);
        AppService.saveInPref(1, AppService.prefkey_pageIndex);
        yield BookModel.clone(state);
        break;
      case ActionTypes.SET_TOTAL_PAGE:
        state.totalPage = action.payload;
        yield BookModel.clone(state);
        break;
      case ActionTypes.SET_PAGE_No:
        state.pageIndex = action.payload;
        AppService.saveInPref(action.payload, AppService.prefkey_pageIndex);
        yield BookModel.clone(state);
        break;
      case ActionTypes.SET_PAGE_DATA:
        state.pageData = action.payload;
        yield BookModel.clone(state);
        break;
      case ActionTypes.SYNC_WITH_PREFERENCE:
        yield action.payload['book'];
        break;
      case ActionTypes.CHANGE_AFTER_PAGE_CALCULATION:
        yield BookModel.clone(action.payload);
        break;
      case ActionTypes.ADD_BOOKMARK:
        state.addBookMark();
        AppService.saveInPref(
            BookMarks.getJson(state.bm), AppService.prefkey_bookMarks);
        yield BookModel.clone(state);
        break;

      case ActionTypes.BOOK_MARK_TO_PAGE:
        state.lessonIndex = action.payload[0];
        state.pageIndex = action.payload[1];
        yield BookModel.clone(state);
        break;

      default:
        yield latestState(this);
    }
  }
}
