import 'package:flutter/material.dart';

import '../models/db_models/track.dart';
import '../repositories/global_repo.dart';

class TrackViewModel extends ChangeNotifier {
  List<Track> tracks = [];
  final globalRepo = GlobalRepo.getInstance;

  Future<void> getAllTracks() async {
    print("GET TRACK");
    List<Track> allTracks = await globalRepo.getAllTracks();
    tracks = allTracks;
    notifyListeners();
  }
}