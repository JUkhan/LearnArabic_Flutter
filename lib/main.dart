import 'package:flutter/material.dart';

import './pages/App.dart';

import 'blocs/StateMgmtBloc.dart';

void main() => runApp(new App(block: StateMgmtBloc()));

