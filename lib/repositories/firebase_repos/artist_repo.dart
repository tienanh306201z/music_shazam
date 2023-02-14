import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_app/utils/app_string.dart';

import '../../models/db_models/artist.dart';

class ArtistRepo {
  final FirebaseFirestore firebaseFirestore;

  ArtistRepo({required this.firebaseFirestore});

  Future<AppArtist> getArtistById(String id) async {
    var query = await firebaseFirestore.collection(AppString.artistCollection).doc(id).get();
    var artist = AppArtist.fromMap(query.data()!);
    return artist;
  }
}