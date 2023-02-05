import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_app/models/artist.dart';
import 'package:music_app/models/track.dart';

class TrackRepository {
  final firestore = FirebaseFirestore.instance;

  getAllSongs() {
    return firestore.collection('tracks').get();
  }
  
  getAllPlaylist() {
    return firestore.collection('playlists').get();
  }

  Future<Track> getTrackById(String id) async {
    var query = await firestore.collection('tracks').doc(id).get();
    var track = Track.fromMap(query.data()!);
    return track;
  }

  Future<Artist> getArtistById(String id) async {
    var query = await firestore.collection('artists').doc(id).get();
    var artist = Artist.fromMap(query.data()!);
    return artist;
  }
}