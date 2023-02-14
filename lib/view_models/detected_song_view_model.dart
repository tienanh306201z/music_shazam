import 'package:flutter/material.dart';

import '../models/db_models/detected_song.dart';
import '../repositories/global_repo.dart';

class DetectedSongViewModel with ChangeNotifier {
  Future<DetectedSong?> getTrack(id) async {
    return GlobalRepo.getInstance.getTrack(id);
  }
}
