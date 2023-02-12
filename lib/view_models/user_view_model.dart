import 'package:flutter/material.dart';

import '../models/db_models/app_user.dart';
import '../repositories/global_repo.dart';

class UserViewModel extends ChangeNotifier {
  AppUser? currentUser;
  final globalRepo = GlobalRepo.getInstance;

  init() async {
    AppUser? user = await globalRepo.getCurrentUser();
    setCurrentUser(user);
  }

  setCurrentUser(AppUser? newUser) {
    currentUser = newUser;
    notifyListeners();
  }

  signOut() async {
    await globalRepo.signOut();
    currentUser = null;
    notifyListeners();
  }
}