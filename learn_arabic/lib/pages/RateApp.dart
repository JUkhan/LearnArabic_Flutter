import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RateApp extends StatelessWidget {
  const RateApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate the App'),
      ),
      body: WebView(
        initialUrl:
            'https://play.google.com/store/apps/details?id=com.zaitun.learnarabic',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {},
      ),
    );
  }
}
