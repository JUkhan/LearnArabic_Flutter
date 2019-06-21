import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/models/AsyncData.dart';

class JErrorWidget extends StatelessWidget {
  final AsyncData asyncData;
  JErrorWidget(this.asyncData);
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: asyncData.asyncStatus == AsyncStatus.error ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        alignment: FractionalOffset.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red[200],
              size: 80.0,
            ),
            Container(
              padding: new EdgeInsets.only(top: 16.0),
              child: asyncData.asyncStatus == AsyncStatus.error
                  ? Text(
                      asyncData.errorMessage,
                      style: new TextStyle(
                        color: Colors.red[300],
                      ),
                    )
                  : null,
            )
          ],
        ),
      ),
    );
  }
}
