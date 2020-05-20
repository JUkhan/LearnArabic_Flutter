import 'dart:async';

import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';
import 'package:learn_arabic/blocs/appService.dart';
import 'package:learn_arabic/blocs/models/AsyncData.dart';
import 'package:learn_arabic/blocs/models/BookInfo.dart';
import 'package:learn_arabic/blocs/models/Bookmarks.dart';
import 'package:learn_arabic/blocs/models/MemoModel.dart';
import 'package:learn_arabic/blocs/models/bookModel.dart';
import 'package:learn_arabic/blocs/util.dart';
import 'package:rxdart/rxdart.dart';

class BookEffects extends BaseEffect {
  Stream<Action> effectForChangeBookName(Actions action$, Store store$) {
    return action$
        .whereType(ActionTypes.CHANGE_BOOK_NAME)
        .flatMap((action) =>
            Stream.fromFuture(AppService.loadBookInfo(action.payload)))
        .map((data) => Action(
            type: ActionTypes.LOOD_BOOKInfo, payload: AsyncData.loaded(data)))
        .doOnError((error, stacktrace) {
      dispatch(ActionTypes.LOOD_BOOKInfo,
          AsyncData.error('Insha Allah, coming soon!', data: BookInfo()));
    });
  }

  Stream<Action> effectForSetLessonNo(Actions action$, Store store$) {
    return action$
        .whereType(ActionTypes.SET_LESSON_NO)
        .withLatestFrom<BookModel, String>(
            store$.select('book'), (a, b) => '${b.bookPath}/lesson${a.payload}')
        .flatMap((path) => Stream.fromFuture(AppService.getTotalPage(path)))
        .map((data) => Action(type: ActionTypes.SET_TOTAL_PAGE, payload: data));
  }

  Stream<Action> effectForSetPageNo(Actions action$, Store store$) {
    return action$
        .whereType(ActionTypes.SET_PAGE_No)
        .map((action) {
          dispatch(ActionTypes.SET_PAGE_DATA,
              AsyncData.loading(data: JPage(lines: [], videos: [])));
          return action;
        })
        .withLatestFrom<BookModel, String>(store$.select('book'),
            (a, b) => '${b.bookPath}/lesson${b.lessonIndex}/page${a.payload}')
        .flatMap((path) => Stream.fromFuture(AppService.loadPageData(path)))
        .map((data) => Action(
            type: ActionTypes.SET_PAGE_DATA, payload: AsyncData.loaded(data)))
        .doOnError((error, stacktrace) {
          dispatch(
              ActionTypes.SET_PAGE_DATA,
              AsyncData.error('Insha Allah, coming soon!',
                  data: JPage(lines: [], videos: [])));
        });
  }

  Stream<Action> effectForSlidePage(Actions action$, Store store$) {
    return action$
        .whereType(ActionTypes.SLIDE_PAGE)
        .withLatestFrom<BookModel, Map<String, dynamic>>(
            store$.select('book'), (a, b) => {'book': b, 'isPrev': a.payload})
        .flatMap((map) =>
            Stream.fromFuture(calculatePageMove(map['book'], map['isPrev'])))
        .map((data) => Action(
            type: ActionTypes.SET_PAGE_DATA, payload: AsyncData.loaded(data)))
        .doOnError((error, stacktrace) {
      dispatch(
          ActionTypes.SET_PAGE_DATA,
          AsyncData.error('Insha Allah, coming soon!',
              data: JPage(lines: [], videos: [])));
    });
  }

  Stream<Action> effectForAddBookmark(Actions action$, Store store$) {
    return action$
        .whereType(ActionTypes.ADD_BOOKMARK)
        .withLatestFrom<BookModel, BookModel>(
            store$.select('book'), (a, b) => b)
        .flatMap((book) {
      AppService.saveInPref(book.bm.toJson(), AppService.prefkey_bookMarks);
      return Stream.empty();
    });
  }

  Stream<Action> effectForInit(Actions action$, Store store$) {
    return action$
        .whereType(ActionTypes.INIT)
        .flatMap((book) => Stream.fromFuture(syncWithPref(BookModel())))
        .map((data) =>
            Action(type: ActionTypes.SYNC_WITH_PREFERENCE, payload: data))
        .doOnError((error, stacktrace) {
      print(error.toString());
    });
  }

  Stream<Action> effectForBookMerkToDiffBook(Actions action$, Store store$) {
    return action$
        .whereType(ActionTypes.BOOK_MARK_DIFF_BOOK)
        .withLatestFrom<BookModel, Map<String, dynamic>>(
            store$.select('book'), (a, b) => {'book': b, 'payload': a.payload})
        .flatMap((map) =>
            Stream.fromFuture(loadBookInfo(map['payload'], map['book'])))
        .map((book) => Action(
            type: ActionTypes.SYNC_WITH_PREFERENCE, payload: {'book': book}))
        .doOnError((error, stacktrace) {
      print(error.toString());
    });
  }

  List<Stream<Action>> registerEffects(Actions action$, Store store$) {
    return [
      effectForChangeBookName(action$, store$),
      effectForSetLessonNo(action$, store$),
      effectForSetPageNo(action$, store$),
      effectForSlidePage(action$, store$),
      effectForInit(action$, store$),
      effectForAddBookmark(action$, store$),
      effectForBookMerkToDiffBook(action$, store$)
    ];
  }

  Future<BookModel> loadBookInfo(payload, BookModel bmodel) async {
    bmodel.bookPath = '/book${payload[0]}';
    BookInfo bookInfo = await AppService.loadBookInfo(bmodel.bookPath);
    bmodel.totalLesson = bookInfo.lessons;
    bmodel.pageIndex = payload[1];
    bmodel.lessonIndex = payload[2];
    bmodel.totalPage = await AppService.getTotalPage(
        '${bmodel.bookPath}/lesson${bmodel.lessonIndex}');
    bmodel.pageData = AsyncData.loaded(await AppService.loadPageData(
        '${bmodel.bookPath}/lesson${bmodel.lessonIndex}/page${bmodel.pageIndex}'));
    return BookModel.clone(bmodel);
  }

  Future<Map<String, dynamic>> syncWithPref(BookModel book) async {
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

    var wordIndex =
        await AppService.getFromPref<String>(AppService.prefkey_wordIndex, '');

    var _scrollOffset = (await AppService.getFromPref<String>(
            AppService.prefkey_scrollOffset, '0.0-00'))
        .split('-');
    var fontSize =
        await AppService.getFromPref<double>(AppService.prefkey_fontSize, 1.0);
    var wordSpace =
        await AppService.getFromPref<double>(AppService.prefkey_wordSpace, 1.0);
    var tts = await AppService.getFromPref<bool>(AppService.prefkey_tts, false);

    int theme =
        await AppService.getFromPref<int>(AppService.prefkey_theme, 4278228616);

    var isLandscape =
        await AppService.getFromPref<bool>(AppService.prefkey_landscape, false);
    var videoId =
        await AppService.getFromPref<String>(AppService.prefkey_videoid, '');
    Util.setDeviceOrientation(isLandscape);
    var vtp = (await AppService.getFromPref<String>(
            AppService.prefkey_less_ran_times, '0-0.0'))
        .split('-');

    var lc = await AppService.getFromPref<int>(ActionTypes.LECTURE_CATEGORY, 1);
    var wmc =
        await AppService.getFromPref<int>(ActionTypes.WORDMEANING_CATEGORY, 1);
    Util.wordMeanCategory = wmc;
    Util.isFirstRender = true;
    //print('-----------------------book-effects-----------------');
    //print('lc=$lc and wmc=$wmc');
    return {
      'book': book,
      'memo': MemoModel(
          wordIndex: wordIndex,
          scrollOffset: double.parse(_scrollOffset[0]),
          pageIndexPerScroll: _scrollOffset[1],
          fontSize: fontSize,
          wordSpace: wordSpace,
          tts: tts,
          theme: theme,
          isLandscape: isLandscape,
          lessRanSeconds: double.parse(vtp[0]),
          videoProgress: double.parse(vtp[1]),
          lectureCategory: lc,
          wordMeaningCategory: wmc,
          videoId: videoId)
    };
  }

  Future<JPage> calculatePageMove(BookModel book, bool isPerv) async {
    if (isPerv) {
      await prev(book);
    } else {
      await next(book);
    }

    AppService.saveInPref(book.pageIndex, AppService.prefkey_pageIndex);
    AppService.saveInPref(book.lessonIndex, AppService.prefkey_lessonIndex);
    dispatch(ActionTypes.CHANGE_AFTER_PAGE_CALCULATION, book);
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
