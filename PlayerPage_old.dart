/*import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';
import 'package:learn_arabic/blocs/models/BookInfo.dart';
import 'package:learn_arabic/blocs/util.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerPage extends StatefulWidget {
  final JVideo video;
  final List<JVideo> videoList;
  final int lessRanSeconds;
  PlayerPage({Key key, this.video, this.videoList, this.lessRanSeconds})
      : super(key: key);

  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  JVideo selectedVideo;
  YoutubePlayerController _controller;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  YoutubeMetaData _videoMetaData;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  void initState() {
    selectedVideo = widget.video;
    _controller = YoutubePlayerController(
      initialVideoId: selectedVideo.id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        //disableDragSeek: false,
        //loop: false,
        //isLive: false,
        forceHideAnnotation: true,
        //forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    //_controller.seekTo(Duration(seconds: widget.lessRanSeconds));
    _videoMetaData = YoutubeMetaData();
    super.initState();
  }

  int _second = 0;
  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _videoMetaData = _controller.metadata;
      });
    }
    if (_second != _controller.value.position.inSeconds) {
      dispatch(ActionTypes.SAVE_LESS_RUNNING_TIME, {
        'totalTime': _controller.metadata.duration.inSeconds,
        'ranTime': _second
      });
    }
    _second = _controller.value.position.inSeconds;
  }

  void selectVideo(JVideo video) {
    dispatch(ActionTypes.SET_VIDEO_ID, video.id);
    setState(() {
      selectedVideo = video;
    });
    _controller.load(video.id);
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(selectedVideo.title),
        ),
        body: ListView(
          children: <Widget>[
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
              topActions: <Widget>[
                SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    _controller.metadata.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 25.0,
                  ),
                  onPressed: () {
                    Util.showSnackBar(_scaffoldKey, 'Settings Tapped!');
                  },
                ),
              ],
              onReady: () {
                _isPlayerReady = true;
                if (widget.lessRanSeconds > 0)
                  _controller.seekTo(Duration(seconds: widget.lessRanSeconds));
              },
              onEnded: (data) {
                // if (_controller.value.isFullScreen) {
                //   _controller.toggleFullScreenMode();
                //   setState(() {});
                // }
                selectVideo(widget.videoList[
                    (widget.videoList.indexOf(selectedVideo) + 1) %
                        widget.videoList.length]);
                Util.showSnackBar(_scaffoldKey, 'Next Video Started!');
              },
            ),
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _space,
                      _text('Title', _videoMetaData.title),
                      _space,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.skip_previous),
                            onPressed: _isPlayerReady
                                ? () {
                                    selectVideo(widget.videoList[(widget
                                                .videoList
                                                .indexOf(selectedVideo) -
                                            1) %
                                        widget.videoList.length]);
                                  }
                                : null,
                          ),
                          IconButton(
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                            onPressed: _isPlayerReady
                                ? () {
                                    _controller.value.isPlaying
                                        ? _controller.pause()
                                        : _controller.play();
                                    setState(() {});
                                  }
                                : null,
                          ),
                          IconButton(
                            icon: Icon(
                                _muted ? Icons.volume_off : Icons.volume_up),
                            onPressed: _isPlayerReady
                                ? () {
                                    _muted
                                        ? _controller.unMute()
                                        : _controller.mute();
                                    setState(() {
                                      _muted = !_muted;
                                    });
                                  }
                                : null,
                          ),
                          FullScreenButton(
                            controller: _controller,
                            color: Colors.blueAccent,
                          ),
                          IconButton(
                            icon: Icon(Icons.skip_next),
                            onPressed: _isPlayerReady
                                ? () => selectVideo(widget.videoList[
                                    (widget.videoList.indexOf(selectedVideo) +
                                            1) %
                                        widget.videoList.length])
                                : null,
                          ),
                        ],
                      ),
                      _space,
                      Row(
                        children: <Widget>[
                          Text(
                            "Volume",
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                          Expanded(
                            child: Slider(
                              inactiveColor: Colors.transparent,
                              value: _volume,
                              min: 0.0,
                              max: 100.0,
                              divisions: 10,
                              label: '${(_volume).round()}',
                              onChanged: _isPlayerReady
                                  ? (value) {
                                      setState(() {
                                        _volume = value;
                                      });
                                      _controller.setVolume(_volume.round());
                                    }
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ]))
          ],
        ));
  }

  Widget get _space => SizedBox(
        height: 10,
      );
  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value ?? '',
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
*/
