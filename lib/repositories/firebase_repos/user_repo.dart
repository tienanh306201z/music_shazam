import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_app/utils/app_string.dart';

import '../../models/db_models/app_user.dart';
import '../../utils/exception.dart';

class UserRepo {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  UserRepo({required this.firebaseAuth, required this.firebaseFirestore});

  String? getCurrentUserId() {
    return firebaseAuth.currentUser?.uid;
  }

  Future<AppUser?> getCurrentUser() async {
    var currentUserId = getCurrentUserId();
    if (currentUserId != null) {
      var query = await firebaseFirestore.collection(AppString.userCollection).doc(getCurrentUserId()).get();
      var user = AppUser.fromMap(query.data()!);
      return user;
    }
    return null;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStreamUserById(String id) {
    return firebaseFirestore.collection(AppString.userCollection).doc(id).snapshots();
  }

  Future<AppUser> getUserById(String userId) async {
    var query = await firebaseFirestore.collection(AppString.userCollection).doc(userId).get();
    var user = AppUser.fromMap(query.data()!);
    return user;
  }

  signInWithEmail(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  signUpWithEmail(String name, String email, String password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var id = getCurrentUserId();
      await updateNewUser(id!, name, email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> updateNewUser(String id, String name, String email,) async {
    var user = AppUser(id: id, name: name, role: 0, email: email);
    await firebaseFirestore
        .collection(AppString.userCollection)
        .doc(id).set(user.toMap());
  }

  Future<void> updateImageURL(String userId, String imageURL) async {
    await firebaseFirestore
        .collection(AppString.userCollection)
        .doc(userId)
        .update({AppString.imageURL: imageURL});
  }

  Future<void> updateName(String id, String name) async {
    await firebaseFirestore
        .collection(AppString.userCollection)
        .doc(id)
        .update({AppString.name: name});
  }

  Future<void> updateLikedTracksIdList(String trackId) async {
    AppUser? user = await getCurrentUser();
    var likedTracksIdList = user!.likedTracksIdList;
    if (likedTracksIdList.contains(trackId)) {
      likedTracksIdList.remove(trackId);
    } else {
      likedTracksIdList.add(trackId);
    }
    await firebaseFirestore
        .collection(AppString.userCollection)
        .doc(user.id)
        .update({AppString.likedTracksIdList: likedTracksIdList});
  }

  Future<void> updatePlaylistIdList(String playlistId) async {
    AppUser? user = await getCurrentUser();
    var playlistsIdList = user!.playlistsIdList;
    if (playlistsIdList.contains(playlistId)) {
      playlistsIdList.remove(playlistId);
    } else {
      playlistsIdList.add(playlistId);
    }
    await firebaseFirestore
        .collection(AppString.userCollection)
        .doc(user.id)
        .update({AppString.playlistsIdList: playlistsIdList});
  }

  Future<void> updateUploadedTracksIdList(String trackId) async {
    AppUser? user = await getCurrentUser();
    var uploadedTracksIdList = user!.uploadedTracksIdList;
    if (uploadedTracksIdList.contains(trackId)) {
      uploadedTracksIdList.remove(trackId);
    } else {
      uploadedTracksIdList.add(trackId);
    }
    await firebaseFirestore
        .collection(AppString.userCollection)
        .doc(user.id)
        .update({AppString.uploadedTracksIdList: uploadedTracksIdList});
  }

// uploadImage(String id, File imageFile, String imageName) async {
//   String imageURL = await uploadRepo.uploadImage(id, imageFile, imageName);
//   firestore.collection('users').doc(id).update({'imageURL': imageURL});
// }
//
// updateName(String id, String name) async {
//   firestore.collection('users').doc(id).update({'name': name});
// }

}