import 'package:flutter/material.dart';
import '../blocs/models/AsyncData.dart';

class LoadingWidget extends StatelessWidget {
  final AsyncData asyncData;
  LoadingWidget(this.asyncData);
  @override
  Widget build(BuildContext context) {
    return new AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: asyncData.asyncStatus == AsyncStatus.loading ? 1.0 : 0.0,
      child: Container(
        alignment: FractionalOffset.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
