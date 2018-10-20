import 'dart:async';
import 'package:meta/meta.dart';
import './models/Bookmarks.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './StateMgmtBloc.dart';
import './models/BookInfo.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import './models/AsyncData.dart';


class BookBloc {  
  int selectedLessonIndex = -1;
  int currentPage = 0;
  int totalPage = 0;
  int totalLesson = 0;
  String _bookPath = '';
  BookMarks _bm;
  bool tts=false;
  final StateMgmtBloc rootBloc;
  final _bookNameController = BehaviorSubject<String>();
  final _pageIndexController = BehaviorSubject<int>();
  final _lessonIndexController = BehaviorSubject<int>();
  final _bookmarksController = BehaviorSubject<bool>(seedValue: false);
  final _selectedWord = PublishSubject<JWord>();
  final _totalPageController = BehaviorSubject<int>();

  BookBloc({@required this.rootBloc}) {
    syncWithPref();        
  }
  

  Function(bool) get bookMarkAction => _bookmarksController.sink.add;
  Function(String) get bookNameAction => _bookNameController.sink.add;
  Function(int) get pageIndexAction => _pageIndexController.sink.add;
  Function(int) get lessonIndexAction => _lessonIndexController.sink.add;

  Stream<int> get totalPageStream => _totalPageController.stream;
  Stream<bool> get bookMarkStream => _bookmarksController.stream;
  Stream<JWord> get selectedWord => _selectedWord.stream;
  Stream<String> get lessonInfo => _lessonIndexController.map((index) =>
      index >= 0 ? 'Lesson $index page $currentPage was reading' : '');

  Stream<bool> get hasPrev => _pageIndexController.map((index) => index > 1);
  Stream<bool> get hasNext =>
      _pageIndexController.map((index) => index < totalPage);
  Stream<String> get pageTitle => Observable.combineLatest2(
      _lessonIndexController,
      _pageIndexController,
      (a, b) => 'Lesson$a - Page $b of $totalPage');
  Stream<String> get bookName => _bookNameController
      .map((name) => 'Book ${name.substring(name.length - 1)}');
  Stream<AsyncData<BookInfo>> get bookInfo =>
      _bookNameController.distinct().flatMap((path) {
        if (_bookPath != path) {
          _bookPath = path;
          selectedLessonIndex = -1;
          lessonIndexAction(-1);
        }
        return Observable.fromFuture(_loadBookInfo(path))
            .map((data) => AsyncData.loaded(data))
            .onErrorReturn(AsyncData.error('Insha Allah, coming soon!'))
            .startWith(AsyncData.loading());
      });

  Stream<AsyncData<JPage>> get pageData =>
      _pageIndexController.flatMap((index) {
        var path = '$_bookPath/lesson$selectedLessonIndex/page$index.json';
        setData<String>(_bookPath, _bookName);
        setData<int>(selectedLessonIndex, _lessonIndex);
        setData<int>(index, _pageIndex);

        print(path);
        return Observable.fromFuture(_loadPageData(path))
            .map((data) => AsyncData.loaded(data))
            .onErrorReturn(AsyncData.error('Insha Allah, coming soon!'))
            .startWith(AsyncData.loading());
      });

  Future<JPage> _loadPageData(String path) {
    return rootBundle.loadString('assets$path').then((data) {
      const JsonCodec json = const JsonCodec();
      var res = JPage.fromJson(json.decode(data));
      return res;
    });
  }

  Future<BookInfo> _loadBookInfo(String path) {
    return rootBundle.loadString('assets$path/info.json').then((data) {
      const JsonCodec json = const JsonCodec();
      var res = BookInfo.fromJson(json.decode(data));
      totalLesson = res.lessons;
      setData(totalLesson, _totalLesson);
      return res;
    });
  }

  Future<int> _getTotalPage(String path) {
    print(path);
    return rootBundle.loadString('assets$path/info.json').then((data) {
      const JsonCodec json = const JsonCodec();
      var res = json.decode(data)['pages'] as int;
      print('totalPage:' + res.toString());
      return res;
    });
  }

  moveToLesson(int index) async {
    selectedLessonIndex = index;
    currentPage = 0;
    totalPage = await _getTotalPage('$_bookPath/lesson$selectedLessonIndex');
    print('totalPage: $totalPage');
    _totalPageController.sink.add(totalPage);
    lessonIndexAction(index);
    pageIndexAction(0);
    bookMarkAction(false);
  }

  moveToPage(int index) async {
    currentPage = index;
    pageIndexAction(currentPage);
    findBookMark();
  }

  prev() {
    if (currentPage > 1) {
      currentPage--;
      pageIndexAction(currentPage);
      setData<int>(currentPage, _pageIndex);
      findBookMark();
    } else {
      if (selectedLessonIndex > 1) {
        selectedLessonIndex--;
        autoLessonChange(true);
      }
    }
  }

  next() {
    if (currentPage < totalPage) {
      currentPage++;
      pageIndexAction(currentPage);
      setData<int>(currentPage, _pageIndex);
      findBookMark();
    } else if (selectedLessonIndex < totalLesson) {
      selectedLessonIndex++;
      autoLessonChange();
    }
  }

  autoLessonChange([bool isPrev = false]) async {
    totalPage = await _getTotalPage('$_bookPath/lesson$selectedLessonIndex');
    if (isPrev) {
      currentPage = totalPage;
    } else
      currentPage = 1;
    pageIndexAction(currentPage);
    lessonIndexAction(selectedLessonIndex);
    setData<int>(currentPage, _pageIndex);
    findBookMark();
  }

  dispose() {
    _bookNameController.close();
    _pageIndexController.close();
    _lessonIndexController.close();
    _bookmarksController.close();
    _selectedWord.close();
    _totalPageController.close();
    
  }

  selectWord(JWord word) {
    _selectedWord.sink.add(word);
  }

  Future<T> loadData<T>(String key, T defaultValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.get(key) as T) ?? defaultValue;
  }

  void setData<T>(T value, String key) {
    SharedPreferences.getInstance().then((prefs) {
      if (value is int) prefs.setInt(key, value);
      else if (value is String) prefs.setString(key, value);
      else if (value is bool) prefs.setBool(key, value);
    });
  }

  void syncWithPref() async {
    String bmData = await loadData<String>(_bookMarks, '');
    if (bmData.isNotEmpty) {
      _bm = BookMarks.fromStr(bmData);
    } else {
      _bm = BookMarks();
    }
    tts=await loadData<bool>(_tts, false);
    totalLesson = await loadData<int>(_totalLesson, 10);
    String bookName = await loadData<String>(_bookName, '');
    int lesson = await loadData<int>(_lessonIndex, -1);
    int page = await loadData<int>(_pageIndex, -1);
    if (bookName.isNotEmpty) {
      _bookPath = bookName;
      bookNameAction(bookName);
    }
    if (lesson != -1) {
      selectedLessonIndex = lesson;
      lessonIndexAction(lesson);
    }
    if (page != -1) {
      currentPage = page;
      pageIndexAction(page);
      totalPage = await _getTotalPage('$_bookPath/lesson$selectedLessonIndex');
      findBookMark();
    }
  }

  void findBookMark() {
    bookMarkAction(_bm.find(
        int.parse(_bookPath.substring(5)), selectedLessonIndex, currentPage));
  }

  void bookMark() {
    bookMarkAction(_bm.add(
        int.parse(_bookPath.substring(5)), selectedLessonIndex, currentPage));
    setData(BookMarks.getJson(_bm), _bookMarks);
  }

  List<BMBook> get books => _bm.bids..sort((a, b) => a.id - b.id);
  openBookMark(int book, int lesson, int page) async {
    _bookPath = '/book$book';
    selectedLessonIndex = lesson;
    currentPage = page;
    totalPage = await _getTotalPage('$_bookPath/lesson$selectedLessonIndex');
    bookNameAction(_bookPath);
    lessonIndexAction(lesson);
    pageIndexAction(page);
    findBookMark();
  }
  setTTS(bool value){
    tts=value;
    setData(value, _tts);
  }
  static const String _bookName = 'bookName';
  static const String _lessonIndex = 'lessonIndex';
  static const String _pageIndex = 'pageIndex';
  static const String _bookMarks = '#BM#';
  static const String _totalLesson = '#tl#';
  static const String _tts = '#tts#';
}
