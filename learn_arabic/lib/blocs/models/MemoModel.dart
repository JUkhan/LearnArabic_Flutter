import 'package:learn_arabic/blocs/models/BookInfo.dart';
import 'package:learn_arabic/blocs/util.dart';

class MemoModel {
  final double lessRanSeconds;
  final String videoId;
  final bool tts;
  final double fontSize;
  final Themes theme;
  final double wordSpace;
  final String wordIndex;
  final JWord selectedWord;
  final double scrollOffset;
  final bool isLandscape;
  final double videoProgress;
  final String pageIndexPerScroll;
  final int wordMeaningCategory;
  final int lectureCategory;

  MemoModel(
      {this.lessRanSeconds,
      this.videoId,
      this.tts,
      this.fontSize,
      this.theme,
      this.pageIndexPerScroll,
      this.selectedWord,
      this.isLandscape,
      this.scrollOffset,
      this.wordIndex,
      this.videoProgress,
      this.lectureCategory,
      this.wordMeaningCategory,
      this.wordSpace});

  MemoModel copyWith(
      {double lessRanSeconds,
      String videoId,
      bool tts,
      double fontSize,
      Themes theme,
      JWord selectedWord,
      bool isLandscape,
      double scrollOffset,
      double videoProgress,
      String pageIndexPerScroll,
      String wordIndex,
      int lectureCategory,
      int wordMeaningCategory,
      double wordSpace}) {
    return MemoModel(
        lessRanSeconds: lessRanSeconds ?? this.lessRanSeconds,
        videoId: videoId ?? this.videoId,
        fontSize: fontSize ?? this.fontSize,
        theme: theme ?? this.theme,
        videoProgress: videoProgress ?? this.videoProgress,
        selectedWord: selectedWord ?? this.selectedWord,
        wordIndex: wordIndex ?? this.wordIndex,
        scrollOffset: scrollOffset ?? this.scrollOffset,
        isLandscape: isLandscape ?? this.isLandscape,
        wordSpace: wordSpace ?? this.wordSpace,
        lectureCategory: lectureCategory ?? this.lectureCategory,
        wordMeaningCategory: wordMeaningCategory ?? this.wordMeaningCategory,
        pageIndexPerScroll: pageIndexPerScroll ?? this.pageIndexPerScroll,
        tts: tts ?? this.tts);
  }

  String get getWordSpace {
    var s = '';
    for (var i = 0.0; i < wordSpace; i++) s += ' ';
    return s;
  }
}
