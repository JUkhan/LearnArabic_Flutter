import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
  static get dark {
    final originalTextTheme = ThemeData.dark().textTheme;
    final originalBody1 = originalTextTheme.body1;

    return ThemeData.dark().copyWith(
        primaryColor: Colors.grey[800],
        accentColor: Colors.cyan[300],
        buttonColor: Colors.grey[800],
        textSelectionColor: Colors.cyan[100],
        backgroundColor: Colors.grey[800],
        textTheme: originalTextTheme.copyWith(
            body1: originalBody1.copyWith(decorationColor: Colors.transparent),
            title:
                originalTextTheme.title.copyWith(color: Colors.indigo[100])));
  }

  static get light {
    return ThemeData.light();
  }
}

typedef Widget ThemedWidgetBuilder(BuildContext context, ThemeData theme);
enum Themes { light, dark }

class DynamicThemeWidget extends StatefulWidget {
  final ThemedWidgetBuilder themedWidgetBuilder;
  final Themes defaultTheme;

  DynamicThemeWidget({Key key, this.defaultTheme, this.themedWidgetBuilder})
      : super(key: key);

  @override
  DynamicThemeWidgetState createState() => new DynamicThemeWidgetState();

  static DynamicThemeWidgetState of(BuildContext context) {
    return context
        .ancestorStateOfType(const TypeMatcher<DynamicThemeWidgetState>());
  }
}

class DynamicThemeWidgetState extends State<DynamicThemeWidget> {
  static const String _themeKey = "apptheme";
  Themes theme;
  @override
  void initState() {
    if (widget.defaultTheme == null) {
      theme = Themes.light;
    } else
      theme = widget.defaultTheme;
    loadThem().then((value) {
      setState(() {
        theme= value == 'light' ? Themes.light : Themes.dark;        
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.themedWidgetBuilder(context, _getThem());
  }

  setTheme(Themes theme) async {
    setState(() {
      this.theme = theme;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_themeKey, Themes.dark == theme ? 'dark' : 'light');
  }

  _getThem() {
    return theme == Themes.light ? AppTheme.light : AppTheme.dark;
  }

  Future<String> loadThem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getString(_themeKey) ?? 'light');
  }
}
