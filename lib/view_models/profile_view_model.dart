import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:music_app/repositories/global_repo.dart';
import 'package:music_app/utils/constants/app_string.dart';

class ProfileViewModel extends ChangeNotifier {
  final globalRepo = GlobalRepo.getInstance;
  File? imageFile;
  String? name;
  bool isLoading = false;

  List<PlatformFile>? _pathsImage;
  String? _extension;
  bool _multiPick = false;

  void disposed() {
    print("Dispose");
    isLoading = false;
    imageFile = null;
    _pathsImage = null;
    _extension = null;
    notifyListeners();
  }

  Future<void> selectImage() async {
    _pathsImage = (await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: _multiPick,
      onFileLoading: (FilePickerStatus status) => print(status),
      allowedExtensions: (_extension?.isNotEmpty ?? false)
          ? _extension?.replaceAll(' ', '').split(',')
          : null,
    ))?.files;

    imageFile = File(_pathsImage![0].path!);
    notifyListeners();
  }

  void changeName(String newName) {
    name = newName;
    notifyListeners();
  }

  Future<void> updateInfo(String id) async {
    isLoading = true;
    notifyListeners();
    if (imageFile != null) {
      await globalRepo.updateImageURL(AppString.userCollection, id, imageFile!, id);
    }
    if (name != null) {
      await globalRepo.updateName(id, name!);
    }
    isLoading = false;
    notifyListeners();
  }
}