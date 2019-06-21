import 'package:learn_arabic/blocs/models/AsyncData.dart';
import 'package:learn_arabic/blocs/models/BookInfo.dart';
import 'package:learn_arabic/blocs/models/Bookmarks.dart';
import 'package:learn_arabic/blocs/util.dart';

class BookModel {
  static clone(BookModel obj) {
    var book = BookModel();
    book.lessons = obj.lessons;
    book.pageData = obj.pageData;
    book.pageIndex = obj.pageIndex;
    book.lessonIndex = obj.lessonIndex;
    book.totalLesson = obj.totalLesson;
    book.totalPage = obj.totalPage;
    book.bookPath = obj.bookPath;
    book.bm = obj.bm;
    book.tts = obj.tts;
    book.fontSize = obj.fontSize;
    book.wordSpace = obj.wordSpace;
    book.wordIndex = obj.wordIndex;
    book.scrollOffset = obj.scrollOffset;
    book.selectedWord = obj.selectedWord;
    book.theme = obj.theme;
    return book;
  }

  int lessonIndex = -1;
  int pageIndex = 0;
  int totalPage = 0;
  int totalLesson = 0;
  double scrollOffset;
  String wordIndex;
  String bookPath = '';
  BookMarks bm = BookMarks();
  bool tts = false;
  AsyncData<BookInfo> lessons;
  AsyncData<JPage> pageData;
  JWord selectedWord;
  //preference

  Themes theme = Themes.dark;
  double fontSize = 2.0;
  double wordSpace = 1.0;

  String get getWordSpace {
    var s = '';
    for (var i = 0.0; i < wordSpace; i++) s += ' ';
    return s;
  }

  String get lessonInfo =>
      lessonIndex >= 0 ? 'Lesson $lessonIndex page $pageIndex was reading' : '';
  bool get hasPrev => pageIndex > 1;
  bool get hasNext => pageIndex < totalPage;
  String get pageTitle => 'Lesson$lessonIndex - Page $pageIndex of $totalPage';
  String get bookName => 'Book ${bookPath.substring(bookPath.length - 1)}';
  bool get hasBookMark =>
      bm?.find(int.parse(bookPath.substring(5)), lessonIndex, pageIndex);
  bool addBookMark() =>
      bm?.add(int.parse(bookPath.substring(5)), lessonIndex, pageIndex);

  bool hasSelectedWord(int index) =>
      wordIndex == '$index$lessonIndex$pageIndex';
  List<BMBook> get books => bm.bids..sort((a, b) => a.id - b.id);
}
