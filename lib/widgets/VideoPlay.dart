import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
class VideoPlay extends StatelessWidget {
  final String videoId;
  final String title;
  VideoPlay({this.title, this.videoId});
  @override
  Widget build(BuildContext context) {
    
    return new WebviewScaffold(
              url: 'https://youtube.com/embed/$videoId',
              appBar: new AppBar(
              title:  Text(title),
              ),
              withZoom: true,
              //withLocalStorage: true,
            );
  }
}