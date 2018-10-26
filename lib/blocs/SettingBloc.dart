import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Themes { light, dark }

class SettingBloc {
  Themes theme = Themes.dark;
  double _fontSize = 2.0;
  double _wordSpace=2.0;
  SettingBloc() {
    _loadKeyData(_fontKey).then((value) {
      _fontSize = value;
    });
    _loadKeyData(_wordSpaceKey).then((value) {
      _wordSpace = value;
    });
  }
  void setFontSize(double value) async {
    _fontSize = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(_fontKey, value);
  }

  void setWordSpace(double value) async {
    _wordSpace = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(_wordSpaceKey, value);
  }

  double getFontSize() {
    return _fontSize;
  }

  double getWordSpace() {
    return _wordSpace;
  }
  String get wordSpace{var s=''; for(var i=0.0;i<_wordSpace;i++)s+=' '; return s;}
  TextStyle getTextTheme(BuildContext context, String direction) {
    if (direction == 'ltr') {
      if (_fontSize == 1.0)
        return Theme.of(context).textTheme.subhead;
      else if (_fontSize == 2.0) return Theme.of(context).textTheme.title;
      return Theme.of(context).textTheme.headline;
    }
    if (_fontSize == 1.0)
      return Theme.of(context).textTheme.title;
    else if (_fontSize == 2.0)
      return Theme.of(context).textTheme.headline;
    else if (_fontSize == 3.0)
      return Theme.of(context).textTheme.display1;
    else if (_fontSize == 4.0) return Theme.of(context).textTheme.display2;

    return Theme.of(context).textTheme.title;
  }

  static const String _fontKey = "fontKey";
  static const String _wordSpaceKey = "wsKey";
  Future<double> _loadKeyData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getDouble(key) ?? 2.0);
  }
}
