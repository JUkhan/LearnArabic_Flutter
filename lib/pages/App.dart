import 'package:flutter/material.dart';
import './HomePage.dart';
import './BookPage.dart';
import '../blocs/AppStateProvider.dart';
import '../blocs/StateMgmtBloc.dart';
import './BookLessonsPage.dart';
import '../widgets/DynamicThemeWidget.dart';
import './SettingPage.dart';

class App extends StatefulWidget {
  final StateMgmtBloc block;
  App({@required this.block});

  @override
  _AppState createState() => new _AppState();
}

class _AppState extends State<App> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: AppStateProvider(
            stateMgmtBloc: widget.block,
            child: DynamicThemeWidget(
                defaultTheme: Themes.light,
                themedWidgetBuilder: (context, theme) => new MaterialApp(
                      title: 'Pleasure of Allah',
                      theme: theme,
                      initialRoute: '/',
                      routes: {
                        '/': (_) => HomePage(),
                        '/book': (_) => BookPage(),
                        '/lessons': (_) => BookLessonsPage(),
                        '/setting':(_)=> SettingPage()
                      },
                    ))));
  }

  @override
  void dispose() {
    widget.block.dispose();
    super.dispose();
  }
}
