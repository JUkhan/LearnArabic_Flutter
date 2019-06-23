import 'dart:async';

import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';
import 'package:learn_arabic/blocs/models/bookModel.dart';
import 'package:learn_arabic/blocs/util.dart';
import 'package:learn_arabic/widgets/DrawerWidget.dart';
import 'package:learn_arabic/widgets/DynamicThemeWidget.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => new _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  double fontSize = 2.0;
  double wordSpace = 1.0;
  bool tts = false;
  bool isLandscape = false;
  StreamSubscription streamSubscription;
  @override
  void initState() {
    streamSubscription = select<BookModel>('book').take(1).listen((book) {
      setState(() {
        fontSize = book.fontSize;
        wordSpace = book.wordSpace;
        tts = book.tts;
        isLandscape = book.isLandscape;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: <Widget>[
          getTheme(context),
          getFontSize(context),
          getWordSpace(context),
          Card(
              child: ListTile(
            leading: Icon(tts ? Icons.mic : Icons.mic_off),
            title: Text('English TTS'),
            trailing: Switch(
              value: tts,
              onChanged: ttsValueChanged,
            ),
          )),
          Card(
              child: ListTile(
            leading: new CircleAvatar(
              //radius: 50.0,
              backgroundImage: AssetImage('assets/images/slide.png'),
            ),
            title: Text("How to navigate book's pages?"),
            subtitle: Text(
                'Ans: Please slide your finger from\nright to left / left to right'),
          )),
          Card(
              child: ListTile(
            leading: Icon(isLandscape ? Icons.landscape : Icons.portrait),
            title: Text(isLandscape ? 'Landscape' : 'Protrait'),
            trailing: Switch(
              value: isLandscape,
              onChanged: landscapeValueChanged,
            ),
          )),
        ],
      ),
    );
  }

  ttsValueChanged(bool value) {
    dispatch(ActionTypes.SET_LANDSCAPE, value);
    setState(() {
      tts = value;
    });
  }

  landscapeValueChanged(bool value) {
    dispatch(ActionTypes.SET_LANDSCAPE, value);
    Util.setDeviceOrientation(value);
    setState(() {
      isLandscape = value;
    });
  }

  valueChange(double value) {
    if (value >= 1.5 && value <= 2.4) {
      value = 2.0;
    } else if (value >= 2.5 && value <= 3.4) {
      value = 3.0;
    } else if (value >= 3.5 && value <= 4.0) {
      value = 4.0;
    } else {
      value = 1.0;
    }
    setState(() {
      fontSize = value;
    });
    dispatch(ActionTypes.SET_FONTSIZE, value);
  }

  wordSpaceValueChange(double value) {
    if (value >= 1.5 && value <= 2.4) {
      value = 2.0;
    } else if (value >= 2.5 && value <= 3.4) {
      value = 3.0;
    } else {
      value = 1.0;
    }
    setState(() {
      wordSpace = value;
    });
    dispatch(ActionTypes.SET_WORDSPACE, value);
  }

  Widget getWordSpace(BuildContext context) {
    var space = '';
    for (var i = 0.0; i < wordSpace; i++) {
      space += ' ';
    }
    return Card(
        child: Column(children: <Widget>[
      ListTile(leading: Icon(Icons.graphic_eq), title: Text('WORD SPACE')),
      Slider(
        min: 1.0,
        max: 3.0,
        value: wordSpace,
        onChanged: (value) {
          setState(() {
            wordSpace = value;
          });
        },
        onChangeEnd: wordSpaceValueChange,
      ),
      Text(
        'اْلأَوَّلُ' + space + 'اَلدَّرْسُ',
        style: Util.getTextTheme(context, 'rtl', fontSize),
      )
    ]));
  }

  Widget getFontSize(BuildContext context) => Card(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.gesture),
              title: const Text('FONT SIZE'),
            ),
            Divider(),
            Slider(
              min: 1.0,
              max: 4.0,
              value: fontSize,
              onChanged: (value) {
                setState(() {
                  fontSize = value;
                });
              },
              onChangeEnd: valueChange,
            ),
            Text(
              'اَلدَّرْسُ اْلأَوَّلُ',
              style: Util.getTextTheme(context, 'rtl', fontSize),
            )
          ],
        ),
      );
  Widget getTheme(BuildContext context) => Card(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.chrome_reader_mode),
              title: const Text('THEME'),
            ),
            Divider(),
            RadioListTile<Themes>(
              value: Themes.light,
              groupValue: DynamicThemeWidget.of(context).theme,
              onChanged: (value) {
                DynamicThemeWidget.of(context).setTheme(Themes.light);
                dispatch(ActionTypes.SET_THEME, Themes.light);
              },
              title: new Text("Light"),
            ),
            RadioListTile<Themes>(
              value: Themes.dark,
              groupValue: DynamicThemeWidget.of(context).theme,
              onChanged: (value) {
                DynamicThemeWidget.of(context).setTheme(Themes.dark);
                dispatch(ActionTypes.SET_THEME, Themes.dark);
              },
              title: new Text("Dark"),
            ),
          ],
        ),
      );
}
