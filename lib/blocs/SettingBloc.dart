import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Themes { light, dark }

class SettingBloc {
  Themes theme = Themes.dark;
  double _fontSize = 2.0;
  SettingBloc() {
    _loadFontSize().then((value) {
      _fontSize = value;
    });
  }
  void setFontSize(double value) async {
    _fontSize = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(_fontKey, value);
  }

  double getFontSize() {
    return _fontSize;
  }

  TextStyle getTextTheme(BuildContext context, String direction) {
    if (direction == 'ltr') {
      if (_fontSize == 1.0)
        return Theme.of(context).textTheme.title;
      else if (_fontSize == 2.0) return Theme.of(context).textTheme.headline;
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
//decoration: TextDecoration.underline,
  ///               decorationStyle: TextDecorationStyle.wavy,
  static const String _fontKey = "fontKey";
  Future<double> _loadFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getDouble(_fontKey) ?? 1.0);
  }
}
