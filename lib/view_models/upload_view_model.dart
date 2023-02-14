import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../repositories/global_repo.dart';

class UploadViewModel extends ChangeNotifier {
  final globalRepo = GlobalRepo.getInstance;

  File? imageFile;
  File? trackFile;
  File? beatFile;

  bool isLoading = false;

  List<PlatformFile>? _pathsImage, _pathsTrack, _pathsBeat;
  String? _extension;
  bool _multiPick = false;

  reset() {
    imageFile = null;
    trackFile = null;
    beatFile = null;
    isLoading = false;
    notifyListeners();
  }

  selectImage() async {
    _pathsImage = (await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: _multiPick,
      onFileLoading: (FilePickerStatus status) => print(status),
      allowedExtensions: (_extension?.isNotEmpty ?? false)
          ? _extension?.replaceAll(' ', '').split(',')
          : null,
    ))
        ?.files;

    if (_pathsImage != null) {
      imageFile = File(_pathsImage![0].path!);
      notifyListeners();
    }
  }

  selectTrack() async {
    _pathsTrack = (await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: _multiPick,
      onFileLoading: (FilePickerStatus status) => print(status),
      allowedExtensions: (_extension?.isNotEmpty ?? false)
          ? _extension?.replaceAll(' ', '').split(',')
          : null,
    ))
        ?.files;

    if (_pathsTrack != null) {
      trackFile = File(_pathsTrack![0].path!);
      notifyListeners();
    }
  }

  selectBeat() async {
    _pathsBeat = (await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: _multiPick,
      onFileLoading: (FilePickerStatus status) => print(status),
      allowedExtensions: (_extension?.isNotEmpty ?? false)
          ? _extension?.replaceAll(' ', '').split(',')
          : null,
    ))
        ?.files;

    if (_pathsBeat != null) {
      beatFile = File(_pathsBeat![0].path!);
      notifyListeners();
    }
  }

  getName(String path) {
    var list = path.split('/');
    return list.last;
  }

  updateInfoNewTrack({
    required String trackName,
    String? karaokeLink,
    String? lyrics,
    String? chordString,
    String? description,
    String? artistId,
  }) async {
    isLoading = true;
    notifyListeners();
    var uuid = const Uuid();
    var id = uuid.v1();
    if (imageFile != null && trackFile != null) {
      await globalRepo.updateInfoNewTrack(
        imageFile: imageFile!,
        imageName: getName(imageFile!.path),
        musicFile: trackFile!,
        beatFile: beatFile,
        trackName: trackName,
        id: id,
        karaokeLink: karaokeLink,
        lyrics: lyrics,
        chordString: chordString,
        description: description,
        artistId: artistId,
      );
      await globalRepo.updateUploadedTracksIdList(id);
    } else {}
    isLoading = false;
    notifyListeners();
  }

  Future<void> uploadPlaylist(
      {required String name,
      required List<String> tracksIdList,
      required String userId}) async {
    if (imageFile != null) {
      GlobalRepo.getInstance.uploadPlaylist(
          id: const Uuid().v1(),
          imageFile: imageFile!,
          name: name,
          imageName: getName(imageFile!.path),
          tracksIdList: tracksIdList,
          userId: userId);
    }
  }

// storeSong(String name, String artistName) async {
//   isLoading = true;
//   notifyListeners();
//   var uuid = const Uuid();
//   var v1 = uuid.v1();
//   await globalRepo.storeSong(v1, imageFile!, _pathsImage![0].name, songFile!, _pathsSong![0].name, name, artistName);
//   isLoading = false;
//   notifyListeners();
// }
}
