import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_app/models/db_models/artist.dart';
import 'package:music_app/models/db_models/track.dart';

class TrackRepo {
  final FirebaseFirestore firebaseFirestore;

  TrackRepo({required this.firebaseFirestore});

  Future<List<Track>> getAllTracks() async {
    try {
      final snapshot = await firebaseFirestore.collection('tracks').get();
      return snapshot.docs.map((e) => Track.fromMap(e.data())).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Track> getTrackById(String id) async {
    var query = await firebaseFirestore.collection('tracks').doc(id).get();
    var track = Track.fromMap(query.data()!);
    return track;
  }
}
