import 'package:flutter/foundation.dart';
import 'package:music_app/repositories/global_repo.dart';

import '../models/db_models/playlist.dart';

class PlaylistViewModel extends ChangeNotifier {
  Future<List<Playlist>> getAllPlaylist() async {
    return GlobalRepo.getInstance.getAllPlaylist();
  }
}