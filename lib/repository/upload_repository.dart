import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/song.dart';

class UploadRepository {

  final ref = FirebaseStorage.instance.ref();
  final firestore = FirebaseFirestore.instance;

  uploadImage(String id, File imageFile, String imageName) async {
    final pathImage = "images/$id/$imageName";
    final childRef = ref.child(pathImage);
    final metadata = SettableMetadata(contentType: "image/jpeg");
    final snapshot = await childRef.putFile(imageFile, metadata);
    // uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
    //   switch (taskSnapshot.state) {
    //     case TaskState.running:
    //       final progress =
    //           100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
    //       print("Upload is $progress% complete.");
    //       break;
    //     case TaskState.paused:
    //       print("Upload is paused.");
    //       break;
    //     case TaskState.canceled:
    //       print("Upload was canceled");
    //       break;
    //     case TaskState.error:
    //     // Handle unsuccessful uploads
    //       break;
    //     case TaskState.success:
    //     // Handle successful uploads on complete
    //     // ...
    //       print("Upload is successfully");
    //       break;
    //   }
    // });
    return snapshot.ref.getDownloadURL();
  }

  uploadSong(String id, File songFile, String songName) async {
    final pathSong = "songs/$id/$songName";
    final childRef = ref.child(pathSong);
    final snapshot = await childRef.putFile(songFile);
    // uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
    //   switch (taskSnapshot.state) {
    //     case TaskState.running:
    //       final progress =
    //           100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
    //       print("Upload is $progress% complete.");
    //       break;
    //     case TaskState.paused:
    //       print("Upload is paused.");
    //       break;
    //     case TaskState.canceled:
    //       print("Upload was canceled");
    //       break;
    //     case TaskState.error:
    //     // Handle unsuccessful uploads
    //       break;
    //     case TaskState.success:
    //     // Handle successful uploads on complete
    //     // ...
    //       print("Upload is successfully");
    //       break;
    //   }
    // });
    return snapshot.ref.getDownloadURL();
  }

  storeSong(String id, File imageFile, String imageName, File songFile, String songName, String name, String artistName) async {
    String imageUrl = await uploadImage(id, imageFile, imageName);
    String songUrl = await uploadSong(id, songFile, songName);
    var song = Song.fromMap({
      'id': id,
      'name': name,
      'artistName': artistName,
      'imageUrl': imageUrl,
      'songUrl': songUrl,
    });
    await firestore.collection('songs').doc(song.id).set(song.toMap());
  }

}