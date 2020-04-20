import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/effects/bookEffects.dart';
import 'package:learn_arabic/blocs/states/MemoState.dart';
import 'package:learn_arabic/blocs/states/bookState.dart';
import 'package:learn_arabic/pages/App.dart';

void main() {
  return runApp(new App(
      block: createStore(
          states: [BookState(), MemoState()], effects: [BookEffects()])));
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
