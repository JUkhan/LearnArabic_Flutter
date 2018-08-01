class BookInfo {
  final int lessons;
  final String description;

  BookInfo({this.lessons, this.description});
  factory BookInfo.fromJson(Map<String, dynamic> json) {
    return BookInfo(
        lessons: json['lessons'] as int,
        description: json['description'] as String);
  }
}

class JVideo {
  String id;
  String title;
  JVideo({this.id, this.title});
  factory JVideo.fromJson(dynamic json) {
    return JVideo(id: json['id'] as String, title: json['title'] as String);
  }
}

T getValue<T>(Map<String, dynamic> json, String key, dynamic defaultValue){
    if(json.containsKey(key)){
      return json[key] as T;
    }
    return defaultValue as T;
  }

class JLine {
  final String direction;
  final String mode;
  final List<JLine> lines;
  final List<JWord> words;
  JLine({
    this.direction,
    this.mode,
    this.lines,
    this.words
  });
  factory JLine.fromJson(Map<String, dynamic> json){
    var lines=<JLine>[];
    var words=<JWord>[];
    if(json.containsKey('lines')){
      lines=(json['lines'] as List)
      .cast<Map<String, dynamic>>()
      .map<JLine>((item)=>JLine.fromJson(item)).toList();
    }
    if(json.containsKey('words')){
      words=(json['words'] as List)
      .cast<Map<String, dynamic>>()
      .map<JWord>((item)=>JWord.fromJson(item)).toList();
    }
    return JLine(
      direction: getValue<String>(json, 'd', 'ltr'),
      mode: getValue<String>(json, 'mode', ''),
      lines:lines,
      words:words
      );
  }
}
class JWord{
  final String direction;
  final String word;
  final String bangla;
  final String english;
  final int wordSpace;
  JWord({
    this.direction,
    this.bangla,
    this.english,
    this.word,
    this.wordSpace
  });
  factory JWord.fromJson(Map<String, dynamic> json){
    
    return JWord(
      word: getValue<String>(json, 'w', ''),
      direction: getValue<String>(json, 'd', 'ltr'),
      bangla: getValue<String>(json, 'b', ''),
      english: getValue<String>(json, 'e', ''),
      wordSpace: getValue<int>(json, 'ws', 0)
    );
  }
  
}

class JPage{
  final List<JVideo> videos;
  final List<JLine> lines;
  JPage({this.lines, this.videos});
  factory JPage.fromJson(Map<String, dynamic> json){
    var videos=<JVideo>[];
    var lines=<JLine>[];
    if(json.containsKey('videos')){
      videos=(json['videos'] as List).cast<Map<String, dynamic>>()
      .map<JVideo>((item)=>JVideo.fromJson(item)).toList();
    }
    if(json.containsKey('lines')){
      lines=(json['lines'] as List).cast<Map<String, dynamic>>()
      .map<JLine>((item)=>JLine.fromJson(item)).toList();
    }
    return JPage(lines: lines, videos: videos);
  }
}
