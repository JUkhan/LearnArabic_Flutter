import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';
import 'package:learn_arabic/blocs/models/BookInfo.dart';
import 'package:learn_arabic/blocs/util.dart';
import 'dart:async';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';

//import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerPage extends StatefulWidget {
  final JVideo video;
  final List<JVideo> videoList;
  final double lessRanSeconds;
  PlayerPage({Key key, this.video, this.videoList, this.lessRanSeconds})
      : super(key: key);

  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  String rawHtml = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
     <script language="JavaScript" type="text/javascript" src="https://www.youtube.com/iframe_api"></script> 
     
</head>
<body style="margin:0;padding:0;background-color: black;">
   
    <div id="player"></div> 
    
    <script language="JavaScript" type="text/javascript">
       
  var player,tid, iframe, vid='#VID#', videos=[#VARR#], second=#TIME#;
  function onYouTubeIframeAPIReady() {
    player = new YT.Player('player', {
      playerVars: { 'autoplay': 1 },
      videoId: vid,
        events: {
          'onReady': onPlayerReady,
          'onStateChange': onPlayerStateChange,
          'onError': onPlayerError
        }
    });
  }
  window.onresize=function(){
    iframe.width=screen.width+ 'px';
  };
  
  function onPlayerError(){
    player.loadVideoById(vid);
  }
  function onPlayerReady(event) {
    iframe=document.getElementById('player');
    iframe.width=screen.width+ 'px';
    event.target.seekTo(second);
    tid=setInterval(function(){
        onPlayerStateChange({data:player.getPlayerState()})
    },1000);
  }
  function dispose(){
      clearInterval(tid);
  }
  function onPlayerStateChange(event) {
    if (event.data == 0) {
        var index=videos.indexOf(vid)+1;
        vid=videos[index%videos.length];
        player.loadVideoById(vid);
        Print.postMessage(vid);
    } else if (event.data == 1/*||event.data == 2||event.data == 3*/) {
      Print.postMessage(player.getCurrentTime()+'###'+player.getDuration()+'###'+vid);
    } 
  }
   </script>
</body>
</html>
''';
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  _loadHtmlFromAssets(WebViewController controller) async {
    //String fileText = await rootBundle.loadString('assets/index.html');

    final String contentBase64 = base64Encode(const Utf8Encoder().convert(
        rawHtml
            .replaceFirst(RegExp(r'#VID#'), widget.video.id, 450)
            .replaceFirst(
                RegExp(r'#VARR#'),
                widget.videoList
                    .where((e) => e.id != null)
                    .map((v) => '\'${v.id}\'')
                    .join(','),
                450)
            .replaceFirst(
                RegExp(r'#TIME#'), widget.lessRanSeconds.toString(), 450)));
    await controller.loadUrl('data:text/html;base64,$contentBase64');
  }

  @override
  void initState() {
    Util.setDeviceOrientation(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return SafeArea(
          child: WebView(
            initialUrl: 'about:blank', //'https://flutter.dev',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
              _loadHtmlFromAssets(webViewController);
            },

            javascriptChannels: <JavascriptChannel>[
              JavascriptChannel(
                  name: 'Print',
                  onMessageReceived: (mm) {
                    print(mm.message + '---------->>');
                    var arr = mm.message.split('###');
                    if (arr.length == 3) {
                      dispatch(ActionTypes.SAVE_LESS_RUNNING_TIME, {
                        'totalTime': double.parse(arr[1]),
                        'ranTime': double.parse(arr[0])
                      });
                    } else {
                      dispatch(ActionTypes.SET_VIDEO_ID, arr[0]);
                    }
                  })
            ].toSet(),
            /* navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                print('blocking navigation to $request}');
                return NavigationDecision.prevent;
              }
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              print('-----------------Page started loading: $url');
            },
            onPageFinished: (String url) {
              print('~~~~~~~~~~~~~~~~~~~~~~~~Page finished loading: $url');
            },*/
            //gestureNavigationEnabled: true,
          ),
        );
      }),
      floatingActionButton: favoriteButton(),
    );
  }

  Widget favoriteButton() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          if (controller.hasData) {
            return FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.data.evaluateJavascript('dispose();');
                Util.setDeviceOrientation(false);
              },
              child: const Icon(Icons.arrow_back),
            );
          }
          return Container();
        });
  }
}
