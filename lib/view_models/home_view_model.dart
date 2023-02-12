// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:music_app/models/db_models/playlist.dart';
//
// import '../models/db_models/track.dart';
// import '../repositories/track_repo.dart';
//
// class HomeViewModel extends ChangeNotifier {
//   final trackRepo = TrackRepo();
//   List<Track> tracks = [];
//   List<Playlist> playlists = [];
//
//   getAllTracks() async {
//     print("GET SONG");
//     QuerySnapshot querySnapshot = await trackRepo.getAllTracks();
//     // Get data from docs and convert map to List
//     tracks = querySnapshot.docs.map((doc) => Track.fromMap(doc.data() as Map<String, dynamic>)).toList();
//     notifyListeners();
//   }
//
//   getAllPlaylist() async {
//     print("GET PLAYLIST");
//     QuerySnapshot querySnapshot = await trackRepo.getAllPlaylist();
//     querySnapshot.docs.forEach((doc) async {
//       var tmp = Playlist.fromMap(doc.data() as Map<String, dynamic>);
//       if (tmp.imageURL == null || tmp.imageURL!.isEmpty) {
//         var firstTrack = await TrackRepo().getTrackById(tmp.listTrackId[0]);
//         tmp.imageURL = firstTrack.imageURL;
//         print(firstTrack.imageURL);
//       }
//       playlists.add(tmp);
//       notifyListeners();
//     });
//     print(playlists.length);
//     notifyListeners();
//   }
// }