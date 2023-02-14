import 'package:flutter/material.dart';

import '../models/db_models/track.dart';
import '../repositories/global_repo.dart';

class TrackViewModel extends ChangeNotifier {
  List<Track> tracks = [];
  List<Track> top10Tracks = [];
  final globalRepo = GlobalRepo.getInstance;

  Future<void> getAllTracks() async {
    List<Track> allTracks = await globalRepo.getAllTracks();
    tracks = allTracks;
    notifyListeners();
  }

  Future<void> getTop10Tracks() async {
    List<Track> tracks = await globalRepo.getTop10Tracks();
    top10Tracks = tracks;
    notifyListeners();
  }

  List<Track> getSearchedTracks(String text) {
    return tracks.where((element) => element.name.toLowerCase().contains(text.toLowerCase())).toList();
  }
}
