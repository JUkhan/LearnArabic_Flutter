import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../blocs/models/BookInfo.dart';

class JTextSpan extends TextSpan {
  final JWord word;
  final TapGestureRecognizer recognizer;
  JTextSpan({this.word, this.recognizer}):super(text:word.word, recognizer:recognizer){
    
  }
}

