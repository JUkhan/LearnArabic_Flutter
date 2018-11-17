import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Util {
  static Color getColor(String text) {
    Color color;
    switch (text) {
      case 'وَ':color = Colors.green;break;
      case 'أَ':case 'أ':color = Colors.lightBlue;break;
      case 'الْ':case 'ال':case 'اَلْ':case 'لْ':case 'ل':color = Colors.cyan;break;
      
      case 'فِي':case 'لَ':case 'لِ':case 'بِ':color = Colors.red;break;
      
      case 'تَ':case 'تِ': case 'تُ':case 'هِ':case 'كِ':
      case 'كَ':case 'هُ':case 'هَا':case 'ي':color=Colors.indigoAccent[400];break;
      default:color = Colors.orange;
    }
    return color;
  }
  static String getText(String text) {
    switch (text) {
      case 'وَ':text +=' : and এবং';break;
      case 'أَ':case 'أ':text +=' : interrogative particle প্রশ্নোত্তর কণা';break;
      case 'الْ':case 'ال':case 'اَلْ':case 'لْ':case 'ل':text +=' - اَلْ : the টি';break;
      
      case 'لَ':case 'لِ':text +=' : for, belongs to জন্য, সম্পর্কিত';break;
      case 'بِ':text +=' : in, at মধ্যে';break;
      case 'فِي':text +=' : in মধ্যে';break;
      
      case 'كَ':case 'تَ':case 'تِ': case 'كِ': text +=' : you/your তুমি/তোমার';break;      
      case 'هِ':case 'هُ':text +=' : him/his/it তাকে/তাহার/এটা';break;
      case 'هَا':text +=' : her তাকে/তাহার';break;
      case 'ي':text +=' : me/my আমাকে/আমার';break;
      case 'تُ': text +=' : i আমি';break;
      case 'الَّذِي':text +=' : who/which কে/যাহা';break;
      default: text +=' : under construction';       
    
    }
    return text;
  }

  static alert({BuildContext context, String message }){
    showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
              title: Text('Info'),
              content: Text(message), actions: <Widget>[              
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ]));
  }
  static int id=0;
  static initId(){
    return id=1;
  }
  static int getId(){
    id++;
    return id;
  }
  static Future<Null> launchUrl( String url) async {    
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } 
  }
}