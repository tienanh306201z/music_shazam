import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_app/models/db_models/detected_song.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/asset_paths.dart';
import '../../../widgets/cached_image_widget.dart';

class DetectedSongScreen extends StatefulWidget {
  const DetectedSongScreen({Key? key}) : super(key: key);

  @override
  State<DetectedSongScreen> createState() => _DetectedSongScreenState();
}

class _DetectedSongScreenState extends State<DetectedSongScreen> {
  DetectedSong? _detectedSong;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      setState(() {
        _detectedSong =
            ModalRoute.of(context)?.settings.arguments as DetectedSong?;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: _detectedSong == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    actions: [
                      IconButton(
                        onPressed: () async => await FlutterShare.share(
                            title: 'Share song',
                            linkUrl: _detectedSong?.share,
                            chooserTitle: 'Share song'),
                        icon: const Icon(Icons.share_outlined,
                            size: 24, color: AppColor.onPrimaryColor),
                      )
                    ],
                    leading: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back,
                          size: 24, color: AppColor.onPrimaryColor),
                    ),
                    expandedHeight: size.height * 0.8,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          CachedImageWidget(
                            imageURL: _detectedSong?.album?.coverBig ??
                                _detectedSong?.album?.cover ??
                                "",
                            width: size.width,
                            height: size.height * 0.9,
                          ),
                          Container(
                            height: size.height * 0.9,
                            width: size.width,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )),
                          ),
                          Container(
                            height: size.height * 0.9,
                            width: size.width,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                AppColor.primaryColor.withOpacity(0.2)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )),
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: [
                          AppColor.primaryColor.withOpacity(0.2),
                          AppColor.primaryColor
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    _detectedSong?.title ?? "",
                                    style: const TextStyle(
                                      color: AppColor.onPrimaryColor,
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    // ignore: deprecated_member_use
                                    await launch(
                                        _detectedSong?.album?.link ?? "");
                                  },
                                  child: Container(
                                    width: 45,
                                    height: 45,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColor.onPrimaryColor
                                          .withOpacity(0.2),
                                    ),
                                    child: const Icon(
                                      FontAwesomeIcons.play,
                                      color: AppColor.onPrimaryColor,
                                      size: 24.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              _detectedSong?.artist?.name ?? "",
                              style: TextStyle(
                                color: AppColor.onPrimaryColor.withOpacity(0.6),
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(40),
                                  height: 10,
                                  width: 10,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF089af8)),
                                  child: Image.asset(
                                    AssetPaths.imagePath.getShazamImagePath,
                                    color: Colors.white,
                                    width: 6,
                                    height: 6,
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  "Ranking: ${_detectedSong?.rank ?? ""}",
                                  style: TextStyle(
                                    color: AppColor.onPrimaryColor
                                        .withOpacity(0.4),
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40.0),
                            Align(
                                alignment: Alignment.center,
                                child: _shareButton()),
                            const SizedBox(height: 40.0),
                            _trackInformation()
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget _shareButton() {
    return ElevatedButton(
      onPressed: () async {
        await FlutterShare.share(
            title: 'Share song',
            linkUrl: _detectedSong?.share,
            chooserTitle: 'Share song');
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          foregroundColor: AppColor.onPrimaryColor,
          elevation: 10),
      child: const Text("Share this song"),
    );
  }

  Widget _trackInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Track Information",
          style: TextStyle(
            color: AppColor.onPrimaryColor,
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10.0),
        _trackInfoLine(title: "Track:", content: _detectedSong?.title ?? ""),
        _trackInfoLine(
            title: "Duration:",
            content: (_detectedSong?.duration ?? 0) == 0
                ? ""
                : "${Duration(seconds: _detectedSong?.duration).inMinutes}m${Duration(seconds: _detectedSong?.duration).inSeconds - Duration(seconds: _detectedSong?.duration).inMinutes * 60}s"),
        _trackInfoLine(
            title: "Album:", content: _detectedSong?.album?.title ?? ""),
        _trackInfoLine(
            title: "Label:", content: _detectedSong?.titleShort ?? ""),
        _trackInfoLine(
            title: "Released:",
            content: _detectedSong?.releaseDate?.year.toString() ?? "",
            useDivider: false),
      ],
    );
  }

  Widget _trackInfoLine(
      {required String title,
      required String content,
      bool useDivider = true}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColor.onPrimaryColor.withOpacity(0.4),
                  fontSize: 13,
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Text(
                  content,
                  style: const TextStyle(
                    color: AppColor.onPrimaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        if (useDivider)
          Divider(
            color: AppColor.onPrimaryColor.withOpacity(0.2),
          )
      ],
    );
  }
}
