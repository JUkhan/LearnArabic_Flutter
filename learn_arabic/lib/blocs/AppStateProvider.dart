 
import 'package:flutter/material.dart';
import './StateMgmtBloc.dart';

class AppStateProvider extends InheritedWidget{

  final stateMgmtBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget)=>true;

  static StateMgmtBloc of(BuildContext context)=>
  (context.inheritFromWidgetOfExactType(AppStateProvider) as AppStateProvider).stateMgmtBloc;

  AppStateProvider({Key key, Widget child, @required StateMgmtBloc stateMgmtBloc}):
  stateMgmtBloc=stateMgmtBloc,
  super(key:key, child:child);
  
}