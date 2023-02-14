import 'package:acr_cloud_sdk/acr_cloud_sdk.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:music_app/navigations/app_nav_host.dart';
import 'package:music_app/utils/api_key.dart';
import 'package:music_app/utils/asset_paths.dart';
import 'package:music_app/view_models/detected_song_view_model.dart';
import 'package:music_app/view_models/play_view_model.dart';
import 'package:provider/provider.dart';

class SongRecognitionTab extends StatefulWidget {
  const SongRecognitionTab({Key? key}) : super(key: key);

  @override
  State<SongRecognitionTab> createState() => _SongRecognitionTabState();
}

class _SongRecognitionTabState extends State<SongRecognitionTab>
    with TickerProviderStateMixin {
  final AcrCloudSdk acr = AcrCloudSdk();
  Music? music;

  late final AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 1000), vsync: this);
  final Tween<double> _tween = Tween(begin: 0.75, end: 1.25);

  var _runShazam = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      acr
        ..init(
          host: ApiKey.shazamHostKey,
          accessKey: ApiKey.shazamAPIKey,
          accessSecret: ApiKey.shazamSecretKey,
          setLog: true,
        )
        ..songModelStream.listen((song) async {
          final metaData = song.metadata;
          if (metaData != null && metaData.music!.isNotEmpty) {
            try {
              setState(() {
                _runShazam = false;
                _controller.value = 1;
                _controller.stop();
              });
              music = song.metadata?.music?.first;
              final detectedSong = await Provider.of<DetectedSongViewModel>(
                      context,
                      listen: false)
                  .getTrack(music?.externalMetadata?.deezer?.track?.id);
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushNamed(AppRoutes.detectedSongScreen.name,
                  arguments: detectedSong);
            } catch (e) {
              setState(() {
                _runShazam = false;
                _controller.value = 1;
                _controller.stop();
              });
              Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                message: "Cannot detecting your song!",
                icon: const Icon(
                  Icons.error_outline,
                  size: 28.0,
                  color: Colors.grey,
                ),
                duration: const Duration(seconds: 2),
                leftBarIndicatorColor: Colors.redAccent,
              ).show(context);
            }
          } else {
            setState(() {
              _runShazam = false;
              _controller.value = 1;
              _controller.stop();
            });
            Flushbar(
              flushbarPosition: FlushbarPosition.TOP,
              message: "Cannot detecting your song!",
              icon: const Icon(
                Icons.error_outline,
                size: 28.0,
                color: Colors.grey,
              ),
              duration: const Duration(seconds: 2),
              leftBarIndicatorColor: Colors.redAccent,
            ).show(context);
          }
        });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playViewModel = Provider.of<PlayViewModel>(context, listen: false);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _runShazam
                ? 'Detecting your song.....'
                : 'Tap to recognize your song!',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(
            height: 40,
          ),
          AvatarGlow(
            animate: _runShazam,
            endRadius: 250,
            child: AvatarGlow(
              endRadius: 125.0,
              animate: _runShazam,
              child: GestureDetector(
                onTap: () async {
                  if (mounted) {
                    if (_runShazam) {
                      setState(() {
                        _runShazam = false;
                        _controller.value = 1;
                        _controller.stop();
                        music = null;
                      });
                      await acr.stop();
                    } else {
                      setState(() {
                        _runShazam = true;
                        _controller.repeat(reverse: true);
                        music = null;
                      });
                      playViewModel.pause();
                      await acr.start().whenComplete(() async {
                        setState(() {
                          _runShazam = false;
                          _controller.value = 1;
                          _controller.stop();
                        });
                      });
                    }
                  }
                },
                child: ScaleTransition(
                  scale: _tween.animate(CurvedAnimation(
                      parent: _controller, curve: Curves.linear)),
                  child: Material(
                    shape: const CircleBorder(),
                    elevation: 8,
                    child: AnimatedContainer(
                      padding: const EdgeInsets.all(40),
                      height: _runShazam ? 150 : 200,
                      width: _runShazam ? 150 : 200,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFF089af8)),
                      duration: const Duration(milliseconds: 2000),
                      curve: Curves.fastLinearToSlowEaseIn,
                      child: Image.asset(
                        AssetPaths.imagePath.getShazamImagePath,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
