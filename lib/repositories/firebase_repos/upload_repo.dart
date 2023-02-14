import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/db_models/playlist.dart';
import '../../utils/app_string.dart';

class UploadRepo {
  final FirebaseStorage storage;
  final FirebaseFirestore firestore;

  UploadRepo({required this.storage, required this.firestore});

  uploadImage(String id, File imageFile, String imageName) async {
    final pathImage = "images/$id/$imageName";
    final childRef = storage.ref().child(pathImage);
    final metadata = SettableMetadata(contentType: "image/jpeg");
    final snapshot = await childRef.putFile(imageFile, metadata);
    return snapshot.ref.getDownloadURL();
  }

  uploadTrack(String id, File trackFile, String trackName) async {
    final pathTrack = "songs/$id/$trackName";
    final childRef = storage.ref().child(pathTrack);
    final snapshot = await childRef.putFile(trackFile);
    return snapshot.ref.getDownloadURL();
  }

  updateInfoNewTrack({
    required File imageFile,
    required String imageName,
    required File musicFile,
    required File? beatFile,
    required String trackName,
    required String id,
    required String? karaokeLink,
    required String? lyrics,
    required String? chordString,
    required String? description,
    required String? artistId,
  }) async {
    String imageURL = await uploadImage(id, imageFile, imageName);
    String musicLink = await uploadTrack(id, musicFile, trackName);
    String? beatLink;
    if (beatFile != null) {
      beatLink = await uploadTrack(id, beatFile, "Beat - $trackName");
    }
    var currentTime = Timestamp.now();
    var trackMap = {
      AppString.id: id,
      AppString.name: trackName,
      AppString.musicLink: musicLink,
      AppString.beatLink: beatLink,
      AppString.karaokeLink: karaokeLink,
      AppString.lyrics: lyrics,
      AppString.chordString: chordString,
      AppString.description: description,
      AppString.listenedCount: 0,
      AppString.artistId: artistId,
      AppString.favoriteUserIdList: [],
      AppString.lastUpdate: currentTime,
      AppString.imageURL: imageURL,
    };
    await firestore.collection(AppString.trackCollection).doc(id).set(trackMap);
  }

  Future<void> uploadPlaylist(
      {required String id,
      required File imageFile,
      required String name,
      required String imageName,
      required List<String> tracksIdList,
      required String userId}) async {
    String imageURL = await uploadImage(id, imageFile, imageName);
    var currentTime = Timestamp.now();
    var trackMap = {
      AppString.id: id,
      AppString.name: name,
      AppString.userId: userId,
      AppString.isPublic: false,
      AppString.listenedCount: 0,
      AppString.tracksIdList: tracksIdList,
      AppString.lastUpdate: currentTime,
      AppString.imageURL: imageURL,
    };
    await firestore.collection(AppString.trackCollection).doc(id).set(trackMap);
  }
}
