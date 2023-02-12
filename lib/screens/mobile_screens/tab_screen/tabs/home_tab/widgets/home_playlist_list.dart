import 'package:flutter/material.dart';
import 'package:music_app/repositories/global_repo.dart';
import 'package:music_app/utils/constants/app_colors.dart';

class HomePlaylistList extends StatelessWidget {
  const HomePlaylistList({Key? key}) : super(key: key);

  Widget _homePlaylistItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(16)),
          ),
          const SizedBox(
            height: 16.0,
          ),
          const Text(
            "Dangerous Days",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              height: 21.0 / 16.0,
              color: AppColor.onPrimaryColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "2014 - Album",
            style: TextStyle(
              fontSize: 12.0,
              height: 16.0 / 12.0,
              color: AppColor.onPrimaryColor.withOpacity(0.6),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        itemBuilder: (_, index) => _homePlaylistItem(),
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
      ),
    );
  }
}
