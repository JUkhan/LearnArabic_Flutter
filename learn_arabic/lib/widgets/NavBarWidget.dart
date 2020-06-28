import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/models/BookInfo.dart';
import 'package:learn_arabic/blocs/models/MemoModel.dart';
import 'package:learn_arabic/blocs/util.dart';

class NavBarWidget extends StatelessWidget {
  const NavBarWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _navBar(context);
  }

  Widget _navBar(BuildContext context) {
    return StreamBuilder<JWord>(
        initialData: JWord.empty(),
        stream: select<MemoModel>('memo')
            .map((memo) => memo.selectedWord)
            .where((book) => book != null),
        builder: (_, snapshot) => snapshot.data.word.isEmpty
            ? BottomAppBar()
            : BottomAppBar(
                color: Theme.of(context).backgroundColor,
                //elevation: 4.0,
                //hasNotch: true,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        (Util.wordMeanCategory == 1
                            ? snapshot.data.english
                            : Util.wordMeanCategory == 2
                                ? _getBanglaText(snapshot.data)
                                : snapshot.data.english +
                                    ' ' +
                                    _getBanglaText(snapshot.data)),
                        textDirection: Util.isArabic(snapshot.data.english)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        textAlign: TextAlign.center,
                        style: Util.isArabic(snapshot.data.english)
                            ? Theme.of(context).textTheme.headline5
                            : Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Details meaning',
                      icon: Icon(Icons.details),
                      onPressed: () {
                        _showBottomSheet(context, snapshot.data);
                      },
                    ),
                  ],
                ),
              ));
  }

  void _showBottomSheet(BuildContext context, JWord word) {
    showModalBottomSheet(
        context: context,
        builder: (bc) {
          return Container(
            //color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                RichText(
                  textDirection: TextDirection.rtl,
                  text: _getTextSpan(context, word),
                ),
                Divider(),
                Util.wordMeanCategory == 1
                    ? _getEnglishOnly(context, word)
                    : Util.wordMeanCategory == 2
                        ? _getBanglaOnly(context, word)
                        : _getBoth(context, word)
              ],
            ),
          );
        });
  }

  Widget _getBoth(BuildContext context, JWord word) {
    return Column(
      children: <Widget>[
        _getEnglish(context, word),
        Divider(),
        _getBangla(context, word),
        _getSplitMeaning(context, word)
      ],
    );
  }

  Widget _getBanglaOnly(BuildContext context, JWord word) {
    return Column(
      children: <Widget>[
        _getBangla(context, word),
        _getSplitMeaning(context, word)
      ],
    );
  }

  Widget _getEnglishOnly(BuildContext context, JWord word) {
    return Column(
      children: <Widget>[
        _getEnglish(context, word),
        _getSplitMeaning(context, word)
      ],
    );
  }

  //begin split meaning
  Widget _getSplitMeaning(BuildContext context, JWord word) {
    if (word.sp == null) return Container();
    List<Widget> widgets = List<Widget>();
    widgets.add(Divider());
    _setSplitTextWidget(context, word, widgets);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _splitTextWidget(
      {String text, bool hasColor = true, bool hasWordSpac = false}) {
    Color color;
    if (hasColor) {
      color = Util.getColor(text);
      text = Util.getSplitedText(Util.getText(text));
    }
    return Container(
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 18.0),
      ),
    );
  }

  void _setSplitTextWidget(
      BuildContext context, JWord word, List<Widget> widgets) {
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
  TextSpan _textSpan(
      {String text, bool hasColor = true, bool hasWordSpac = false}) {
    return TextSpan(
        text: text,
        style: hasColor ? TextStyle(color: Util.getColor(text)) : null);
  }

  TextSpan _getTextSpan(BuildContext context, JWord word) {
    final txtSpans = List<TextSpan>();
    String str = word.word.replaceAll('؟', '').replaceAll('.', '');
    if (word.sp != null) {
      int len = word.sp.length;
      if (len == 1) {
        txtSpans.add(
            _textSpan(text: str.substring(0, word.sp[0]), hasColor: false));
        txtSpans
            .add(_textSpan(text: str.substring(word.sp[0]), hasWordSpac: true));
      } else {
        int i = 0, pairIndex;
        bool isFirst = true;
        if (word.sp[0] > 0)
          txtSpans.add(
              _textSpan(text: str.substring(0, word.sp[0]), hasColor: false));
        do {
          if (isFirst) {
            isFirst = false;
            txtSpans.add(_textSpan(
              text: str.substring(word.sp[i], word.sp[i + 1]),
            ));
            pairIndex = i + 1;
            i += 2;
          } else {
            if (word.sp[pairIndex] == word.sp[i] && i + 1 < len) {
              txtSpans.add(_textSpan(
                text: str.substring(word.sp[i], word.sp[i + 1]),
              ));
              pairIndex = i + 1;
              i += 2;
            } else {
              txtSpans.add(_textSpan(
                  hasColor: false,
                  text: str.substring(word.sp[pairIndex], word.sp[i])));
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
              text: str.substring(word.sp[len - 1]), hasWordSpac: true));
        } else if (i < str.length && pairIndex < len) {
          txtSpans.add(_textSpan(
              hasWordSpac: true,
              hasColor: false,
              text: str.substring(word.sp[pairIndex])));
        }
      }
    } else {
      txtSpans.add(_textSpan(text: str, hasWordSpac: true, hasColor: false));
    }
    //Colors.grey[400]:Colors.black.withOpacity(0.9)
    return TextSpan(
        style: Theme.of(context).textTheme.headline4, children: txtSpans);
  }

  Widget _getBangla(BuildContext context, JWord word) {
    String str = _getBanglaText(word);
    return RichText(
        text:
            TextSpan(text: str, style: Theme.of(context).textTheme.headline6));
  }

  String _getBanglaText(JWord word) {
    var vocabs = {
      'Allah': 'আল্লাহ', 'moon letters': 'চাঁদ অক্ষর',
      'sun letters': 'সূর্য অক্ষর', 'which': 'যেটি',
      'moon': 'চাঁদ', 'sun': 'সূর্য', 'this': 'এই, ইহা', 'that': 'উহা',
      'yes': 'হাঁ', 'notebook': 'নোটবই',
      'Exercise': 'অনুশীলন',
      'read': 'অধ্যয়ন করা',
      'write': 'লেখা',
      'lesson': 'পাঠ',
      'first': 'প্রথম',
      'second': 'দ্বিতীয়',
      'third': 'তৃতীয়',
      'ninth': 'নবম',
      'no': 'না', 'what': 'কি', 'house': 'বাড়ি', 'open': 'খোলা',
      'broken': 'ভাঙা', 'fourth': 'চতুর্থ', 'eighth': 'অষ্টম',
      'closed': 'বন্ধ', 'masjid': 'মসজিদ', 'mosque': 'মসজিদ', 'bed': 'বিছানা',
      'book': 'বই', 'boy': 'বালক', 'camel': 'উট', 'cat': 'বিড়াল',
      'engineer': 'প্রকৌশলী',
      'chair': 'চেয়ার', 'table': 'টেবিল', 'doctor': 'ডাক্তার', 'dog': 'কুকুর',
      'noon': 'দুপুর',
      'donkey': 'গাধা', 'door': 'দরজা', 'horse': 'ঘোড়া', 'kerchief': 'রূমাল',
      'key': 'চাবি', 'man': 'মানুষ', 'men': 'মানুষ', 'merchant': 'বণিক',
      'pen': 'কলম', 'guest': 'অতিথি',
      'rooster': 'গৃহপালিত মোরগ', 'shirt': 'জামা', 'dress': 'জামা',
      'star': 'তারকা',
      'student': 'ছাত্র', 'teacher': 'শিক্ষক', 'imam': 'এমাম', 'milk': 'দুধ',
      'air': 'বায়ু',
      'stone': 'পাথর', 'sugar': 'চিনি', 'far away': 'দূরে', 'heavy': 'ভারী',
      'meat': 'মাংস',
      'hot': 'গরম', 'light': 'হালকা', 'near': 'কাছাকাছি', 'new': 'নতুন',
      'chest': 'বুক', 'nail': 'নখ',
      'old': 'পুরাতন', 'dirty': 'অপরিচ্ছন্ন', 'big': 'বড়', 'cold': 'ঠাণ্ডা',
      'bread': 'রুটি',
      'beautiful': 'সুন্দর', 'apple': 'আপেল', 'clean': 'পরিষ্কার',
      'paper': 'কাগজ', 'finger': 'আঙ্গুল',
      'poor': 'দরিদ্র', 'rich': 'ধনী', 'shop': 'দোকান', 'short': 'খাট',
      'fish': 'মাছ', 'soap': 'সাবান',
      'sick': 'অসুস্থ', 'sitting': 'বসা', 'small': 'ছোট', 'standing': 'দাঁড়ান',
      'brother': 'ভাই',
      'sweet': 'মিষ্টি', 'tall': 'লম্বা', 'water': 'পানি', 'flower': 'ফুল',
      'daylight': 'দিবালোক',
      'sky': 'আকাশ', 'classroom': 'শ্রেণীকক্ষ', 'room': 'ঘর',
      'delicious': 'সুস্বাদু', 'watch': 'ঘড়ি',
      'bathroom': 'স্নানকক্ষ', 'toilet': 'টয়লেট', 'kitchen': 'রান্নাঘর',
      'kaaba': 'কাবা',
      'market': 'বাজার', 'head master': 'প্রধানশিক্ষক, পরিচালক', 'bag': 'থলে',
      'school': 'পাঠশালা', 'dinner': 'ডিনার',
      'director': 'প্রধানশিক্ষক, পরিচালক', 'car': 'গাড়ী',
      'niversity': 'বিশ্ববিদ্যালয়', 'lunch': 'দুপুরের খাবার',
      'girl': 'মেয়ে', 'daughter': 'কন্যা', 'here': 'এখানে',
      'maternal uncle': 'মামা', 'friend': 'বন্ধু',
      'messenger': 'রাসূল', 'name': 'নাম', 'paternal uncle': 'চাচা',
      'son': 'পুত্র', 'prayer': 'প্রার্থনা',
      'street': 'রোড', 'under': 'নিচে', 'there': 'সেখানে', 'father': 'বাবা',
      'heaven': 'স্বর্গ', 'sunset': 'সূর্যাস্ত',
      //pronouns
      'he': 'তিনি', 'she': 'তিনি', 'it': 'ইহা', 'whose': 'কাহার',
      'who': 'কে, কাহারা', 'you': 'তুমি',
      //prepositions
      'on': 'উপর', 'in': 'ভিতর', 'from': 'হইতে', 'where': 'কোথায়',
      'to': 'দিকে',
      //Names
      'Muhammad': 'মুহাম্মদ',
      'Yasir': 'ইয়াসির',
      'Omar': 'ওমর',
      'Hamid': 'হামিদ',
      'Abbas': 'আব্বাস',
      'Ali': 'আলী',
      'Saeed': 'সাঈদ',
      'Mahmood': 'মাহমুদ',
      'Fatima': 'ফাতিমা', 'Khadija': 'খাদিজা', 'Khalid': 'খালিদ',
      'Aminah': 'আমিনা', 'Zaynab': 'যয়নব', 'Bilal': 'বিলাল',
      'China': 'চীন', 'India': 'ভারত', 'Japan': 'জাপান',
      'Philippines': 'ফিলিপাইন', 'Iraq': 'ইরাক', 'Leila': 'লেইলা',
      //verb
      'went': 'চলে গেছে', 'went out': 'বাহিরে গেছে',
      //b1-lesson6
      'bicycle': 'সাইকেল', 'farmer': 'কৃষক', 'coffee': 'কফি',
      'fast': 'দ্রুতগামী',
      'cow': 'গাভী', 'fridge': 'রেফ্রিজারেটর', 'ear': 'কান', 'hand': 'হাত',
      'mother': 'মাতা',
      'east': 'পূর্ব', 'head': 'মাথা', 'eye': 'চোখ',
      'iron (for ironing)': 'ইস্ত্রি',
      'face': 'মুখ', 'leg': 'পা', 'tea': 'চা', 'pot': 'রান্নার পাত্র',
      'mouth': 'মুখ', 'west': 'পশ্চিম',
      'nose': 'নাক', 'window': 'জানলা', 'spoon': 'চামচ',
      //b1-lesson7
      'she-camel': 'উষ্ট্রী', 'duck': 'হাঁস', 'egg': 'ডিম', 'nurse': 'নার্স',
      'hen': 'মুরগি', 'muazzin': 'মুয়াজজিন', 'sister': 'বোন',
      //b1-lesson8
      'America': 'আমেরিকা',
      'Switzerland': 'সুইজর্ল��্ড',
      'knife': 'ছুরি',
      'Germany': 'জার��মানি',
      'England': 'ইংল্যান্ড',
      'hospital': 'হাসপাতাল',
      'behind': 'পিছনে',
      'in front of': 'সামনে',
      'France': 'ফ্রান্স',
      'writing board': 'লেখার বোর্ড',
      'sat': 'বসেছিল',
      //b1-lesson9
      'lazy': 'অলস',
      'hungry': 'ক্ষুধার্ত',
      'thirsty': 'তৃষ্ণার্ত',
      'angry': 'ক্রুদ্ধ',
      'full': 'সম্পূর্ণ',
      'fruit': 'ফল',
      'English(language)': 'ইংরেজী ভাষা',
      'sparrow': 'চড়ুই',
      'difficult': 'কঠিন',
      'bird': 'পাখি',
      'city': 'শহর',
      'Arabic': 'আরবি',
      'Cairo': 'কায়রো',
      'language': 'ভাষা',
      'today': 'আজ',
      'easy': 'সহজ',
      'why': 'কেন',
      'hardworking': 'কঠোর পরিশ্রম',
      'cup': 'কাপ',
      'famous': 'বিখ্যাত',
      'library': 'গ্রন্থাগার',
      'secondary school': 'মাধ্যমিক বিদ্যালয়',
      'now': 'এখন',
      'minister': 'মন্ত্রী',
      'sharp': 'তীক্ষ্ন',
      'fan': 'পাখা',
      'Indonesia': 'ইন্দোনেশিয়া',
      'Kuwait': 'কুয়েত',
      'example': 'উদাহরণ',
      'field': 'মাঠ',
      'they': 'তাহারা',
      //b1-lesson10
      'classmate': 'সহপাঠী',
      'husband': 'স্বামী',
      'child': 'শিশু',
      'young man': 'যুবক',
      'one': 'এক',
      'garden': 'বাগান',
      'with': 'সঙ্গে',
      'also': 'এছাড়াও',
      'Urdu': 'উর্দু',
      'condition': 'অবস্থা',
      'Amina': 'আমিনা',
      'peace': 'শান্তি',
      'pilgrim': 'তীর্থযাত্রী',
      //b2-lesson1-lesson2
      'for': 'জন্য',
      'belongs to': 'সম্পর্কিত',
      'after': 'পরে',
      'Malaysia': 'মাল্যাশিয়া',
      'young lady': 'তরুণী',
      'maternity hospital': 'প্রসূতি - হাসপাতাল',
      'aunt': 'ফুফি,খালা',
      'tree': 'গাছ',
      'Syria': 'সিরিয়া',
      'inspector': 'পরিদর্শক',
      'Sir': 'জনাব',
      'Madam': 'ভদ্রমহিলা',
      'strong': 'শক্তিশালী',
      'weak': 'দুর্বল',
      'scholar': 'পণ্ডিত',
      "praise": "প্রশংসা",
      'Madinah': 'মদীনা',
      'secondary': 'মাধ্যমিক',
      'medium': 'মধ্যম',
      'restaurant': 'রেস্তোরাঁ',
      'these': 'এইগুলো, এই সকল',
      'village': 'গ্রাম',
      'Turkey': 'তুরস্ক',
      'muslim': 'মুসলমান',
      'elementary': 'প্রাথমিক',
      'wife': 'স্ত্রী',
      'woman': 'নারী',
      'women': 'নারী',
      'young ladies': 'তরুণ মহিলা',
      'Mariam': 'মারিয়াম',
      'their': 'তাদের',
      'those': 'যাহারা, সেগুলো',
      //b2-lesson4
      'young': 'তরুণ',
      //end short key length
      'i': 'আমি', 'oh': 'ওহ,ইয়া'
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
            .where((String key) => word.english.contains(key))
            .toList();
        if (keys.length > 0) {
          str += vocabs[
              keys.reduce((val, el) => val.length < el.length ? el : val)];
        }
      }
    }
    if (word.english.startsWith('and ')) str = 'এবং ' + str;
    if (word.english.startsWith('the '))
      str += 'টি';
    else if (word.english.contains(' the ')) str += 'টি';

    str += word.bangla;
    return str;
  }

  Widget _getEnglish(BuildContext context, JWord word) {
    return RichText(
        text: TextSpan(
            text: word.english,
            style: Util.isArabic(word.english)
                ? Theme.of(context).textTheme.headline5
                : Theme.of(context).textTheme.headline6));
  }
}
