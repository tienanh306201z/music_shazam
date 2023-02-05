import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/playlist.dart';

import '../models/track.dart';
import '../repository/track_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final trackRepo = TrackRepository();
  List<Track> tracks = [];
  List<ThePlaylist> playlists = [];

  getAllSongs() async {
    print("GET SONG");
    QuerySnapshot querySnapshot = await trackRepo.getAllSongs();
    // Get data from docs and convert map to List
    tracks = querySnapshot.docs.map((doc) => Track.fromMap(doc.data() as Map<String, dynamic>)).toList();
    notifyListeners();
  }

  getAllPlaylist() async {
    print("GET PLAYLIST");
    QuerySnapshot querySnapshot = await trackRepo.getAllPlaylist();
    querySnapshot.docs.forEach((doc) async {
      var tmp = ThePlaylist.fromMap(doc.data() as Map<String, dynamic>);
      if (tmp.imageURL == null || tmp.imageURL!.isEmpty) {
        var firstTrack = await TrackRepository().getTrackById(tmp.listTrackId[0]);
        tmp.imageURL = firstTrack.imageURL;
        print(firstTrack.imageURL);
      }
      playlists.add(tmp);
      notifyListeners();
    });
    print(playlists.length);
    notifyListeners();
  }
}