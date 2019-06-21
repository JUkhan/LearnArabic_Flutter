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
