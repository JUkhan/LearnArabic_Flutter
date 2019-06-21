import '../util.dart';

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

T getValue<T>(Map<String, dynamic> json, String key, dynamic defaultValue) {
  if (json.containsKey(key)) {
    return json[key] as T;
  }
  return defaultValue as T;
}

class JLine {
  final String direction;
  final String mode;
  final String img;
  final int lineno;
  bool isHide = false;
  final double height;
  final List<JLine> lines;
  final List<JWord> words;

  JLine({
    this.direction,
    this.mode,
    this.img,
    this.lines,
    this.words,
    this.height,
    this.lineno,
  });
  factory JLine.fromJson(Map<String, dynamic> json) {
    var lines = <JLine>[];
    var words = <JWord>[];
    if (json.containsKey('lines')) {
      lines = (json['lines'] as List)
          .cast<Map<String, dynamic>>()
          .map<JLine>((item) => JLine.fromJson(item))
          .toList();
    }
    if (json.containsKey('words')) {
      words = (json['words'] as List)
          .cast<Map<String, dynamic>>()
          .map<JWord>((item) => JWord.fromJson(item))
          .toList();
    }
    return JLine(
        direction: getValue<String>(json, 'd', 'rtl'),
        mode: getValue<String>(json, 'mode', ''),
        img: getValue<String>(json, 'img', ''),
        lineno: getValue<int>(json, 'lineno', 1),
        height: getValue<double>(json, 'height', 45.0),
        lines: lines,
        words: words);
  }
}

class JWord {
  final String direction;
  final String word;
  final String bangla;
  final String english;
  final int wordSpace;
  final List<int> sp;
  final int id;
  JWord(
      {this.direction,
      this.bangla,
      this.english,
      this.word,
      this.wordSpace,
      this.sp})
      : id = Util.getId();

  factory JWord.fromJson(Map<String, dynamic> json) {
    List<int> sps;
    if (json.containsKey('sp')) {
      sps = (json['sp'] as List).cast<int>();
    }
    return JWord(
        word: getValue<String>(json, 'w', ''),
        direction: getValue<String>(json, 'd', 'rtl'),
        bangla: getValue<String>(json, 'b', ''),
        english: getValue<String>(json, 'e', ''),
        wordSpace: getValue<int>(json, 'ws', 0),
        sp: sps);
  }

  factory JWord.empty({String text = ''}) {
    return JWord(
      direction: '',
      bangla: '',
      english: '',
      word: text,
      wordSpace: 0,
    );
  }
}

class JPage {
  final JLine title;
  final List<JVideo> videos;
  final List<JLine> lines;
  JPage({this.lines, this.videos, this.title});
  factory JPage.fromJson(Map<String, dynamic> json) {
    var videos = <JVideo>[];
    var lines = <JLine>[];
    if (json.containsKey('videos')) {
      videos = (json['videos'] as List)
          .cast<Map<String, dynamic>>()
          .map<JVideo>((item) => JVideo.fromJson(item))
          .toList();
    }
    if (json.containsKey('lines')) {
      lines = (json['lines'] as List)
          .cast<Map<String, dynamic>>()
          .map<JLine>((item) => JLine.fromJson(item))
          .toList();
    }
    var temp = getValue<dynamic>(json, 'title', null);
    JLine title = temp == null ? null : JLine.fromJson(temp);
    return JPage(
      lines: lines,
      videos: videos,
      title: title,
    );
  }
}
