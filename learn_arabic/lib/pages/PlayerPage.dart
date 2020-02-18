import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';
import 'package:learn_arabic/blocs/models/BookInfo.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerPage extends StatefulWidget {
  final JVideo video;
  final List<JVideo> videoList;
  PlayerPage({Key key, this.video, this.videoList}) : super(key: key);

  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  JVideo selectedVideo;
  YoutubePlayerController _controller;
  @override
  void initState() {
    selectedVideo = widget.video;
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.id,
      flags: YoutubePlayerFlags(
          mute: false, autoPlay: true, forceHideAnnotation: true),
    );
    super.initState();
  }

  void selectVideo(JVideo video) {
    dispatch(ActionTypes.SET_VIDEO_ID, video.id);
    setState(() {
      selectedVideo = video;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(selectedVideo.title),
        ),
        body: Column(
          children: <Widget>[
            /*YoutubePlayer(
                context: context,
                source: selectedVideo.id,
                quality: YoutubeQuality.HD,
                startFullScreen: true,
                onVideoEnded: () {
                  var index = widget.videoList
                      .indexWhere((v) => v.id == selectedVideo.id);
                  if (index + 1 < widget.videoList.length) {
                    selectVideo(widget.videoList[index + 1]);
                  }
                  Navigator.pop(context);
                }),*/
            Expanded(
                child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    actionsPadding: EdgeInsets.only(left: 16.0),
                    bottomActions: [
                  CurrentPosition(),
                  SizedBox(width: 10.0),
                  ProgressBar(isExpanded: true),
                  SizedBox(width: 10.0),
                  RemainingDuration(),
                  FullScreenButton(),
                ])),
            Text(selectedVideo.title,
                style: Theme.of(context).textTheme.caption),
            /*Expanded(
              child: ListView.builder(
                itemCount: widget.videoList.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.play_circle_filled,
                      color: selectedVideo.id == widget.videoList[index].id
                          ? Colors.red
                          : null,
                    ),
                    title: Text(widget.videoList[index].title),
                    onTap: () {
                      selectVideo(widget.videoList[index]);
                    },
                  ),
                ),
              ),
            )*/
          ],
        ));
  }
}
