import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_app/models/db_models/playlist.dart';

class PlaylistRepo {
  final FirebaseFirestore firebaseFirestore;

  PlaylistRepo({required this.firebaseFirestore});

  Future<List<Playlist>> getAllPlaylist() async {
    final snapshots = await firebaseFirestore.collection('playlists').get();
    return snapshots.docs.map((e) => Playlist.fromMap(e.data())).toList();
  }
}
