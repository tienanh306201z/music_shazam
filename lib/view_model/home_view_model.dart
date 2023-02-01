import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/song.dart';
import '../repository/song_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final songRepo = SongRepository();
  List<Song> songs = [];

  getAllSongs() async {
    print("GET SONG");
    QuerySnapshot querySnapshot = await songRepo.getAllSongs();
    // Get data from docs and convert map to List
    songs = querySnapshot.docs.map((doc) => Song.fromMap(doc.data() as Map<String, dynamic>)).toList();
    notifyListeners();
  }
}