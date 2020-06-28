import 'package:learn_arabic/blocs/models/AsyncData.dart';
import 'package:learn_arabic/blocs/models/BookInfo.dart';
import 'package:learn_arabic/blocs/models/Bookmarks.dart';

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
    return book;
  }

  int lessonIndex = -1;
  int pageIndex = 0;
  int totalPage = 0;
  int totalLesson = 0;
  String bookPath = '';
  BookMarks bm = BookMarks();
  AsyncData<BookInfo> lessons;
  AsyncData<JPage> pageData;

  String get lessonInfo =>
      lessonIndex >= 0 ? 'Lesson $lessonIndex page $pageIndex was reading' : '';
  bool get hasPrev => pageIndex > 1;
  bool get hasNext => pageIndex < totalPage;
  String get pageTitle => 'Lesson$lessonIndex - $pageIndex of $totalPage';
  String get bookName => 'Book ${bookPath.substring(bookPath.length - 1)}';
  bool get hasBookMark =>
      bm?.find(int.parse(bookPath.substring(5)), lessonIndex, pageIndex);
  bool addBookMark() =>
      bm?.add(int.parse(bookPath.substring(5)), lessonIndex, pageIndex);

  List<BMBook> get books => bm.bids..sort((a, b) => a.id - b.id);
}
