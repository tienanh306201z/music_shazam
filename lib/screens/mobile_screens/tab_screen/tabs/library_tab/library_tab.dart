import 'package:flutter/material.dart';
import 'package:music_app/screens/mobile_screens/tab_screen/tabs/library_tab/profile_screen.dart';
import 'package:music_app/screens/mobile_screens/tab_screen/tabs/library_tab/widgets/library_header.dart';
import 'package:music_app/utils/constants/asset_paths.dart';
import 'package:provider/provider.dart';

import '../../../../../models/db_models/track.dart';
import '../../../../../repositories/global_repo.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../view_models/user_view_model.dart';
import '../../../../../widgets/cached_image_widget.dart';
import '../../../sign_in/sign_in_screen.dart';

final globalRepo = GlobalRepo.getInstance;

class LibraryTab extends StatefulWidget {
  const LibraryTab({Key? key}) : super(key: key);

  @override
  State<LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> {
  String? userId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = globalRepo.getCurrentUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, model, child) {
        var currUser = model.currentUser;
        print(currUser?.imageURL);
        bool isNullUser = currUser == null;
        bool isNullImage = currUser == null ||
            currUser.imageURL == null ||
            currUser.imageURL!.isEmpty;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: LibraryHeader(
                    userImageWidget: InkWell(
                      onTap: () {
                        if (isNullUser) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignInScreen(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileScreen(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: isNullImage
                              ? Image.asset(
                                  AssetPaths.imagePath.getDefaultImagePath,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                )
                              : CachedImageWidget(
                                  imageURL: currUser.imageURL!,
                                  width: 40,
                                  height: 40,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                functionItemWidget(
                  title: 'Liked tracks',
                  onTap: () async {
                    if (model.currentUser != null) {
                      var likedTracksId = model.currentUser!.likedTracksIdList;
                      List<Track> tracks =
                          await globalRepo.getTrackListById(likedTracksId);
                      if (!mounted) return;
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) =>
                      //             LikedTrackedScreen(likedTracks: tracks)));
                    }
                  },
                ),
                functionItemWidget(
                  title: 'Playlists',
                  onTap: () {},
                ),
                functionItemWidget(
                  title: 'Your uploads',
                  onTap: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget functionItemWidget({required String title, required Function onTap}) {
    return InkWell(
      onTap: () {
        onTap.call();
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColor.onPrimaryColor),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColor.onPrimaryColor,
            )
          ],
        ),
      ),
    );
  }
}
