import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/util.dart';
import 'package:learn_arabic/pages/BookLessonsPage.dart';
import 'package:learn_arabic/pages/BookPage.dart';
import 'package:learn_arabic/pages/BookmarkPage.dart';
import 'package:learn_arabic/pages/HomePage.dart';
import 'package:learn_arabic/pages/Pages.dart';
import 'package:learn_arabic/pages/PlayerPage.dart';
import 'package:learn_arabic/pages/SettingPage.dart';
import 'package:learn_arabic/widgets/DynamicThemeWidget.dart';

class App extends StatefulWidget {
  final Store block;
  App({@required this.block});

  @override
  _AppState createState() => new _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicThemeWidget(
        //bloc: widget.block,
        defaultTheme: Themes.light,
        themedWidgetBuilder: (context, theme) => new MaterialApp(
              title: 'Learn Arabic',
              theme: theme,
              initialRoute: '/',
              routes: {
                '/': (_) => HomePage(),
                '/book': (_) => BookPage(),
                '/lessons': (_) => BookLessonsPage(),
                '/setting': (_) => SettingPage(),
                '/page': (_) => Pages(),
                '/markbook': (_) => BookMarkPage(),
                '/player': (_) => PlayerPage()
              },
            ));
  }

  @override
  void dispose() {
    Util.disposeTTS();
    widget.block.dispose();
    super.dispose();
  }
}

/*
ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: DynamicThemeWidget(
            //bloc: widget.block,
            defaultTheme: Themes.light,
            themedWidgetBuilder: (context, theme) => new MaterialApp(
                  title: 'Learn Arabic',
                  theme: theme,
                  initialRoute: '/',
                  routes: {
                    '/': (_) => HomePage(),
                    '/book': (_) => BookPage(),
                    '/lessons': (_) => BookLessonsPage(),
                    '/setting': (_) => SettingPage(),
                    '/page': (_) => Pages(),
                    '/markbook': (_) => BookMarkPage(),
                    '/player': (_) => PlayerPage()
                  },
                )));
*/
