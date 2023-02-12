import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_app/repositories/artist_repo.dart';
import 'package:music_app/repositories/playlist_repo.dart';
import 'package:music_app/repositories/track_repo.dart';

import '../models/db_models/artist.dart';
import '../models/db_models/playlist.dart';
import '../models/db_models/track.dart';

class GlobalRepo {
  static final GlobalRepo _this = GlobalRepo._getInstance();

  static GlobalRepo get getInstance => _this;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  late final ArtistRepo _artistRepo;
  late final TrackRepo _trackRepo;
  late final PlaylistRepo _playlistRepo;

  GlobalRepo._getInstance() {
    _artistRepo = ArtistRepo(firebaseFirestore: _firebaseFirestore);
    _trackRepo = TrackRepo(firebaseFirestore: _firebaseFirestore);
    _playlistRepo = PlaylistRepo(firebaseFirestore: _firebaseFirestore);
  }

  //ArtistRepo
  Future<Artist> getArtistById(String id) async {
    return _artistRepo.getArtistById(id);
  }

  //PlaylistRepo
  Future<List<Playlist>> getAllPlaylist() async {
    return _playlistRepo.getAllPlaylist();
  }

  //TrackRepo
  Future<List<Track>> getAllTracks() async {
    return _trackRepo.getAllTracks();
  }

  Future<Track> getTrackById(String id) async {
    return _trackRepo.getTrackById(id);
  }
}
