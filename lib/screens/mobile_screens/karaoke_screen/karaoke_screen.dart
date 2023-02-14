import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_app/utils/app_colors.dart';
import 'package:music_app/utils/extension.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../utils/asset_paths.dart';

class KaraokeScreen extends StatefulWidget {
  final String videoURL;
  final String imageURL;

  const KaraokeScreen(
      {Key? key, required this.videoURL, required this.imageURL})
      : super(key: key);

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
      initialVideoId: videoId!, // https://www.youtube.com/watch?v=Tb9k9_Bo-G4
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        loop: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(widget.imageURL),
              fit: BoxFit.cover,
            )),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: "#AA110929".toColor(),
              ),
            ),
          ),
          Positioned(
              top: 40,
              left: 0,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back,
                    color: AppColor.onSurfaceColor),
              )),
          SafeArea(
            child: YoutubePlayerBuilder(
              player: YoutubePlayer(
                width: double.infinity,
                controller: _controller!,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blue,
                progressColors: const ProgressBarColors(
                  playedColor: Colors.blue,
                  handleColor: Colors.blue,
                ),
              ),
              builder: (context, player) {
                return Center(
                  child: player,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
