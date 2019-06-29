import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

enum Themes { light, dark }

class Util {
  static Color getColor(String text) {
    Color color;
    switch (text) {
      case 'وَ':
        color = Colors.green;
        break;
      case 'أَ':
      case 'أ':
        color = Colors.lightBlue;
        break;
      case 'الْ':
      case 'ال':
      case 'اَلْ':
      case 'لْ':
      case 'ل':
        color = Colors.cyan;
        break;

      case 'فِي':
      case 'لَ':
      case 'لِ':
      case 'بِ':
        color = Colors.red;
        break;

      case 'هِ':
      case 'كِ':
      case 'هُمْ':
      case 'هُنَّ':
      case 'كَ':
      case 'هُ':
      case 'هَا':
      case 'ي':
      //subject/doer
      case 'نَ':
      case 'تَ':
      case 'تِ':
      case 'تُ':
      case 'نَا':
      case 'وا':
        color = Colors.indigoAccent[400];
        break;

      default:
        color = Colors.orange;
    }
    return color;
  }

  static String getText(String text) {
    switch (text) {
      case 'وَ':
        text += ' : and এবং';
        break;
      case 'أَ':
      case 'أ':
        text += ' : interrogative particle প্রশ্নোত্তর কণা';
        break;
      case 'الْ':
      case 'ال':
      case 'اَلْ':
      case 'لْ':
      case 'ل':
        text += ' - اَلْ : the টি';
        break;

      case 'لَ':
      case 'لِ':
        text += ' : for, belongs to জন্য, সম্পর্কিত';
        break;
      case 'بِ':
        text += ' : in, at মধ্যে';
        break;
      case 'فِي':
        text += ' : in মধ্যে';
        break;

      case 'كَ':
        text += ' : you/your তুমি/তোমার (masculine/পুংলিঙ্গ)';
        break;
      case 'كِ':
        text += ' : you/your তুমি/তোমার (feminine/স্ত্রীলিঙ্গ)';
        break;
      case 'هِ':
      case 'هُ':
        text += ' : him/his/it তাকে/তাহার/এটা';
        break;
      case 'هَا':
        text += ' : her তাকে/তাহার';
        break;
      case 'ي':
        text += ' : me/my আমাকে/আমার';
        break;

      case 'الَّذِي':
        text += ' : who/which কে/যাহা';
        break;
      case 'هُمْ':
        text += ' : they/their তাহারা/তাদের (masculine/পুংলিঙ্গ)';
        break;
      case 'هُنَّ':
        text += ' : they/their তাহারা/তাদের (feminine/স্ত্রীলিঙ্গ)';
        break;

      //subject/doer
      case 'نَ':
        text += ' : [subject/doer] they তাহারা (feminine/স্ত্রীলিঙ্গ)';
        break;
      case 'وا':
        text += ' : [subject/doer] they তাহারা (masculine/পুংলিঙ্গ)';
        break;
      case 'تَ':
        text += ' : [subject/doer] you তুমি (masculine/পুংলিঙ্গ)';
        break;
      case 'تِ':
        text += ' : [subject/doer] you তুমি (feminine/স্ত্রীলিঙ্গ)';
        break;
      case 'تُ':
        text += ' : [subject/doer] i আমি';
        break;
      case 'نَا':
        text += ' : [subject/doer] we আমরা';
        break;

      default:
        text += ' : under construction';
    }
    return text;
  }

  static alert({BuildContext context, String message}) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text('Info'),
                content: Text(message),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ]));
  }

  static int id = 0;
  static initId() {
    return id = 1;
  }

  static int getId() {
    id++;
    return id;
  }

  static Future<Null> launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    }
  }

  static TextStyle getTextTheme(
      BuildContext context, String direction, double _fontSize) {
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

  static setDeviceOrientation(bool isLandscape) {
    if (isLandscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);
    }
  }
}
