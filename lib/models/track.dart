import 'package:cloud_firestore/cloud_firestore.dart';

class Track {
  late String id;
  late String name;
  late String artistId;
  late String imageURL;
  late String mp3Link;
  late String lyrics;
  late int listeningCount;
  late Timestamp lastUpdate;
  late String chordString;

  Track({
    required this.id,
    required this.name,
    required this.artistId,
    required this.imageURL,
    required this.mp3Link,
    required this.lyrics,
    required this.listeningCount,
    required this.lastUpdate,
    required this.chordString,
  });

  Track.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    artistId = map['artistId'];
    imageURL = map['imageURL'] ?? "";
    mp3Link = map['mp3Link'];
    lyrics = map['lyrics'];
    listeningCount = map['listeningCount'];
    lastUpdate = map['lastUpdate'];
    chordString = map['chordString'];
  }

  Map<String, dynamic> toMap() {
    var map = {
      'id': id,
      'name': name,
      'artistId': artistId,
      'imageUrl': imageURL,
      'mp3Link': mp3Link,
      'lyrics': lyrics,
      'listeningCount': listeningCount,
      'lastUpdate': lastUpdate,
      'chordString': chordString,
    };
    return map;
  }
}
