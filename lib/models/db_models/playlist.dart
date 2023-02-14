import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_app/utils/app_string.dart';

class AppPlaylist {
  late String id;
  late String name;
  late String userId;
  String? imageURL;
  late List<dynamic> tracksIdList;
  late int listenedCount;
  late bool isPublic;
  late Timestamp lastUpdate;

  AppPlaylist({
    required this.id,
    required this.name,
    required this.userId,
    this.tracksIdList = const [],
    this.listenedCount = 0,
    this.isPublic = true,
    required this.lastUpdate,
  });

  AppPlaylist.fromMap(Map<String, dynamic> map) {
    id = map[AppString.id];
    name = map[AppString.name];
    userId = map[AppString.userId];
    imageURL = map[AppString.imageURL];
    tracksIdList = map[AppString.tracksIdList];
    listenedCount = map[AppString.listenedCount] ?? 0;
    isPublic = map[AppString.isPublic];
    lastUpdate = map[AppString.lastUpdate];
  }

  Map<String, dynamic> toMap() {
    var map = {
      AppString.id: id,
      AppString.name: name,
      AppString.userId: userId,
      AppString.imageURL: imageURL,
      AppString.tracksIdList: tracksIdList,
      AppString.listenedCount: listenedCount,
      AppString.isPublic: isPublic,
      AppString.lastUpdate: lastUpdate,
    };
    return map;
  }
}
