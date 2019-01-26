
import 'package:flutter/material.dart';
import '../blocs/StateMgmtBloc.dart';

class BookImageWidget extends StatefulWidget {
  final StateMgmtBloc bloc;
  final String bookName;
  BookImageWidget(this.bloc, this.bookName);
  @override
  _BookImageWidgetState createState() => new _BookImageWidgetState();
}

class _BookImageWidgetState extends State<BookImageWidget> {
  
  void _onTab(){    
    widget.bloc.navAction('/${widget.bookName}');
    Navigator.pushReplacementNamed(context, '/lessons');
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child:  GestureDetector(
      child:  Image.asset('assets/images/${widget.bookName}.png', ),
      onTap: _onTab,
      ));
  }
}