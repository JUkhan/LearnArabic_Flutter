
import 'dart:async';
import './BookBloc.dart';
import './SettingBloc.dart';

class StateMgmtBloc{
  BookBloc bookBloc;
  SettingBloc settingBloc;
  bool homePage=false;
  final _navStreamController=StreamController<String>.broadcast();
  StreamSubscription<String> _navSubscription;
  Function(String) get navAction=>_navStreamController.sink.add;

  StateMgmtBloc(){
    _navSubscription=_navStreamController.stream.listen((path){
      print(path+'--');
      
      switch (path) {
        case '/book1':
        case '/book2':
        case '/book3':        
          bookBloc.bookNameAction(path);
          
          break;
        default: homePage=path=='/';      
         
      }
      
    });
    bookBloc=BookBloc(rootBloc: this);
    settingBloc=SettingBloc();
  }

  dispose(){
    _navSubscription.cancel();
    _navStreamController.close();
    bookBloc.dispose();
  }
}