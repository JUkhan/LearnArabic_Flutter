import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/appService.dart';
import 'package:learn_arabic/blocs/util.dart';

class AppTheme {
  static get dark {
    //final originalTextTheme = ThemeData.dark().textTheme;
    //final originalBody1 = originalTextTheme.bodyText2;
    return ThemeData.dark().copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: Colors.grey[800],
      accentColor: Colors.cyan[300],
      buttonColor: Colors.grey[800],
      textSelectionColor: Colors.cyan[100],
      backgroundColor: Colors.grey[800],
      /*textTheme: originalTextTheme.copyWith(
            body1: originalBody1.copyWith(decorationColor: Colors.transparent),
            headline: originalTextTheme.headline5
                .copyWith(color: Colors.indigo[100]))*/
    );
  }

  static get light {
    return ThemeData.light().copyWith(
      primaryColor: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}

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
    return widget.themedWidgetBuilder(context, _getThem());
  }

  setTheme(Themes theme) async {
    setState(() {
      this.theme = theme;
    });
  }

  _getThem() {
    return theme == Themes.light ? AppTheme.light : AppTheme.dark;
  }
}
