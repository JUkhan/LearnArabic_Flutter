import 'dart:convert';

class BookMarks {
  List<BMBook> bids = List<BMBook>();

  BookMarks() {
    //this.bids = bids;
  }
  BookMarks.fromJson(Map<String, dynamic> json) {    
      bids=(json['bids'] as List)
       .cast<Map<String, dynamic>>()
       .map<BMBook>((item)=>BMBook.fromJson(item)).toList();
    
  }
  BookMarks.fromStr(String data) { 
      var co = const JsonCodec();
      var json=co.decode(data);
      bids=(json['bids'] as List)
       .cast<Map<String, dynamic>>()
       .map<BMBook>((item)=>BMBook.fromJson(item)).toList();
    
  }
  
  static String getJson(
    BookMarks value
  ) {    
    const JsonCodec json = const JsonCodec();
    return json.encode(value);    
  }

  bool add(int bookId, int lessonId, int pageId) {
    var book = bids.firstWhere((b) => b.id == bookId, orElse: () => null);
    if (book == null) {
      book = BMBook(id:bookId, lids:new List<BMLesson>());
      bids.add(book);
    }
    var res= book.add(lessonId, pageId);  
    if(res==false && book.lids.length==0){
      bids.remove(book);
    }
    return res;
  }

  bool find(int bookId, int lessonId, int pageId) {
    var book = bids.firstWhere((b) => b.id == bookId, orElse: () => null);
    if (book == null) {
      return false;
    }    
    return book.find(lessonId, pageId);
  }

  Map<String, dynamic> toJson(){
    return {      
      'bids': bids
    };
  }
}

class BMBook {
  final int id;
  final List<BMLesson> lids;
  BMBook({this.id, this.lids});
  bool add(int lessonId, int pageId) {
    var lesson = lids.firstWhere((l) => l.id == lessonId, orElse: () => null);
    if (lesson == null) {
      lesson = BMLesson(id:lessonId, pids:List<int>());
      lids.add(lesson);
    }
    var res= lesson.add(pageId);
    if(res==false && lesson.pids.length==0){
      lids.remove(lesson);
    }
    return res;
  }

  bool find(int lessonId, int pageId) {
    var lesson = lids.firstWhere((l) => l.id == lessonId, orElse: () => null);
    if (lesson == null) {
      return false;
    }    
    return lesson.find(pageId);
  }

  factory BMBook.fromJson(Map<String, dynamic> json){
    return BMBook(
      id: json['id'] as int,
      lids: (json['lids'] as List)
       .cast<Map<String, dynamic>>()
       .map<BMLesson>((item)=>BMLesson.fromJson(item)).toList()
      );
  }
  Map<String, dynamic> toJson(){
    return {
      'id':id,
      'lids': lids
    };
  }
  List<BMLesson> get lessons=>lids..sort((a,b)=>a.id-b.id);
}

class BMLesson {
  final int id;
  final List<int> pids;
  BMLesson({this.id, this.pids});
  bool add(int pageId) {
    var pid = pids.firstWhere((p) => p == pageId, orElse: () => 0);
    if (pid == 0) {
      pids.add(pageId);
      return true;
    }
    pids.remove(pid);
    return false;
  }
  bool find(int pageId) {
    var pid = pids.firstWhere((p) => p == pageId, orElse: () => 0);
    if (pid == 0) {     
      return false;
    }    
    return true;
  }

  factory BMLesson.fromJson(Map<String, dynamic> json) {
    return BMLesson(
        id: json['id'] as int,
        pids: (json['pids'] as List).cast<int>()
      );
  }
  Map<String, dynamic> toJson(){
    return {
      'id':id,
      'pids': pids
    };
  }
  List<int> get pages=>pids..sort();
}
