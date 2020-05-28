import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/effects/bookEffects.dart';
import 'package:learn_arabic/blocs/states/MemoState.dart';
import 'package:learn_arabic/blocs/states/PainterState.dart';
import 'package:learn_arabic/blocs/states/bookState.dart';
import 'package:learn_arabic/pages/App.dart';

void main() {
  createStore(
    states: [BookState(), MemoState(), PainterState()],
    effects: [BookEffects()],
  );
  /*exportState().listen((event) {
    print(
        '------ action type : ${event[0].type}, payload: ${event[0].payload}');
  });*/
  return runApp(new App());
}
//export PATH="$PATH:/Users/jukhan/development/flutter/bin"
//flutter build apk
//flutter install
//flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi
//flutter build appbundle --target-platform android-arm,android-arm64,android-x64
// /Users/jukhan/key.jks
//keytool -list -v -keystore keystore.jks -alias mydomain
//Owner: CN=jasim khan, OU=mobileApp, O=zaitun, L=Dhaka, ST=Banasree, C=BD
//keytool -genkeypair -alias mykey -keyalg RSA -keysize 2048 -validity 10000 -keystore keystore.jks
//keytool -export -rfc -alias upload -file upload_certificate.pem -keystore keystore.jks
//flutter devices
//flutter pub get
//export PUB_HOSTED_URL=https://pub.flutter-io.cn
//export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
//hi
