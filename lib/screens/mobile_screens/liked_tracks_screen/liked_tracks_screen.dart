import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/db_models/app_user.dart';
import 'package:music_app/repositories/global_repo.dart';
import 'package:music_app/widgets/general_header.dart';

import '../../../models/db_models/track.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/asset_paths.dart';
import '../../../widgets/custom_track_item.dart';

final globalRepo = GlobalRepo.getInstance;

class LikedTracksScreen extends StatefulWidget {
  final String? userId;

  const LikedTracksScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<LikedTracksScreen> createState() => _LikedTracksScreenState();
}

class _LikedTracksScreenState extends State<LikedTracksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetPaths.imagePath.getBackgroundImagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const GeneralHeader(title: "Liked tracks"),
              const SizedBox(
                height: 20,
              ),
              widget.userId != null
                  ? StreamBuilder<DocumentSnapshot>(
                stream: globalRepo.getStreamUserById(widget.userId!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var user = AppUser.fromMap(
                        snapshot.data?.data() as Map<String, dynamic>);
                    var likedTracksId = user.likedTracksIdList;
                    return FutureBuilder<List<Track>>(
                      future: globalRepo.getTrackListById(likedTracksId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Track> tracks = snapshot.data!;
                          return tracks.isNotEmpty
                              ? tracksListWidget(tracks)
                              : noContentWidget('No track');
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              )
                  : noContentWidget(
                  'You must sign in \nto see all liked tracks.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget noContentWidget(String content) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 2 - 100,
        ),
        Text(
          content,
          style: const TextStyle(
            color: AppColor.onPrimaryColor,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget tracksListWidget(List<Track> tracks) {
    return ListView.separated(
      itemBuilder: (_, index) => CustomTrackItem(
        track: tracks[index],
      ),
      itemCount: tracks.length,
      separatorBuilder: (_, index) => const SizedBox(
        height: 16.0,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}