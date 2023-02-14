import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/app_string.dart';

class Track {
  late String id;
  late String name;
  late String musicLink;
  String? beatLink;
  String? karaokeLink;
  String? lyrics;
  String? chordString;
  String? description;
  late int listenedCount;
  String? artistId;
  late List<dynamic> favoriteUserIdList;
  late Timestamp lastUpdate;
  late String imageURL;

  Track({
    required this.id,
    required this.name,
    required this.musicLink,
    this.beatLink,
    this.karaokeLink,
    this.lyrics,
    this.chordString,
    this.description,
    required this.listenedCount,
    this.artistId,
    required this.favoriteUserIdList,
    required this.lastUpdate,
    required this.imageURL,
  });

  Track.fromMap(Map<String, dynamic> map) {
    id = map[AppString.id];
    name = map[AppString.name];
    musicLink = map[AppString.musicLink];
    beatLink = map[AppString.beatLink];
    karaokeLink = map[AppString.karaokeLink];
    lyrics = map[AppString.lyrics];
    chordString = map[AppString.chordString];
    description = map[AppString.description];
    listenedCount = map[AppString.listenedCount];
    artistId = map[AppString.artistId] ?? "";
    favoriteUserIdList = map[AppString.favoriteUserIdList] ?? [];
    lastUpdate = map[AppString.lastUpdate];
    imageURL = map[AppString.imageURL];
  }

  Map<String, dynamic> toMap() {
    var map = {
      AppString.id: id,
      AppString.name: name,
      AppString.musicLink: musicLink,
      AppString.beatLink: beatLink,
      AppString.karaokeLink: karaokeLink,
      AppString.lyrics: lyrics,
      AppString.chordString: chordString,
      AppString.description: description,
      AppString.listenedCount: listenedCount,
      AppString.artistId: artistId,
      AppString.favoriteUserIdList: favoriteUserIdList,
      AppString.lastUpdate: lastUpdate,
      AppString.imageURL: imageURL,
    };
    return map;
  }
}
