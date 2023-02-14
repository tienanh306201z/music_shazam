import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/db_models/playlist.dart';
import 'package:music_app/navigations/app_nav_host.dart';
import 'package:music_app/utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../models/db_models/app_user.dart';
import '../../../models/db_models/track.dart';
import '../../../repositories/global_repo.dart';
import '../../../utils/asset_paths.dart';
import '../../../view_models/user_view_model.dart';
import '../../../widgets/cached_image_widget.dart';
import '../../../widgets/custom_track_item.dart';

final globalRepo = GlobalRepo.getInstance;

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  AppPlaylist? playlist;
  List<Track> listTrack = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      playlist = ModalRoute.of(context)?.settings.arguments as AppPlaylist?;
      playlist?.tracksIdList.forEach((element) async {
        var track = await globalRepo.getTrackById(element);
        setState(() {
          listTrack.add(track);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image:
                      AssetImage(AssetPaths.imagePath.getBackgroundImagePath),
                  fit: BoxFit.cover),
            ),
          ),
          listTrack.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      actions: [
                        Consumer<UserViewModel>(
                          builder: (context, model, child) {
                            if (model.currentUser != null) {
                              return Row(
                                children: [
                                  StreamBuilder<DocumentSnapshot>(
                                    stream: globalRepo.getStreamUserById(
                                        model.currentUser!.id),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        var user = AppUser.fromMap(snapshot.data
                                            ?.data() as Map<String, dynamic>);
                                        return IconButton(
                                          onPressed: () {
                                            globalRepo.updatePlaylistIdList(
                                                playlist!.id);
                                          },
                                          icon: Icon(
                                              user.playlistsIdList
                                                      .contains(playlist!.id)
                                                  ? Icons
                                                      .playlist_remove_outlined
                                                  : Icons.playlist_add_outlined,
                                              size: 24.0,
                                              color: user.playlistsIdList
                                                      .contains(playlist!.id)
                                                  ? Colors.redAccent
                                                  : AppColor.onPrimaryColor),
                                        );
                                      } else {
                                        return Image.asset(
                                          AssetPaths
                                              .iconPath.getAddPlaylistIconPath,
                                          width: 40,
                                        );
                                      }
                                    },
                                  )
                                ],
                              );
                            }
                            return const SizedBox();
                          },
                        )
                      ],
                      leading: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back,
                            size: 24, color: AppColor.onPrimaryColor),
                      ),
                      expandedHeight: size.height * 0.3,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          children: [
                            CachedImageWidget(
                              imageURL: playlist?.imageURL ?? "",
                              width: size.width,
                              height: size.height * 0.4,
                            ),
                            Container(
                              height: size.height * 0.4,
                              width: size.width,
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                colors: [Colors.transparent, Color(0xFF230C39)],
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
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                playlist!.name,
                                style: const TextStyle(
                                  color: AppColor.onPrimaryColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    AppRoutes.playScreen.name,
                                    arguments: {
                                      "tracks": listTrack,
                                      "playlist": playlist,
                                      "isPlaylist": true
                                    });
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            AppColor.primaryColor,
                                            Colors.blueAccent.shade700
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
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
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: listTrack
                              .map((track) => CustomTrackItem(track: track))
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
