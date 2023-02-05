import 'package:cloud_firestore/cloud_firestore.dart';

class ThePlaylist {
  late String id;
  late String name;
  late String userId;
  String? imageURL;
  late List<dynamic> listTrackId;
  late int listeningCount;
  late bool isPublic;
  late Timestamp lastUpdate;

  ThePlaylist({
    required this.id,
    required this.name,
    required this.userId,
    this.listTrackId = const [],
    this.listeningCount = 0,
    this.isPublic = true,
    required this.lastUpdate,
  });

  ThePlaylist.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    userId = map['userId'];
    imageURL = map['imageURL'];
    listTrackId = map['listTrackId'];
    listeningCount = map['listeningCount'];
    isPublic = map['isPublic'];
    lastUpdate = map['lastUpdate'];
  }

  Map<String, dynamic> toMap() {
    var map = {
      "id": id,
      "name": name,
      "userId": userId,
      "imageURL": imageURL,
      "listTrackId": listTrackId,
      "listeningCount": listeningCount,
      "isPublic": isPublic,
      "lastUpdate": lastUpdate,
    };
    return map;
  }
}
