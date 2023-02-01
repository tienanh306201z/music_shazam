import 'package:cloud_firestore/cloud_firestore.dart';

class SongRepository {
  final firestore = FirebaseFirestore.instance;

  getAllSongs() {
    return firestore.collection('songs').get();
  }
}