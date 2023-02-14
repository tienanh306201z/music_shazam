import 'package:flutter/foundation.dart';

import '../models/db_models/playlist.dart';
import '../repositories/global_repo.dart';

class PlaylistViewModel extends ChangeNotifier {
  List<AppPlaylist> playlists = [];
  final globalRepo = GlobalRepo.getInstance;

  Future<void> getAllPlaylist() async {
    List<AppPlaylist> allPlaylists =
        await GlobalRepo.getInstance.getAllPlaylist();
    playlists = allPlaylists;
    notifyListeners();
  }

  List<AppPlaylist> getSearchedPlaylists(String text) {
    return playlists
        .where((element) =>
            element.name.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }
}
