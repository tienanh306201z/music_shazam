import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class KaraokeScreen extends StatefulWidget {
  final String videoURL;
  const KaraokeScreen({Key? key, required this.videoURL}) : super(key: key);

  @override
  State<KaraokeScreen> createState() => _KaraokeScreenState();
}

class _KaraokeScreenState extends State<KaraokeScreen> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();

    var videoId = YoutubePlayer.convertUrlToId(widget.videoURL);
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,// https://www.youtube.com/watch?v=Tb9k9_Bo-G4
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        loop: true,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blue,
        progressColors: const ProgressBarColors(
          playedColor: Colors.blue,
          handleColor: Colors.blue,
        ),
      ),
      builder: (context, player) {
        return Center(child: player,);
      },
    );
  }
}
