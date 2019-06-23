import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';

class BookImageWidget extends StatefulWidget {
  final String bookName;
  BookImageWidget(this.bookName);
  @override
  _BookImageWidgetState createState() => new _BookImageWidgetState();
}

class _BookImageWidgetState extends State<BookImageWidget> {
  void _onTab() {
    dispatch(ActionTypes.CHANGE_BOOK_NAME, '/${widget.bookName}');
    Navigator.pushReplacementNamed(context, '/lessons');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: GestureDetector(
          child: Image.asset(
            'assets/images/${widget.bookName}.png',
          ),
          onTap: _onTab,
        ));
  }
}
