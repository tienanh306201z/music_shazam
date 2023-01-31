
import 'package:flutter/material.dart';
import 'package:music_app/view_model/upload_view_model.dart';
import 'package:provider/provider.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final songController = TextEditingController();
  final artistController = TextEditingController();


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    songController.dispose();
    artistController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<UploadViewModel>(
        builder: (context, model, child) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await model.selectImage();
                    },
                    child: const Text('Select image'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await model.selectSong();
                    },
                    child: const Text('Select song'),
                  ),
                  TextFormField(
                    controller: songController,
                    decoration: const InputDecoration(
                      label: Text('Enter song name'),
                    ),
                  ),
                  TextFormField(
                    controller: artistController,
                    decoration: const InputDecoration(
                      label: Text('Enter artist name'),
                    ),
                  ),
                  model.songFile == null ? SizedBox() : Text(model.songFile!.path),
                  model.imageFile == null ? SizedBox() : Image.file(model.imageFile!),
                  model.isLoading ? CircularProgressIndicator() : SizedBox(),
                  ElevatedButton(
                    onPressed: () async {
                      await model.storeSong(songController.text, artistController.text);
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
