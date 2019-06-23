import 'package:flutter/material.dart';
import 'package:learn_arabic/blocs/util.dart';
import 'package:youtube_player/youtube_player.dart';

class PlayerPage extends StatefulWidget {
  PlayerPage({Key key}) : super(key: key);

  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  Widget build(BuildContext context) {
    print('vid: ' + Util.videoId);
    return Scaffold(
        appBar: AppBar(
          title: Text('Video Player'),
        ),
        body: Column(
          children: <Widget>[
            YoutubePlayer(
              context: context,
              source: Util.videoId,
              quality: YoutubeQuality.HD,
            ),
            Text(Util.videoTitle, style: Theme.of(context).textTheme.title)
          ],
        ));
  }
}
