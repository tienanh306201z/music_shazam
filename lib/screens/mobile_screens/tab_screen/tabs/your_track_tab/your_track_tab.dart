import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_app/repositories/global_repo.dart';
import 'package:music_app/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../../models/db_models/app_user.dart';
import '../../../../../models/db_models/track.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../widgets/custom_track_item.dart';
import '../../../upload_screen/upload_screen.dart';
import 'widgets/your_track_header.dart';

class YourTrackTab extends StatelessWidget {
  const YourTrackTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, model, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: YourTrackHeader(
                  trailingWidget: InkWell(
                    onTap: () {
                      if (model.currentUser != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const UploadScreen()));
                      }
                    },
                    child: const Icon(
                      Icons.cloud_upload,
                      color: AppColor.onPrimaryColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: model.currentUser != null
                            ? StreamBuilder<DocumentSnapshot>(
                                stream: GlobalRepo.getInstance
                                    .getStreamUserById(model.currentUser!.id),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    var user = AppUser.fromMap(snapshot.data
                                        ?.data() as Map<String, dynamic>);
                                    var uploadedTracksIdList =
                                        user.uploadedTracksIdList;
                                    return FutureBuilder<List<Track>>(
                                      future: GlobalRepo.getInstance
                                          .getTrackListById(
                                              uploadedTracksIdList),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          List<Track> tracks = snapshot.data!;
                                          return tracks.isNotEmpty
                                              ? tracksListWidget(tracks)
                                              : noContentWidget(
                                                  context, 'No track');
                                        } else {
                                          return const SizedBox(
                                              height: 600,
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()));
                                        }
                                      },
                                    );
                                  } else {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              )
                            : noContentWidget(context,
                                'You must sign in \nto see all uploaded tracks'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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

  Widget noContentWidget(BuildContext context, String content) {
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
}
