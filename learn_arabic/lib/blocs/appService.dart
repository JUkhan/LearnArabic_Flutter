import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:learn_arabic/blocs/models/BookInfo.dart';
import 'package:learn_arabic/blocs/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppService {
  static Future<T> getFromPref<T>(String key, T defaultValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.get(key) as T) ?? defaultValue;
  }

  static void saveInPref<T>(T value, String key) {
    SharedPreferences.getInstance().then((prefs) {
      if (value is int)
        prefs.setInt(key, value);
      else if (value is String)
        prefs.setString(key, value);
      else if (value is bool)
        prefs.setBool(key, value);
      else if (value is double) prefs.setDouble(key, value);
    });
  }

  static Future<JPage> loadPageData(String path) {
    Util.initId();
    return rootBundle.loadString('assets$path.json').then((data) {
      const JsonCodec json = const JsonCodec();
      var res = JPage.fromJson(json.decode(data));
      return res;
    });
  }

  static Future<BookInfo> loadBookInfo(String path) {
    return rootBundle.loadString('assets$path/info.json').then((data) {
      const JsonCodec json = const JsonCodec();
      var res = BookInfo.fromJson(json.decode(data));
      //totalLesson = res.lessons;
      saveInPref(path, prefkey_bookName);
      saveInPref(res.lessons, prefkey_totalLesson);
      return res;
    });
  }

  static Future<int> getTotalPage(String path) {
    return rootBundle.loadString('assets$path/info.json').then((data) {
      const JsonCodec json = const JsonCodec();
      var res = json.decode(data)['pages'] as int;
      return res;
    });
  }

  static const String prefkey_bookName = 'bookName';
  static const String prefkey_lessonIndex = 'lessonIndex';
  static const String prefkey_pageIndex = 'pageIndex';
  static const String prefkey_bookMarks = '#BM#';
  static const String prefkey_totalLesson = '#tl#';
  static const String prefkey_tts = '#tts#';
  static const String prefkey_wordIndex = "wi";
  static const String prefkey_scrollOffset = "soff";
  static const String prefkey_wordSpace = "wordSpace";
  static const String prefkey_fontSize = "fontSize";
  static const String prefkey_theme = "theme";
}
