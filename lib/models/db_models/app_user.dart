import 'package:music_app/utils/app_string.dart';

class AppUser {
  late String id;
  late String name;
  late int role;
  late String email;
  String? imageURL;
  late List<dynamic> likedTracksIdList;
  late List<dynamic> playlistsIdList;
  late List<dynamic> uploadedTracksIdList;

  AppUser({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    this.imageURL,
    this.likedTracksIdList = const [],
    this.playlistsIdList = const [],
    this.uploadedTracksIdList = const [],
  });

  AppUser.fromMap(Map<String, dynamic> map) {
    id = map[AppString.id];
    name = map[AppString.name];
    role = map[AppString.role];
    email = map[AppString.email];
    imageURL = map[AppString.imageURL];
    likedTracksIdList = map[AppString.likedTracksIdList];
    playlistsIdList = map[AppString.playlistsIdList];
    uploadedTracksIdList = map[AppString.uploadedTracksIdList];
  }

  Map<String, dynamic> toMap() {
    var map = {
      AppString.id: id,
      AppString.name: name,
      AppString.role: role,
      AppString.email: email,
      AppString.imageURL: imageURL,
      AppString.likedTracksIdList: likedTracksIdList,
      AppString.playlistsIdList: playlistsIdList,
      AppString.uploadedTracksIdList: uploadedTracksIdList,
    };
    return map;
  }
}
