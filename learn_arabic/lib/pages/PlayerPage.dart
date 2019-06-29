import 'dart:async';

import 'package:ajwah_bloc/ajwah_bloc.dart';
import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/actionTypes.dart';
import 'package:learn_arabic/blocs/models/BookInfo.dart';
import 'package:learn_arabic/blocs/models/bookModel.dart';
import 'package:youtube_player/youtube_player.dart';

class PlayerPage extends StatefulWidget {
  final JVideo video;
  final List<JVideo> videoList;
  PlayerPage({Key key, this.video, this.videoList}) : super(key: key);

  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  JVideo selectedVideo;

  @override
  void initState() {
    selectedVideo = widget.video;
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
            YoutubePlayer(
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
                }),
            Text(selectedVideo.title, style: Theme.of(context).textTheme.title),
            Expanded(
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
            )
          ],
        ));
  }
}
