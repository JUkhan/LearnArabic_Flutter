import 'dart:async';

import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';
import 'package:learn_arabic/blocs/appService.dart';
import 'package:learn_arabic/blocs/models/AsyncData.dart';
import 'package:learn_arabic/blocs/models/BookInfo.dart';
import 'package:learn_arabic/blocs/models/Bookmarks.dart';
import 'package:learn_arabic/blocs/models/bookModel.dart';
import 'package:learn_arabic/blocs/util.dart';
import 'package:rxdart/rxdart.dart';

class BookEffects extends BaseEffect {
  Observable<Action> effectForChangeBookName(Actions action$, Store store$) {
    return action$
        .ofType(ActionTypes.CHANGE_BOOK_NAME)
        .flatMap((action) =>
            Observable.fromFuture(AppService.loadBookInfo(action.payload)))
        .map((data) => Action(
            type: ActionTypes.LOOD_BOOKInfo, payload: AsyncData.loaded(data)))
        .doOnError((error, stacktrace) {
      dispatch(
          actionType: ActionTypes.LOOD_BOOKInfo,
          payload:
              AsyncData.error('Insha Allah, coming soon!', data: BookInfo()));
    });
  }

  Observable<Action> effectForSetLessonNo(Actions action$, Store store$) {
    return action$
        .ofType(ActionTypes.SET_LESSON_NO)
        .withLatestFrom<BookModel, String>(
            store$.select('book'), (a, b) => '${b.bookPath}/lesson${a.payload}')
        .flatMap((path) => Observable.fromFuture(AppService.getTotalPage(path)))
        .map((data) => Action(type: ActionTypes.SET_TOTAL_PAGE, payload: data));
  }

  Observable<Action> effectForSetPageNo(Actions action$, Store store$) {
    return action$
        .ofType(ActionTypes.SET_PAGE_No)
        .map((action) {
          dispatch(
              actionType: ActionTypes.SET_PAGE_DATA,
              payload: AsyncData.loading(data: JPage(lines: [], videos: [])));
          return action;
        })
        .withLatestFrom<BookModel, String>(store$.select('book'),
            (a, b) => '${b.bookPath}/lesson${b.lessonIndex}/page${a.payload}')
        .flatMap((path) => Observable.fromFuture(AppService.loadPageData(path)))
        .map((data) => Action(
            type: ActionTypes.SET_PAGE_DATA, payload: AsyncData.loaded(data)))
        .doOnError((error, stacktrace) {
          dispatch(
              actionType: ActionTypes.SET_PAGE_DATA,
              payload: AsyncData.error('Insha Allah, coming soon!',
                  data: JPage(lines: [], videos: [])));
        });
  }

  Observable<Action> effectForSlidePage(Actions action$, Store store$) {
    return action$
        .ofType(ActionTypes.SLIDE_PAGE)
        .withLatestFrom<BookModel, Map<String, dynamic>>(
            store$.select('book'), (a, b) => {'book': b, 'isPrev': a.payload})
        .flatMap((map) => Observable.fromFuture(
            calculatePageMove(map['book'], map['isPrev'])))
        .map((data) => Action(
            type: ActionTypes.SET_PAGE_DATA, payload: AsyncData.loaded(data)))
        .doOnError((error, stacktrace) {
      dispatch(
          actionType: ActionTypes.SET_PAGE_DATA,
          payload: AsyncData.error('Insha Allah, coming soon!',
              data: JPage(lines: [], videos: [])));
    });
  }

  Observable<Action> effectForAddBookmark(Actions action$, Store store$) {
    return action$
        .ofType(ActionTypes.ADD_BOOKMARK)
        .withLatestFrom<BookModel, BookModel>(
            store$.select('book'), (a, b) => b)
        .flatMap((book) {
      AppService.saveInPref(book.bm.toJson(), AppService.prefkey_bookMarks);
      return Observable.empty();
    });
  }

  Observable<Action> effectForInit(Actions action$, Store store$) {
    return action$
        .ofType(ActionTypes.INIT)
        .flatMap((book) => Observable.fromFuture(syncWithPref(BookModel())))
        .map((book) =>
            Action(type: ActionTypes.SYNC_WITH_PREFERENCE, payload: book))
        .doOnError((error, stacktrace) {
      print(error.toString());
    });
  }

  List<Observable<Action>> registerEffects(Actions action$, Store store$) {
    return [
      effectForChangeBookName(action$, store$),
      effectForSetLessonNo(action$, store$),
      effectForSetPageNo(action$, store$),
      effectForSlidePage(action$, store$),
      effectForInit(action$, store$),
      effectForAddBookmark(action$, store$),
    ];
  }

  Future<BookModel> syncWithPref(BookModel book) async {
    String bmData =
        await AppService.getFromPref<String>(AppService.prefkey_bookMarks, '');
    if (bmData.isNotEmpty) {
      book.bm = BookMarks.fromStr(bmData);
    } else {
      book.bm = BookMarks();
    }

    book.totalLesson =
        await AppService.getFromPref<int>(AppService.prefkey_totalLesson, 10);
    book.bookPath = await AppService.getFromPref<String>(
        AppService.prefkey_bookName, book.bookPath);
    book.lessonIndex = await AppService.getFromPref<int>(
        AppService.prefkey_lessonIndex, book.lessonIndex);
    int page =
        await AppService.getFromPref<int>(AppService.prefkey_pageIndex, -1);

    if (page != -1) {
      book.pageIndex = page;
      book.totalPage = await AppService.getTotalPage(
          '${book.bookPath}/lesson${book.lessonIndex}');
      book.pageData = AsyncData.loaded(await AppService.loadPageData(
          '${book.bookPath}/lesson${book.lessonIndex}/page${book.pageIndex}'));
    }
    book.wordIndex =
        await AppService.getFromPref<String>(AppService.prefkey_wordIndex, '');

    book.scrollOffset = await AppService.getFromPref<double>(
        AppService.prefkey_scrollOffset, 0.0);
    book.fontSize =
        await AppService.getFromPref<double>(AppService.prefkey_fontSize, 2.0);
    book.wordSpace =
        await AppService.getFromPref<double>(AppService.prefkey_wordSpace, 1.0);
    book.tts =
        await AppService.getFromPref<bool>(AppService.prefkey_tts, false);
    int theme = await AppService.getFromPref<int>(AppService.prefkey_theme, 0);
    book.theme = theme == 0 ? Themes.light : Themes.dark;

    return book;
  }

  Future<JPage> calculatePageMove(BookModel book, bool isPerv) async {
    if (isPerv) {
      await prev(book);
    } else {
      await next(book);
    }

    AppService.saveInPref(book.pageIndex, AppService.prefkey_pageIndex);
    AppService.saveInPref(book.lessonIndex, AppService.prefkey_lessonIndex);
    dispatch(
        actionType: ActionTypes.CHANGE_AFTER_PAGE_CALCULATION, payload: book);
    var pdata = await AppService.loadPageData(
        '${book.bookPath}/lesson${book.lessonIndex}/page${book.pageIndex}');
    return pdata;
  }

  prev(BookModel book) async {
    if (book.pageIndex > 1) {
      book.pageIndex--;
    } else if (book.lessonIndex > 1) {
      book.lessonIndex--;
      await autoLessonChange(book, true);
    }
  }

  next(BookModel book) async {
    if (book.pageIndex < book.totalPage) {
      book.pageIndex++;
    } else if (book.lessonIndex < book.totalLesson) {
      book.lessonIndex++;
      await autoLessonChange(book);
    }
  }

  autoLessonChange(BookModel book, [bool isPrev = false]) async {
    book.totalPage = await AppService.getTotalPage(
        '${book.bookPath}/lesson${book.lessonIndex}');

    if (isPrev) {
      book.pageIndex = book.totalPage;
    } else
      book.pageIndex = 1;
  }
}
