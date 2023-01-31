import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/song.dart';
import '../repository/upload_repository.dart';

class UploadViewModel extends ChangeNotifier {
  File? imageFile;
  File? songFile;

  bool isLoading = false;

  List<PlatformFile>? _pathsImage, _pathsSong;
  String? _extension;
  bool _multiPick = false;
  
  final uploadRepo = UploadRepository();

  selectImage() async {
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

  selectSong() async {
    _pathsSong = (await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: _multiPick,
      onFileLoading: (FilePickerStatus status) => print(status),
      allowedExtensions: (_extension?.isNotEmpty ?? false)
          ? _extension?.replaceAll(' ', '').split(',')
          : null,
    ))
        ?.files;

    if (_pathsSong!.isNotEmpty) {
      songFile = File(_pathsSong![0].path!);
      notifyListeners();
    }
  }

  storeSong(String name, String artistName) async {
    isLoading = true;
    notifyListeners();
    var uuid = const Uuid();
    var v1 = uuid.v1();
    await uploadRepo.storeSong(v1, imageFile!, _pathsImage![0].name, songFile!, _pathsSong![0].name, name, artistName);
    isLoading = false;
    notifyListeners();
  }
}