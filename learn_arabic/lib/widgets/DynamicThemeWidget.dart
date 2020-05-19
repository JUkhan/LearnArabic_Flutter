import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/appService.dart';
import 'package:learn_arabic/blocs/util.dart';

typedef Widget ThemedWidgetBuilder(BuildContext context, ThemeData theme);

class DynamicThemeWidget extends StatefulWidget {
  final ThemedWidgetBuilder themedWidgetBuilder;
  final Themes defaultTheme;

  DynamicThemeWidget({Key key, this.defaultTheme, this.themedWidgetBuilder})
      : super(key: key);

  @override
  DynamicThemeWidgetState createState() => new DynamicThemeWidgetState();

  static DynamicThemeWidgetState of(BuildContext context) {
    //return context.ancestorStateOfType(const TypeMatcher<DynamicThemeWidgetState>());
    return context.findAncestorStateOfType();
  }
}

class DynamicThemeWidgetState extends State<DynamicThemeWidget> {
  Themes theme;
  @override
  void initState() {
    if (widget.defaultTheme == null) {
      theme = Themes.light;
    } else
      theme = widget.defaultTheme;

    AppService.getFromPref(AppService.prefkey_theme, 0).then((value) {
      setState(() {
        theme = value == 0 ? Themes.light : Themes.dark;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.themedWidgetBuilder(
        context, theme == Themes.light ? light : dark);
  }

  setTheme(Themes theme) async {
    setState(() {
      this.theme = theme;
    });
  }

  get dark => ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.grey[800],
        accentColor: Colors.grey[800],
        brightness: Brightness.dark,
        backgroundColor: Colors.white70,
        //fontFamily: 'Georgia',
      );
  get light => ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.teal,
        accentColor: Colors.teal[200],
        brightness: Brightness.light,
        backgroundColor: Colors.teal[700],
        //cardColor: Colors.teal[200],
        //fontFamily: 'Georgia',
        dividerColor: Colors.teal[200],
      );
}
