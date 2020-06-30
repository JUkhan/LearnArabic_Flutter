import 'package:learn_arabic/blocs/models/BookInfo.dart';

class MemoModel {
  double lessRanSeconds;
  final String videoId;
  final bool tts;
  final double fontSize;
  final int theme;
  final double wordSpace;
  final String wordIndex;
  final JWord selectedWord;
  final int prevSelectedWordId;
  double scrollOffset;
  final bool isLandscape;
  double videoProgress;
  String pageIndexPerScroll;
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
      this.prevSelectedWordId,
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
      int theme,
      JWord selectedWord,
      int prevSelectedWordId,
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
        prevSelectedWordId: prevSelectedWordId ?? this.prevSelectedWordId,
        lectureCategory: lectureCategory ?? this.lectureCategory,
        wordMeaningCategory: wordMeaningCategory ?? this.wordMeaningCategory,
        pageIndexPerScroll: pageIndexPerScroll ?? this.pageIndexPerScroll,
        tts: tts ?? this.tts);
  }

  String get getWordSpace => ' ' * wordSpace.toInt();

  factory MemoModel.init() => MemoModel(
      theme: 4278190080,
      lessRanSeconds: 0,
      wordSpace: 1.0,
      tts: false,
      scrollOffset: 0.0,
      fontSize: 1.0,
      wordMeaningCategory: 1,
      lectureCategory: 1,
      videoProgress: 0.0,
      isLandscape: false);
}
