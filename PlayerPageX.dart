import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/foundation.dart';
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
  String getHtmlStr() {
    var arr = widget.videoList
        .where((e) => e.id != null)
        .map((v) => '\'${v.id}\'')
        .join(',');
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
     <script language="JavaScript" type="text/javascript" src="https://www.youtube.com/iframe_api"></script> 
     
</head>
<body onclick="onTab()" style="margin:0;padding:0;background-color: black;">
   
    <div id="playerbox"></div> 
    
    <script language="JavaScript" type="text/javascript">
       
  var player,tid, iframe, vid='${widget.video.id}', videos=[$arr], second=${widget.lessRanSeconds};
  function onYouTubeIframeAPIReady() {
    player = new YT.Player('playerbox', {
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
  
  function onPlayerError(event){
    //player.loadVideoById(vid);
    ShowError.postMessage(event.data.toString());
  }
  function prev(){
    var index=videos.indexOf(vid);
    if(index==0)return;
    vid=videos[(index-1)%videos.length];
    player.loadVideoById(vid);
    Print.postMessage(vid);
  }
  function next(){
      vid=videos[(videos.indexOf(vid)+1)%videos.length];
      player.loadVideoById(vid);
      Print.postMessage(vid);
  }
  function onPlayerReady(event) {
    iframe=document.getElementById('playerbox');
    iframe.width=screen.width+ 'px';
    event.target.seekTo(second);
    tid=setInterval(function(){
        onPlayerStateChange({data:player.getPlayerState()})
    },1000);
  }
  function dispose(){
      clearInterval(tid);
      //player.pauseVideo();
      player.stopVideo();
      player.destroy();
  }
  function onPlayerStateChange(event) {
    if (event.data == 0) {
      next();
    } else if (event.data == 1/*||event.data == 2||event.data == 3*/) {
      Print.postMessage(player.getCurrentTime()+'###'+player.getDuration()+'###'+vid);
    } 
  }
  function onTab(){
    Print.postMessage('tab');
  }
   </script>
</body>
</html>
''';
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  _loadHtmlFromAssets(WebViewController controller) async {
    //String fileText = await rootBundle.loadString('assets/index.html');

    final String contentBase64 =
        base64Encode(const Utf8Encoder().convert(getHtmlStr()));
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
            /*gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              new Factory<OneSequenceGestureRecognizer>(
                () => new TapGestureRecognizer()
                  ..onTapUp = (_) {
                    print('--------------sdsdsdsds-------------');
                  },
              ),
            ].toSet(),*/
            javascriptChannels: <JavascriptChannel>[
              JavascriptChannel(
                  name: 'ShowError',
                  onMessageReceived: (event) {
                    String msg = '';
                    switch (event.message) {
                      case '2':
                        msg =
                            'The request contains an invalid parameter value. For example, this error occurs if you specify a video ID that does not have 11 characters, or if the video ID contains invalid characters, such as exclamation points or asterisks.';
                        break;
                      case '5':
                        msg =
                            'The requested content cannot be played in an HTML5 player or another error related to the HTML5 player has occurred';
                        break;
                      case '100':
                        msg =
                            'The video requested was not found. This error occurs when a video has been removed (for any reason) or has been marked as private.';
                        break;
                      case '101':
                      case '150':
                        msg =
                            'The owner of the requested video does not allow it to be played in embedded players.';
                        break;

                      default:
                        msg = 'Unknown error: ${event.message}';
                    }
                    Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text(msg)),
                    );
                  }),
              JavascriptChannel(
                  name: 'Print',
                  onMessageReceived: (mm) {
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
            /*navigationDelegate: (NavigationRequest request) {
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
            },
            gestureNavigationEnabled: true,*/
          ),
        );
      }),
      floatingActionButton: favoriteButtons(),
    );
  }

  Widget favoriteButtons() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          if (controller.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: 'tag1',
                  onPressed: () {
                    controller.data.evaluateJavascript('prev();');
                  },
                  child: const Icon(Icons.keyboard_arrow_up),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: FloatingActionButton(
                    heroTag: 'tag2',
                    onPressed: () {
                      controller.data.evaluateJavascript('next();');
                    },
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ),
                FloatingActionButton(
                  heroTag: 'tag3',
                  onPressed: () {
                    controller.data.evaluateJavascript('dispose();');
                    Util.setDeviceOrientation(false);
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Icons.arrow_back),
                ),
              ],
            );
          }
          return Container();
        });
  }
}
