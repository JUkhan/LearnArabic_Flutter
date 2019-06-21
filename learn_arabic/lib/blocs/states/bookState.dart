import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';
import 'package:learn_arabic/blocs/appService.dart';
import 'package:learn_arabic/blocs/models/Bookmarks.dart';
import 'package:learn_arabic/blocs/models/bookModel.dart';

class BookState extends BaseState<BookModel> {
  BookState() : super(name: 'book', initialState: BookModel());

  BookModel reduce(BookModel state, Action action) {
    switch (action.type) {
      case ActionTypes.CHANGE_BOOK_NAME:
        state.bookPath = action.payload;
        return BookModel.clone(state);
      case ActionTypes.LOOD_BOOKInfo:
        state.lessons = action.payload;
        state.totalLesson = state.lessons.data.lessons;
        return BookModel.clone(state);
      case ActionTypes.SET_LESSON_NO:
        state.lessonIndex = action.payload;
        state.pageIndex = 0;
        return BookModel.clone(state);
      case ActionTypes.SET_TOTAL_PAGE:
        state.totalPage = action.payload;
        return BookModel.clone(state);
      case ActionTypes.SET_PAGE_No:
        state.pageIndex = action.payload;
        return BookModel.clone(state);
      case ActionTypes.SET_PAGE_DATA:
        state.pageData = action.payload;
        return BookModel.clone(state);
      case ActionTypes.SYNC_WITH_PREFERENCE:
        return action.payload;
      case ActionTypes.CHANGE_AFTER_PAGE_CALCULATION:
        return BookModel.clone(action.payload);
      case ActionTypes.ADD_BOOKMARK:
        state.addBookMark();
        AppService.saveInPref(
            BookMarks.getJson(state.bm), AppService.prefkey_bookMarks);
        return BookModel.clone(state);
      case ActionTypes.SELECT_WORD:
        state.wordIndex =
            '${action.payload['word'].id}${state.lessonIndex}${state.pageIndex}';
        state.scrollOffset = action.payload['offset'];
        state.selectedWord = action.payload['word'];
        AppService.saveInPref<String>(
            state.wordIndex, AppService.prefkey_wordIndex);
        AppService.saveInPref<double>(
            state.scrollOffset, AppService.prefkey_scrollOffset);
        return BookModel.clone(state);
      case ActionTypes.SET_WORDSPACE:
        state.wordSpace = action.payload;
        AppService.saveInPref(state.wordSpace, AppService.prefkey_wordSpace);
        return BookModel.clone(state);
      case ActionTypes.SET_FONTSIZE:
        state.fontSize = action.payload;
        AppService.saveInPref(state.fontSize, AppService.prefkey_fontSize);
        return BookModel.clone(state);
      case ActionTypes.SET_TTS:
        state.tts = action.payload;
        AppService.saveInPref(state.tts, AppService.prefkey_tts);
        return BookModel.clone(state);
      case ActionTypes.SET_THEME:
        state.theme = action.payload;
        AppService.saveInPref(state.theme.index, AppService.prefkey_theme);
        return BookModel.clone(state);
      case ActionTypes.BOOK_MARK_TO_PAGE:
        state.lessonIndex = action.payload[0];
        state.pageIndex = action.payload[1];
        return BookModel.clone(state);
      default:
        return state;
    }
  }
}
