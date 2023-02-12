import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:music_app/repositories/artist_repo.dart';
import 'package:music_app/repositories/playlist_repo.dart';
import 'package:music_app/repositories/track_repo.dart';
import 'package:music_app/repositories/upload_repo.dart';
import 'package:music_app/repositories/user_repo.dart';

import '../models/db_models/app_user.dart';
import '../models/db_models/artist.dart';
import '../models/db_models/playlist.dart';
import '../models/db_models/track.dart';

class GlobalRepo {
  static final GlobalRepo _this = GlobalRepo._getInstance();

  static GlobalRepo get getInstance => _this;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  late final ArtistRepo _artistRepo;
  late final TrackRepo _trackRepo;
  late final PlaylistRepo _playlistRepo;
  late final UserRepo _userRepo;
  late final UploadRepo _uploadRepo;

  GlobalRepo._getInstance() {
    _artistRepo = ArtistRepo(firebaseFirestore: _firebaseFirestore);
    _trackRepo = TrackRepo(firebaseFirestore: _firebaseFirestore);
    _playlistRepo = PlaylistRepo(firebaseFirestore: _firebaseFirestore);
    _userRepo = UserRepo(firebaseAuth: _firebaseAuth, firebaseFirestore: _firebaseFirestore);
    _uploadRepo = UploadRepo(storage: _storage, firestore: _firebaseFirestore);
  }

  //ArtistRepo
  Future<Artist> getArtistById(String id) async {
    return _artistRepo.getArtistById(id);
  }

  //PlaylistRepo
  Future<List<AppPlaylist>> getAllPlaylist() async {
    return _playlistRepo.getAllPlaylist();
  }

  Future<void> updateListenCountPlaylist(String id) async {
    await _playlistRepo.updateListenCountPlaylist(id);
  }

  //TrackRepo
  Future<List<Track>> getAllTracks() async {
    return _trackRepo.getAllTracks();
  }

  Future<Track> getTrackById(String id) async {
    return _trackRepo.getTrackById(id);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStreamTrackById(String id) {
    return _trackRepo.getStreamTrackById(id);
  }

  Future<List<Track>> getTrackListById(List<dynamic> listId) async {
    return _trackRepo.getTrackListById(listId);
  }

  Future<void> updateListenCountTrack(String id) async {
    await _trackRepo.updateListenCountTrack(id);
  }

  Future<void> updateFavoriteUserList(String userId, String trackId) async {
    await _trackRepo.updateFavoriteUserList(userId, trackId);
  }

  //UserRepo
  String? getCurrentUserId() {
    return _userRepo.getCurrentUserId();
  }

  Future<AppUser?> getCurrentUser() async {
    return _userRepo.getCurrentUser();
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _userRepo.signInWithEmail(email, password);
  }

  Future<void> signOut() async {
    await _userRepo.signOut();
  }

  Future<void> updateName(String id, String name) async {
    await _userRepo.updateName(id, name);
  }

  Future<void> updateImageURL(String collection, String id, File imageFile, String imageName) async {
    String imageURL = await _uploadRepo.uploadImage(id, imageFile, imageName);
    await _userRepo.updateImageURL(id, imageURL);
  }

  Future<void> updateLikedTracksIdList(String trackId) async {
    await _userRepo.updateLikedTracksIdList(trackId);
  }
}
