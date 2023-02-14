import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_app/models/db_models/playlist.dart';
import 'package:music_app/utils/app_string.dart';

class PlaylistRepo {
  final FirebaseFirestore firebaseFirestore;

  PlaylistRepo({required this.firebaseFirestore});

  Future<List<AppPlaylist>> getAllPlaylist() async {
    final snapshots = await firebaseFirestore.collection(AppString.playlistCollection).get();
    return snapshots.docs.map((e) => AppPlaylist.fromMap(e.data())).toList();
  }

  Future<AppPlaylist> getPlaylistById(String id) async {
    var query = await firebaseFirestore.collection(AppString.playlistCollection).doc(id).get();
    var playlist = AppPlaylist.fromMap(query.data()!);
    return playlist;
  }

  Future<List<AppPlaylist>> getAllPlaylistsById(List<dynamic> playlistsIdList) async {
    List<AppPlaylist> playlists = [];
    for (var element in playlistsIdList) {
      var playlist = await getPlaylistById(element);
      playlists.add(playlist);
    }
    return playlists;
  }

  Future<void> updateListenCountPlaylist(String id) async {
    var playlist = await getPlaylistById(id);
    var count = playlist.listenedCount;
    count++;
    firebaseFirestore.collection(AppString.playlistCollection).doc(id).update({AppString.listenedCount: count});
  }
}

