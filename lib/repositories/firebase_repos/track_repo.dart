import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_app/models/db_models/track.dart';
import 'package:music_app/utils/app_string.dart';

class TrackRepo {
  final FirebaseFirestore firebaseFirestore;

  TrackRepo({required this.firebaseFirestore});

  Future<List<Track>> getAllTracks() async {
    try {
      final snapshot = await firebaseFirestore.collection(AppString.trackCollection).get();
      return snapshot.docs.map((e) => Track.fromMap(e.data())).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Track>> getTop10Tracks() async {
    var allTracks = await getAllTracks();
    allTracks.sort((a, b) => b.listenedCount.compareTo(a.listenedCount));
    if (allTracks.length > 10) {
      return allTracks.sublist(0, 10);
    }
    return allTracks;
  }

  Future<Track> getTrackById(String id) async {
    var query = await firebaseFirestore.collection(AppString.trackCollection).doc(id).get();
    var track = Track.fromMap(query.data()!);
    return track;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStreamTrackById(String id) {
    return firebaseFirestore.collection(AppString.trackCollection).doc(id).snapshots();
  }

  Future<List<Track>> getTrackListById(List<dynamic> listId) async {
    List<Track> tracks = [];
    try {
      for (var id in listId) {
        var query = await firebaseFirestore.collection(AppString.trackCollection).doc(id).get();
        var track = Track.fromMap(query.data()!);
        tracks.add(track);
      }
    } catch (e) {
      print(e);
    }
    return tracks;
  }

  Future<void> updateListenCountTrack(String id) async {
    var track = await getTrackById(id);
    var count = track.listenedCount;
    count++;
    firebaseFirestore.collection(AppString.trackCollection).doc(id).update({AppString.listenedCount: count});
  }

  Future<void> updateFavoriteUserList(String userId, String trackId) async {
    var track = await getTrackById(trackId);
    var listUserId = track.favoriteUserIdList;
    if (listUserId.contains(userId)) {
      listUserId.remove(userId);
    } else {
      listUserId.add(userId);
    }
    firebaseFirestore
        .collection(AppString.trackCollection)
        .doc(track.id)
        .update({AppString.favoriteUserIdList: listUserId});
  }
}