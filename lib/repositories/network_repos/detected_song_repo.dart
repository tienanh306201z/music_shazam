import 'package:music_app/models/db_models/detected_song.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetectedSongRepo {
  Future<DetectedSong?> getTrack(id) async {
    try {
      final request =
          await http.get(Uri.parse("https://api.deezer.com/track/$id"));
      final json = jsonDecode(request.body) as Map<String, dynamic>;
      return DetectedSong.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
