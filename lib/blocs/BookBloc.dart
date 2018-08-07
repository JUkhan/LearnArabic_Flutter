import 'dart:async';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import './StateMgmtBloc.dart';
import './models/BookInfo.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import './models/AsyncData.dart';

class BookBloc {
  int selectedLessonIndex=-1;
  int currentPage=0;
  int totalPage=0;
  String _bookPath='';
  final StateMgmtBloc rootBloc;
  final _bookNameController = BehaviorSubject<String>();
  final _pageIndexController = BehaviorSubject<int>();
  final _lessonIndexController=BehaviorSubject<int>();
  final _selectedWord=PublishSubject<JWord>();

  BookBloc({@required this.rootBloc});

  Function(String) get bookNameAction    => _bookNameController.sink.add;
  Function(int)    get pageIndexAction  => _pageIndexController.sink.add;
  Function(int)    get lessonIndexAction => _lessonIndexController.sink.add;

  Stream<JWord> get selectedWord=>_selectedWord.stream;
  Stream<String> get lessonInfo=>_lessonIndexController
  .map((index)=> index>=0?'Lesson $index was reading':'');

  Stream<bool> get hasPrev=>_pageIndexController.map((index)=>index>1);
  Stream<bool> get hasNext=>_pageIndexController.map((index)=>index<totalPage);
  Stream<String> get pageTitle=>Observable.combineLatest2(_lessonIndexController, _pageIndexController, (a, b)=>'Lesson$a - Page$b/$totalPage');
  Stream<String> get bookName=>_bookNameController.map((name)=>'Book ${name.substring(name.length-1)}');
  Stream<AsyncData<BookInfo>> get bookInfo => _bookNameController.distinct().flatMap((path) { 
        if(_bookPath!=path){
          _bookPath=path;
          selectedLessonIndex=-1;
          lessonIndexAction(-1);
        }         
        return Observable.fromFuture(_loadBookInfo(path))
        .map((data)=>AsyncData.loaded(data))
        .onErrorReturn(AsyncData.error('Unexpected error!'))
        .startWith(AsyncData.loading());
      });

  Stream<AsyncData<JPage>> get pageData=>_pageIndexController.flatMap((index){
    
    var path='$_bookPath/lesson$selectedLessonIndex/page$index.json';
    print(path);
    return Observable.fromFuture(_loadPageData(path))
    .map((data)=>AsyncData.loaded(data))
    .onErrorReturn(AsyncData.error('Unexpected error!'))
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
      return res;
    });
  }

  Future<int> _getTotalPage(String path) {
    print(path);
    return rootBundle.loadString('assets$path/info.json').then((data) {
      const JsonCodec json = const JsonCodec();
      var res =json.decode(data)['pages'] as int;
      print('totalPage:'+res.toString());
      return res;
    });
  }

  moveToLesson(int index) async{
    selectedLessonIndex=index;
    lessonIndexAction(index);
    totalPage=await _getTotalPage('$_bookPath/lesson$selectedLessonIndex');//.then((val){totalPage=val;});
    pageIndexAction(1);
    currentPage=1;
  }
  prev(){
    if(currentPage>1){
      currentPage--;
      pageIndexAction(currentPage);
    }
  }
  next(){
    if(currentPage<totalPage){
      currentPage++;
      pageIndexAction(currentPage);
    }
  }

  dispose() {
    _bookNameController.close();
    _pageIndexController.close();
    _lessonIndexController.cast();
  }
  selectWord(JWord word){
    _selectedWord.sink.add(word);
  }
}
