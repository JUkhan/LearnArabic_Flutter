import 'package:flutter/material.dart';
import '../widgets/DrawerWidget.dart';
import '../blocs/AppStateProvider.dart';
import '../blocs/StateMgmtBloc.dart';
import '../blocs/models/AsyncData.dart';
import '../blocs/models/BookInfo.dart';
import '../widgets/LoadingWidget.dart';
import '../widgets/JErrorWidget.dart';
import '../widgets/PageDataWidget.dart';

class BookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = AppStateProvider.of(context);
    return Scaffold(
      appBar: new AppBar(
        title: StreamBuilder<String>(
          initialData: 'Learn Arabic',
          stream: bloc.bookBloc.pageTitle,
          builder: (_, snapshot) => Text(snapshot.data),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: bloc.bookBloc.bookMark,
              tooltip: 'Toggle Book Marks',
              icon: StreamBuilder<bool>(
                initialData: false,
                stream: bloc.bookBloc.bookMarkStream,
                builder: (_, snapshot) => Icon(
                      Icons.star,
                      color: snapshot.data ? Colors.pink[400] : null,
                    ),
              ))
        ], //Icon(Icons.star, color: Colors.pink[400],),)],
      ),
      body: StreamBuilder<AsyncData<JPage>>(
        initialData: AsyncData.loading(),
        stream: bloc.bookBloc.pageData,
        builder: (_, snapshot) {
          return Container(
            child: Stack(
              children: <Widget>[
                LoadingWidget(snapshot.data),
                JErrorWidget(snapshot.data),
                PageDataWidget(bloc, snapshot.data)
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _navBar(bloc, context),
      drawer: DrawerWidget(bloc),
    );
  }

  Widget _navBar(StateMgmtBloc bloc, BuildContext context) {
    return BottomAppBar(
      //color: Colors.black45,
      //elevation: 37.0,
      //hasNotch: true,
      child: Row(
        children: <Widget>[
          Expanded(
              child: StreamBuilder<JWord>(
            initialData: JWord.empty(),
            stream: bloc.bookBloc.selectedWord,
            builder: (_, snapshot) => snapshot.data.word.isEmpty
                ? const Text('')
                : Text(
                    snapshot.data.english+' '+ _getBanglaText(snapshot.data),
                    textAlign: TextAlign.center,
                    style:_isArabic(snapshot.data.english)? Theme.of(context).textTheme.headline:Theme.of(context).textTheme.title,
                  ),
          )),
          StreamBuilder<JWord>(
              initialData: JWord.empty(),
              stream: bloc.bookBloc.selectedWord,
              builder: (_, snapshot) {
                if (snapshot.data.word.isNotEmpty) {
                  return IconButton(
                    tooltip: 'Details meaning',
                    icon: Icon(Icons.details),
                    onPressed: () {
                      _showBottomSheet(context, snapshot.data);
                    },
                  );
                }
                return const Text('');
              }),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, JWord word) {
    showModalBottomSheet(
        context: context,
        builder: (bc) {
          return Container(
            //color: Colors.greenAccent,
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                RichText(
                  textDirection: TextDirection.rtl,
                  text: _getTextSpan(context, word),
                ),                
                Divider(),
                _getEnglish(context, word),
                Divider(),
                _getBangla(context, word),
                _getSplitMeaning(context, word)
              ],
            ),
          );
        });
  }  
  //begin split meaning
  Widget _getSplitMeaning(BuildContext context, JWord word) {
    if (word.sp == null) return Container();
    List<Widget> widgets = List<Widget>();
    widgets.add(Divider(
      color: Colors.red,
    ));
    _setSplitTextWidget(context, word, widgets);
    return Column(
      children: widgets,
    );
  }  
  Widget _splitTextWidget({String text, bool hasColor = true, bool hasWordSpac = false}) {
    Color color;
    if (hasColor) {
      switch (text) {
        case 'وَ':
          color = Colors.green;
          break;
       case 'أَ':case 'أ':
          color = Colors.lightBlue;
          break;
        case 'الْ': case 'ال':case 'اَلْ':
          color = Colors.cyan;
          break;
        case 'لِ':
          color = Colors.red;
          break;

        default:
          color = Colors.orange;
      }
      //meaning
      switch (text) {
        case 'وَ':
          text +=' : and এবং';
          break;
        case 'أَ':case 'أ':
           text +=' : interrogative particle প্রশ্নোত্তর কণা';
          break;
        case 'الْ':case 'ال':case 'اَلْ':
          text +=' : the টি';
          break;
        case 'لِ':
          text +=' : for, belongs to জন্য, সম্পর্কিত';
          break;

        default: text +=' : under construction';
          

      }
    }    
    return Container(child: Text(text, style:TextStyle(color: color, fontSize: 26.0) ,),);
  }

  void _setSplitTextWidget(BuildContext context, JWord word,  List<Widget> widgets) {
        
      int len = word.sp.length;
      if (len == 1) {        
        widgets.add(_splitTextWidget(
            text: word.word.substring(word.sp[0]), hasWordSpac: true));
      } else {
        int i = 0, pairIndex;
        bool isFirst = true;
        do {
          if (isFirst) {
            isFirst = false;
            widgets.add(_splitTextWidget(
              text: word.word.substring(word.sp[i], word.sp[i + 1]),
            ));
            pairIndex = i + 1;
            i += 2;
          } else {
            if (word.sp[pairIndex] == word.sp[i] && i + 1 < len) {
              widgets.add(_splitTextWidget(
                text: word.word.substring(word.sp[i], word.sp[i + 1]),
              ));
              pairIndex = i + 1;
              i += 2;
            } else {             
              if (len % 2 == 0 || i + 1 < len)
                isFirst = true;
              else {
                i++;
                pairIndex = i;
              }
            }
          }
        } while (i < len);

        if (len % 2 != 0) {
          widgets.add(_splitTextWidget(
              text: word.word.substring(word.sp[len - 1]), hasWordSpac: true));
        }       
    } 
  }
  //end split meaning
  TextSpan _textSpan({String text, bool hasColor = true, bool hasWordSpac = false}) {
    Color color;
    if (hasColor) {
      switch (text) {
        case 'وَ':
          color = Colors.green;
          break;
        case 'أَ': case 'أ':
          color = Colors.lightBlue;
          break;
        case 'الْ':case 'اَلْ': case 'ال':
          color = Colors.cyan;
          break;
        case 'لِ':
          color = Colors.red;
          break;

        default:
          color = Colors.orange;
      }
    }
    return TextSpan(
        text: text, style: hasColor ? TextStyle(color: color) : null);
  }

  TextSpan _getTextSpan(BuildContext context, JWord word) {
    final txtSpans = List<TextSpan>();
    if (word.sp != null) {
      int len = word.sp.length;
      if (len == 1) {
        if (word.sp[0] > 0)
          txtSpans.add(_textSpan(
              text: word.word.substring(0, word.sp[0]), hasColor: false));
        txtSpans.add(_textSpan(
            text: word.word.substring(word.sp[0]), hasWordSpac: true));
      } else {
        int i = 0, pairIndex;
        bool isFirst = true;
        do {
          if (isFirst) {
            isFirst = false;
            txtSpans.add(_textSpan(
              text: word.word.substring(word.sp[i], word.sp[i + 1]),
            ));
            pairIndex = i + 1;
            i += 2;
          } else {
            if (word.sp[pairIndex] == word.sp[i] && i + 1 < len) {
              txtSpans.add(_textSpan(
                text: word.word.substring(word.sp[i], word.sp[i + 1]),
              ));
              pairIndex = i + 1;
              i += 2;
            } else {
              txtSpans.add(_textSpan(
                  hasColor: false,
                  text: word.word.substring(word.sp[pairIndex], word.sp[i])));
              if (len % 2 == 0 || i + 1 < len)
                isFirst = true;
              else {
                i++;
                pairIndex = i;
              }
            }
          }
        } while (i < len);

        if (len % 2 != 0) {
          txtSpans.add(_textSpan(
              text: word.word.substring(word.sp[len - 1]), hasWordSpac: true));
        } else if (i < word.word.length && pairIndex < len) {
          txtSpans.add(_textSpan(
              hasWordSpac: true,
              hasColor: false,
              text: word.word.substring(word.sp[pairIndex])));
        }
      }
    } else {
      txtSpans
          .add(_textSpan(text: word.word, hasWordSpac: true, hasColor: false));
    }
    return TextSpan(
        style: Theme.of(context).textTheme.display1, children: txtSpans);
  }
  bool _isArabic(String str){
    if(str.isEmpty)return false;
    return str.trim().codeUnitAt(0)>1000;
  }
  Widget _getBangla(BuildContext context, JWord word) {
    String str = _getBanglaText(word);
    return RichText(
        text: TextSpan(text: str, style: Theme.of(context).textTheme.title));
  }

  String _getBanglaText(JWord word) {
     var vocabs = {'moon letters':'চাঁদ অক্ষর','sun letters':'সূর্য অক্ষর',
      'moon': 'চাঁদ','sun': 'সূর্য', 'this': 'এই, ইহা', 'that': 'উহা', 'yes': 'হাঁ','notebook':'নোটবই',
      'Exercise':'অনুশীলন','read':'অধ্যয়ন করা','write':'লেখা','lesson':'পাঠ','first':'প্রথম','second':'দ্বিতীয়','third':'তৃতীয়',
      'no': 'না', 'what': 'কি', 'house': 'বাড়ি', 'open': 'খোলা','broken':'ভাঙা','fourth':'চতুর্থ',
      'closed': 'বন্ধ', 'masjid': 'মসজিদ', 'mosque': 'মসজিদ', 'bed': 'বিছানা',
      'book': 'বই', 'boy': 'বালক', 'camel': 'উট', 'cat': 'বিড়াল','engineer':'প্রকৌশলী',
      'chair': 'চেয়ার', 'table': 'টেবিল', 'doctor': 'ডাক্তার', 'dog': 'কুকুর','noon':'দুপুর',
      'donkey': 'গাধা', 'door': 'দরজা', 'horse': 'ঘোড়া', 'kerchief': 'রূমাল',
      'key': 'চাবি', 'man': 'মানুষ', 'merchant': 'বণিক', 'pen': 'কলম','guest':'অতিথি',
      'rooster': 'গৃহপালিত মোরগ', 'shirt': 'জামা', 'dress': 'জামা','star': 'তারকা',      
      'student': 'ছাত্র', 'teacher': 'শিক্ষক', 'imam': 'এমাম', 'milk': 'দুধ','air':'বায়ু',
      'stone': 'পাথর', 'sugar': 'চিনি', 'far away': 'দূরে', 'heavy': 'ভারী','meat':'মাংস',
      'hot': 'গরম', 'light': 'হালকা', 'near': 'কাছাকাছি', 'new': 'নতুন','chest':'বুক','nail':'নখ',
      'old': 'পুরাতন', 'dirty': 'অপরিচ্ছন্ন', 'big': 'বড়', 'cold': 'ঠাণ্ডা','bread':'রুটি',
      'beautiful': 'সুন্দর', 'apple': 'আপেল', 'clean': 'পরিষ্কার','paper': 'কাগজ','finger':'আঙ্গুল',      
      'poor': 'দরিদ্র', 'rich': 'ধনী', 'shop': 'দোকান', 'short': 'খাট','fish':'মাছ','soap':'সাবান',
      'sick': 'অসুস্থ', 'sitting': 'বসা', 'small': 'ছোট', 'standing': 'দাঁড়ান','brother':'ভাই',
      'sweet': 'মিষ্টি', 'tall': 'লম্বা', 'water': 'পানি','flower':'ফুল','daylight':'দিবালোক',
      'sky': 'আকাশ', 'classroom': 'শ্রেণীকক্ষ', 'room': 'ঘর','delicious':'সুস্বাদু','watch':'ঘড়ি',
      'bathroom': 'স্নানকক্ষ', 'toilet': 'টয়লেট', 'kitchen': 'রান্নাঘর','kaaba':'কাবা',      
      'market': 'বাজার', 'head master': 'প্রধানশিক্ষক, পরিচালক','bag': 'থলে','school': 'পাঠশালা', 'dinner':'ডিনার', 
      'director': 'প্রধানশিক্ষক, পরিচালক','car': 'গাড়ী','niversity': 'বিশ্ববিদ্যালয়','lunch':'দুপুরের খাবার',      
      'girl': 'মেয়ে', 'daughter': 'কন্যা', 'here': 'এখানে','maternal uncle': 'মামা','friend':'বন্ধু',     
      'messenger': 'রাসূল', 'name': 'নাম', 'paternal uncle': 'চাচা','son': 'পুত্র','prayer':'প্রার্থনা',      
      'street': 'রোড', 'under': 'নিচে', 'there': 'সেখানে','father':'বাবা','heaven':'স্বর্গ','sunset':'সূর্যাস্ত',
      //pronouns
      'he':'তিনি','she':'তিনি','it':'ইহা','whose': 'কাহার','who':'কে, কাহারা','you':'তুমি','i':'আমি',
      //prepositions
      'on': 'উপর','in': 'ভিতর','from':'হইতে', 'where': 'কোথায়','to':'দিকে',
      //Names
      'Muhammad':'মুহাম্মদ','Yasir':'ইয়াসির','Aminah':'আমিনা','Zaynab':'যয়নব','Omar':'ওমর','Hamid':'হামিদ','Abbas':'আব্বাস','Ali':'আলী',
      'Fatima':'ফাতিমা','Khadija':'খাদিজা','Khalid':'খালিদ',
      'China':'চীন','India':'ভারত','Japan':'জাপান','Philippines':'ফিলিপাইন',
      //verb
      'went':'চলে গেছে','went out':'বাহিরে গেছে',
      //b1-lesson6
      'bicycle': 'সাইকেল', 'farmer': 'কৃষক', 'coffee': 'কফি','fast': 'দ্রুতগামী',      
      'cow': 'গাভী', 'fridge': 'রেফ্রিজারেটর', 'ear': 'কান', 'hand': 'হাত',
      'east': 'পূর্ব', 'head': 'মাথা', 'eye': 'চোখ','iron (for ironing)': 'ইস্ত্রি',      
      'face': 'মুখ', 'leg': 'পা', 'tea': 'চা', 'pot': 'পাত্র', 'mouth': 'মুখ','west': 'পশ্চিম',      
      'nose': 'নাক', 'window': 'জানলা', 'spoon': 'চামচ', 
      //b1-lesson7
      'she-camel':'উষ্ট্রী','duck':'হাঁস','egg':'ডিম','nurse':'নার্স','hen':'মুরগি',
    };
    
    String str = '';
    if (word.english.startsWith('a ')) str = 'একটি  ';
    
    if (word.bangla.isEmpty) {
      var keys =
          vocabs.keys.where((String key) => word.english == key).toList();
      if (keys.length > 0) {
        str += vocabs[keys[0]];
      } else {
        var keys = vocabs.keys
            .where((String key) => word.english.contains(key)).toList();                        
        if (keys.length > 0) {
          str += vocabs[keys.reduce((val, el)=> val.length<el.length?el:val)];
        }
      }
    }
    if (word.english.startsWith('and ')) str = 'এবং '+str;
    if (word.english.startsWith('the ')) str += 'টি';
    else if (word.english.contains(' the ')) str += 'টি';
    
    str += word.bangla;
    return str;
  }

  Widget _getEnglish(BuildContext context, JWord word) {
    return RichText(
        text: TextSpan(
            text: word.english, style:_isArabic(word.english)?Theme.of(context).textTheme.headline: Theme.of(context).textTheme.title));
  }
}
