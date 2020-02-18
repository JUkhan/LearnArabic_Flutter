import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';
import 'package:learn_arabic/blocs/appService.dart';
import 'package:learn_arabic/blocs/models/Bookmarks.dart';
import 'package:learn_arabic/blocs/models/bookModel.dart';

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
        yield BookModel.clone(state);
        break;
      case ActionTypes.SET_TOTAL_PAGE:
        state.totalPage = action.payload;
        yield BookModel.clone(state);
        break;
      case ActionTypes.SET_PAGE_No:
        state.pageIndex = action.payload;
        yield BookModel.clone(state);
        break;
      case ActionTypes.SET_PAGE_DATA:
        state.pageData = action.payload;
        yield BookModel.clone(state);
        break;
      case ActionTypes.SYNC_WITH_PREFERENCE:
        yield action.payload;
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
      case ActionTypes.SELECT_WORD:
        state.wordIndex =
            '${action.payload['word'].id}${state.lessonIndex}${state.pageIndex}';
        state.scrollOffset = action.payload['offset'];
        state.selectedWord = action.payload['word'];
        AppService.saveInPref<String>(
            state.wordIndex, AppService.prefkey_wordIndex);
        AppService.saveInPref<double>(
            state.scrollOffset, AppService.prefkey_scrollOffset);
        yield BookModel.clone(state);
        break;
      case ActionTypes.SET_WORDSPACE:
        state.wordSpace = action.payload;
        AppService.saveInPref(state.wordSpace, AppService.prefkey_wordSpace);
        yield BookModel.clone(state);
        break;
      case ActionTypes.SET_FONTSIZE:
        state.fontSize = action.payload;
        AppService.saveInPref(state.fontSize, AppService.prefkey_fontSize);
        yield BookModel.clone(state);
        break;
      case ActionTypes.SET_TTS:
        state.tts = action.payload;
        AppService.saveInPref(state.tts, AppService.prefkey_tts);
        yield BookModel.clone(state);
        break;
      case ActionTypes.SET_LANDSCAPE:
        state.isLandscape = action.payload;
        AppService.saveInPref(state.isLandscape, AppService.prefkey_landscape);
        yield BookModel.clone(state);
        break;
      case ActionTypes.SET_THEME:
        state.theme = action.payload;
        AppService.saveInPref(state.theme.index, AppService.prefkey_theme);
        yield BookModel.clone(state);
        break;
      case ActionTypes.BOOK_MARK_TO_PAGE:
        state.lessonIndex = action.payload[0];
        state.pageIndex = action.payload[1];
        yield BookModel.clone(state);
        break;
      case ActionTypes.SET_VIDEO_ID:
        state.videoId = action.payload;
        AppService.saveInPref(state.videoId, AppService.prefkey_videoid);
        yield BookModel.clone(state);
        break;
      default:
        yield state;
    }
  }
}
