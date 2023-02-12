import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_app/utils/constants/app_string.dart';

import '../models/db_models/app_user.dart';
import 'exception.dart';

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

  signOut() async {
    await firebaseAuth.signOut();
  }
  
  Future<void> updateImageURL(String userId, String imageURL) async {
    await firebaseFirestore
        .collection(AppString.userCollection)
        .doc(userId)
        .update({AppString.imageURL: imageURL});
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

  Future<void> updateName(String id, String name) async {
    await firebaseFirestore
        .collection(AppString.userCollection)
        .doc(id)
        .update({AppString.name: name});
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