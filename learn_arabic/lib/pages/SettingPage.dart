import 'package:flutter/material.dart';
import '../blocs/AppStateProvider.dart';
import '../widgets/DrawerWidget.dart';
import '../widgets/DynamicThemeWidget.dart';
import '../blocs/StateMgmtBloc.dart';
import '../blocs/SettingBloc.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => new _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  double fontSize = 1.0;
  double wordSpace=1.0;
  StateMgmtBloc bloc;
  bool tts=false;
  @override
  Widget build(BuildContext context) {    
    if(bloc==null){
      bloc=AppStateProvider.of(context);
      fontSize=bloc.settingBloc.getFontSize();
      wordSpace=bloc.settingBloc.getWordSpace();
      tts=bloc.bookBloc.tts;
    }
    return Scaffold(
      drawer: DrawerWidget(bloc),
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: <Widget>[
          getTheme(context),          
          getFontSize(context),          
          getWordSpace(context),
          Card(child:ListTile(
            leading: Icon(tts?Icons.mic: Icons.mic_off),
            title: Text('English TTS'),
            trailing: Switch(value:tts ,onChanged: ttsValueChanged,),
          )),
          Card(
            child: ListTile(
            leading: new CircleAvatar(
              //radius: 50.0,
                backgroundImage: AssetImage('assets/images/slide.png'),
              ),
              title: Text("How to navigate book's page?"),
              subtitle: Text('Ans: Please slide your finger from\nright to left / left to right'),
          )
          ),
          
        ],
      ),
    );
  }
  ttsValueChanged(bool value){  
    bloc.bookBloc.setTTS(value);  
    setState(() {
          tts=value;
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
    bloc.settingBloc.setFontSize(value);
  }
  wordSpaceValueChange(double value){
    if (value >= 1.5 && value <= 2.4) {
      value = 2.0;
    } else if (value >= 2.5 && value <= 3.4) {
      value = 3.0;
    }else {
      value = 1.0;
    }
    setState(() {
      wordSpace = value;
    });
    bloc.settingBloc.setWordSpace(value);
  }
  Widget getWordSpace(BuildContext context){
    var space='';
    for (var i = 0.0; i < wordSpace; i++) {
      space+=' ';
    }
    return Card(child:Column(children: <Widget>[
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
            ) ,
            Text('اْلأَوَّلُ'+space+'اَلدَّرْسُ', style: bloc.settingBloc.getTextTheme(context, 'rtl'),)
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
            Text('اَلدَّرْسُ اْلأَوَّلُ', style: bloc.settingBloc.getTextTheme(context, 'rtl'),)
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
                bloc.settingBloc.theme=Themes.light;

              },
              title: new Text("Light"),
            ),
            RadioListTile<Themes>(
              value: Themes.dark,
              groupValue: DynamicThemeWidget.of(context).theme,
              onChanged: (value) {
                DynamicThemeWidget.of(context).setTheme(Themes.dark);
                bloc.settingBloc.theme=Themes.dark;
              },
              title: new Text("Dark"),
            ),
          ],
        ),
      );
}
