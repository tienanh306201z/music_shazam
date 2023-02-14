import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/db_models/app_user.dart';
import 'package:music_app/models/db_models/playlist.dart';
import 'package:music_app/repositories/global_repo.dart';
import 'package:music_app/widgets/custom_playlist_item.dart';
import 'package:music_app/widgets/general_header.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/asset_paths.dart';

final globalRepo = GlobalRepo.getInstance;

class MyPlaylistScreen extends StatefulWidget {
  final String? userId;

  const MyPlaylistScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<MyPlaylistScreen> createState() => _MyPlaylistScreenState();
}

class _MyPlaylistScreenState extends State<MyPlaylistScreen> {
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
              const GeneralHeader(title: "Playlists"),
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
                    var playlistsIdList = user.playlistsIdList;
                    return FutureBuilder<List<AppPlaylist>>(
                      future: globalRepo.getAllPlaylistsById(playlistsIdList),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<AppPlaylist> playlists = snapshot.data!;
                          return playlists.isNotEmpty
                              ? tracksListWidget(playlists)
                              : noTrackWidget('No playlist');
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
                  : noTrackWidget(
                  'You must sign in \nto see all added playlist.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget noTrackWidget(String content) {
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

  Widget tracksListWidget(List<AppPlaylist> playlists) {
    return ListView.separated(
      itemBuilder: (_, index) => CustomPlaylistItem(
        playlist: playlists[index],
      ),
      itemCount: playlists.length,
      separatorBuilder: (_, index) => const SizedBox(
        height: 16.0,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}