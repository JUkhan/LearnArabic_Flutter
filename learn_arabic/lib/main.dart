import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/effects/bookEffects.dart';
import 'package:learn_arabic/blocs/states/bookState.dart';
import 'package:learn_arabic/pages/App.dart';

void main() {
  return runApp(new App(
      block: createStore(states: [BookState()], effects: [BookEffects()])));
}
//export PATH="$PATH:/Users/jukhan/development/flutter/bin"
//flutter build apk
//flutter install
//flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi
//flutter build appbundle --target-platform android-arm,android-arm64,android-x64
// /Users/jukhan/key.jks
