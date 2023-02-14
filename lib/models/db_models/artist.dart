import 'package:music_app/utils/app_string.dart';

class AppArtist {
  late String id;
  late String name;
  late String? biography;
  late String? description;
  late List<dynamic> tracksIdList;

  AppArtist({
    required this.id,
    required this.name,
    this.tracksIdList = const [],
  });

  AppArtist.fromMap(Map<String, dynamic> map) {
    id = map[AppString.id];
    name = map[AppString.name];
    biography = map[AppString.biography];
    description = map[AppString.description];
    tracksIdList = map[AppString.tracksIdList];
  }

  Map<String, dynamic> toMap() {
    var map = {
      AppString.id: id,
      AppString.name: name,
      AppString.biography: biography,
      AppString.description: description,
      AppString.tracksIdList: tracksIdList,
    };
    return map;
  }
}
