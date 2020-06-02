import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';
import 'package:learn_arabic/blocs/models/BookInfo.dart';
import 'package:learn_arabic/blocs/util.dart';
import 'package:flutter_youtube_view/flutter_youtube_view.dart';

class PlayerPage extends StatefulWidget {
  final JVideo video;
  final List<JVideo> videoList;
  final double lessRanSeconds;

  PlayerPage({Key key, this.video, this.videoList, this.lessRanSeconds})
      : super(key: key);

  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage>
    implements YouTubePlayerListener {
  @override
  void initState() {
    Util.setDeviceOrientation(true);
    super.initState();
  }

  @override
  void dispose() {
    dispatch(ActionTypes.NEW_MEMO_INSTANCE);
    Util.setDeviceOrientation(false);
    super.dispose();
  }

  //FlutterYoutubeViewController _controller;

  @override
  void onCurrentSecond(double second) {
    dispatch(ActionTypes.SAVE_LESS_RUNNING_TIME,
        {'totalTime': _duration, 'ranTime': second});
  }

  @override
  void onError(String error) {
    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text('Error: $error')),
    );
  }

  @override
  void onReady() {}

  @override
  void onStateChange(String state) {
    if (state == 'ENDED') {
      dispatch(ActionTypes.NEW_MEMO_INSTANCE);
      Util.setDeviceOrientation(false);
      Navigator.of(context).pop();
    }
  }

  double _duration;
  @override
  void onVideoDuration(double duration) {
    _duration = duration;
  }

  void _onYoutubeCreated(FlutterYoutubeViewController controller) {
    //_controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text(widget.video.title),
      ),*/
      body: FlutterYoutubeView(
          onViewCreated: _onYoutubeCreated,
          listener: this,
          scaleMode: YoutubeScaleMode.none, // <option> fitWidth, fitHeight
          params: YoutubeParam(
            videoId: widget.video.id,
            showUI: true,
            startSeconds: widget.lessRanSeconds, // <option>
            autoPlay: true,
            showYoutube: true,
            showFullScreen: false,
          )
          // <option>
          ),
      //floatingActionButton: _favoriteButtons(),
    );
  }
}
