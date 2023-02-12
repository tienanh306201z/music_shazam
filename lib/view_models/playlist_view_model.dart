import 'package:flutter/foundation.dart';
import 'package:music_app/repositories/global_repo.dart';

import '../models/db_models/playlist.dart';

class PlaylistViewModel extends ChangeNotifier {
  List<AppPlaylist> playlists = [];
  final globalRepo = GlobalRepo.getInstance;

  Future<void> getAllPlaylist() async {
    print("GET PLAYLIST");
    List<AppPlaylist> allPlaylists = await GlobalRepo.getInstance.getAllPlaylist();
    playlists = allPlaylists;
    print(playlists.length);
    notifyListeners();
  }
}