import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_app/models/db_models/playlist.dart';
import 'package:music_app/repositories/global_repo.dart';
import 'package:music_app/screens/mobile_screens/play/play_screen.dart';
import 'package:music_app/utils/constants/app_colors.dart';

import '../../../models/db_models/track.dart';
import '../../../utils/constants/asset_paths.dart';
import '../../../widgets/cached_image_widget.dart';
import '../../../widgets/custom_track_item.dart';

final globalRepo = GlobalRepo.getInstance;

class PlaylistScreen extends StatefulWidget {
  final AppPlaylist playlist;

  const PlaylistScreen({Key? key, required this.playlist}) : super(key: key);

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  List<Track> listTrack = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.playlist.tracksIdList.forEach((element) async {
      var track = await globalRepo.getTrackById(element);
      setState(() {
        listTrack.add(track);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AssetPaths.imagePath.getBackgroundImagePath),
                  fit: BoxFit.cover),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppColor.primaryColor,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(40),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(AssetPaths.imagePath.getBackgroundImagePath),
                          fit: BoxFit.cover),
                    ),
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 10, left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.playlist.name,
                          style: const TextStyle(
                            color: AppColor.onPrimaryColor,
                            fontSize: 24, fontWeight: FontWeight.bold,),
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => PlayScreen(
                                            playlist: widget.playlist,
                                            tracks: listTrack,
                                            isPlaylist: true)));
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                    ),
                                  ),
                                  Positioned(
                                      top: 12,
                                      left: 12,
                                      child: Container(
                                        width: 16,
                                        height: 16,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/icons/play-button-arrowhead.png'),
                                              fit: BoxFit.cover,
                                            )),
                                      )),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                pinned: true,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedImageWidget(
                    imageURL: widget.playlist.imageURL!,
                    width: double.maxFinite,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: listTrack
                        .map((track) => CustomTrackItem(track: track, trailingWidget: const Text(
                      "3:30",
                      style: TextStyle(
                        fontSize: 16.0,
                        height: 21.0 / 16.0,
                        color: AppColor.onPrimaryColor,
                      ),
                    ),))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
