import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';
import 'package:learn_arabic/blocs/models/MemoModel.dart';
import 'package:learn_arabic/blocs/util.dart';
import 'package:learn_arabic/widgets/ColorThemeWidget.dart';
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
  int lectureCategory = 1;
  int wordMeaningCategory = 1;
  Color iconColor = Colors.teal;
  Color themeColor;
  @override
  void initState() {
    select<MemoModel>('memo').take(1).listen((memo) {
      setState(() {
        fontSize = memo.fontSize;
        wordSpace = memo.wordSpace;
        tts = memo.tts;
        themeColor =
            materialColors.firstWhere((element) => element.value == memo.theme);
        isLandscape = memo.isLandscape;
        lectureCategory = memo.lectureCategory;
        wordMeaningCategory = memo.wordMeaningCategory;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<Item> _items = [
    Item("English", 1),
    Item("Bengali", 2),
    Item("Both", 3)
  ];
  @override
  Widget build(BuildContext context) {
    iconColor = Theme.of(context).accentColor;
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        color: DynamicThemeWidget.of(context).color == Colors.black
            ? Colors.transparent
            : Colors.black12,
        padding: const EdgeInsets.all(2),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            // padding: const EdgeInsets.all(10.0),
            children: <Widget>[
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.ac_unit,
                        color: iconColor,
                      ),
                      title: Text('Themes'),
                    ),
                    Divider(color: iconColor),
                    Container(
                      height: 230,
                      child: ColorThemeWidget(
                        onColorChange: (color) {
                          DynamicThemeWidget.of(context).setTheme(color);
                          dispatch(ActionTypes.SET_THEME, color.value);
                          themeColor = color;
                        },
                        selectedColor: themeColor,
                      ),
                    ),
                  ],
                ),
              ),
              getOptions(
                  title: 'Lecture Series',
                  items: _items,
                  groupValue: lectureCategory,
                  icon: Icons.language,
                  onChange: (value) {
                    setState(() {
                      lectureCategory = value;
                    });
                    dispatch(ActionTypes.LECTURE_CATEGORY, value);
                  }),
              getOptions(
                  title: 'Word Meaning',
                  items: _items,
                  groupValue: wordMeaningCategory,
                  icon: Icons.wb_auto,
                  onChange: (value) {
                    setState(() {
                      wordMeaningCategory = value;
                    });
                    Util.wordMeanCategory = value;
                    dispatch(ActionTypes.WORDMEANING_CATEGORY, value);
                  }),
              getFontSize(context),
              getWordSpace(context),
              Card(
                  child: ListTile(
                leading: Icon(
                  tts ? Icons.mic : Icons.mic_off,
                  color: iconColor,
                ),
                title: Text('English TTS'),
                trailing: Switch(
                  value: tts,
                  onChanged: ttsValueChanged,
                ),
              )),
              Card(
                  child: ListTile(
                leading: Icon(
                  isLandscape ? Icons.landscape : Icons.portrait,
                  color: iconColor,
                ),
                title: Text(isLandscape ? 'Landscape' : 'Protrait'),
                trailing: Switch(
                  value: isLandscape,
                  onChanged: landscapeValueChanged,
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  ttsValueChanged(bool value) {
    dispatch(ActionTypes.SET_TTS, value);
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

  Widget getWordSpace(BuildContext context) {
    var space = '';
    for (var i = 0.0; i < wordSpace; i++) {
      space += ' ';
    }
    return Card(
        child: Column(children: <Widget>[
      ListTile(
          leading: Icon(
            Icons.graphic_eq,
            color: iconColor,
          ),
          title: Text('WORD SPACE')),
      Divider(
        color: iconColor,
      ),
      Slider(
        min: 1.0,
        max: 5.0,
        value: wordSpace,
        divisions: 4,
        onChanged: (value) {
          setState(() {
            wordSpace = value;
          });
          dispatch(ActionTypes.SET_WORDSPACE, value);
        },
      ),
      Text(
        'اْلأَوَّلُ' + space + 'اَلدَّرْسُ',
        style: Util.getTextTheme(context, 'rtl', fontSize),
      ),
    ]));
  }

  Widget getFontSize(BuildContext context) => Card(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.gesture,
                color: iconColor,
              ),
              title: const Text('FONT SIZE'),
            ),
            Divider(color: iconColor),
            Slider(
              min: 1.0,
              max: 5.0,
              divisions: 4,
              value: fontSize,
              onChanged: (value) {
                setState(() {
                  fontSize = value;
                });
                dispatch(ActionTypes.SET_FONTSIZE, value);
              },
            ),
            Text(
              'اَلدَّرْسُ اْلأَوَّلُ',
              style: Util.getTextTheme(context, 'rtl', fontSize),
            ),
            Text(
              'Learn Quran',
              style: Util.getTextTheme(context, 'ltr', fontSize),
            )
          ],
        ),
      );

  Widget getOptions({
    List<Item> items,
    String title,
    dynamic groupValue,
    IconData icon,
    Function onChange,
  }) =>
      Card(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ListTile(
              leading: Icon(
                icon,
                color: iconColor,
              ),
              title: Text(title),
            ),
            Divider(color: iconColor),
            JRadio(
              items: items,
              groupValue: groupValue,
              onChanged: onChange,
            ),
          ],
        ),
      );
}

class Item {
  final String name;
  final dynamic value;
  Item(this.name, this.value);
}

class JRadio extends StatelessWidget {
  final List<Item> items;
  final Function onChanged;
  final dynamic groupValue;
  const JRadio({Key key, this.items, this.onChanged, this.groupValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        children: items
            .map((item) => Row(children: <Widget>[
                  InkWell(
                    onTap: () {
                      onChanged(item.value);
                    },
                    child: Row(
                      children: <Widget>[
                        Radio(
                          value: item.value,
                          groupValue: groupValue,
                          onChanged: onChanged,
                        ),
                        Text(item.name)
                      ],
                    ),
                  )
                ]))
            .toList());
  }
}
