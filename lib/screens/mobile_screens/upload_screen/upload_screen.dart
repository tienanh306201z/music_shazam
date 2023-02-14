import 'package:flutter/material.dart';
import 'package:music_app/repositories/global_repo.dart';
import 'package:music_app/view_models/upload_view_model.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/asset_paths.dart';
import '../../../widgets/app_toaster.dart';
import '../../../widgets/general_header.dart';

final globalRepo = GlobalRepo.getInstance;

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final trackNameController = TextEditingController();
  final karaokeLinkController = TextEditingController();
  final lyricsController = TextEditingController();
  final chordController = TextEditingController();
  final descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<UploadViewModel>(
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            model.reset();
            return true;
          },
          child: Scaffold(
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                  AssetImage(AssetPaths.imagePath.getBackgroundImagePath),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GeneralHeader(
                          title: "Upload track",
                          onTap: () {
                            model.reset();
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Select image",
                              style: TextStyle(
                                  color: AppColor.onPrimaryColor, fontSize: 18),
                            ),
                            InkWell(
                              onTap: () async {
                                await model.selectImage();
                              },
                              child: const Text(
                                "Open",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    color: AppColor.onPrimaryColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        model.imageFile == null
                            ? const SizedBox()
                            : Center(
                            child: Image.file(
                              model.imageFile!,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            )),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Select track",
                              style: TextStyle(
                                  color: AppColor.onPrimaryColor, fontSize: 18),
                            ),
                            InkWell(
                              onTap: () async {
                                await model.selectTrack();
                              },
                              child: const Text(
                                "Open",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    color: AppColor.onPrimaryColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        model.trackFile == null
                            ? const SizedBox()
                            : Card(
                          elevation: 0,
                          color:
                          Theme.of(context).colorScheme.surfaceVariant,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: double.infinity,
                            height: 40,
                            child: Center(
                              child: Text(
                                model.getName(model.trackFile!.path),
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Select beat",
                              style: TextStyle(
                                  color: AppColor.onPrimaryColor, fontSize: 18),
                            ),
                            InkWell(
                              onTap: () async {
                                await model.selectBeat();
                              },
                              child: const Text(
                                "Open",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    color: AppColor.onPrimaryColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        model.beatFile == null
                            ? const SizedBox()
                            : Card(
                          elevation: 0,
                          color:
                          Theme.of(context).colorScheme.surfaceVariant,
                          child: Container(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10),
                            width: double.infinity,
                            height: 40,
                            child: Center(
                              child: Text(
                                model.getName(model.beatFile!.path),
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          controller: trackNameController,
                          cursorColor: AppColor.onPrimaryColor,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor.greyColor, width: 2.0),
                            ),
                            floatingLabelStyle:
                            TextStyle(color: AppColor.onPrimaryColor),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor.onPrimaryColor, width: 2.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelStyle: TextStyle(color: Colors.grey),
                            label: Text(
                              'Track name',
                            ),
                          ),
                          style: const TextStyle(color: AppColor.onPrimaryColor),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "You must enter this field!";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: karaokeLinkController,
                          cursorColor: AppColor.onPrimaryColor,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor.greyColor, width: 2.0),
                            ),
                            floatingLabelStyle:
                            TextStyle(color: AppColor.onPrimaryColor),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor.onPrimaryColor, width: 2.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelStyle: TextStyle(color: Colors.grey),
                            label: Text(
                              'Karaoke link (Youtube link)',
                            ),
                          ),
                          style: const TextStyle(color: AppColor.onPrimaryColor),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          maxLines: null,
                          controller: lyricsController,
                          cursorColor: AppColor.onPrimaryColor,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor.greyColor, width: 2.0),
                            ),
                            floatingLabelStyle:
                            TextStyle(color: AppColor.onPrimaryColor),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor.onPrimaryColor, width: 2.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelStyle: TextStyle(color: Colors.grey),
                            label: Text(
                              'Lyrics',
                            ),
                          ),
                          style: const TextStyle(color: AppColor.onPrimaryColor),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: chordController,
                          cursorColor: AppColor.onPrimaryColor,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor.greyColor, width: 2.0),
                            ),
                            floatingLabelStyle:
                            TextStyle(color: AppColor.onPrimaryColor),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor.onPrimaryColor, width: 2.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelStyle: TextStyle(color: Colors.grey),
                            label: Text(
                              'Chord',
                            ),
                          ),
                          style: const TextStyle(color: AppColor.onPrimaryColor),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: descriptionController,
                          cursorColor: AppColor.onPrimaryColor,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor.greyColor, width: 2.0),
                            ),
                            floatingLabelStyle:
                            TextStyle(color: AppColor.onPrimaryColor),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor.onPrimaryColor, width: 2.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelStyle: TextStyle(color: Colors.grey),
                            label: Text(
                              'Description',
                            ),
                          ),
                          style: const TextStyle(color: AppColor.onPrimaryColor),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        model.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : SizedBox(
                          height: 48,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              foregroundColor:
                              MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor:
                              MaterialStateProperty.all<Color>(
                                  AppColor.primaryColor),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  side: const BorderSide(
                                      color: AppColor.primaryColor),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (model.imageFile != null && model.trackFile != null) {
                                if (_formKey.currentState!.validate()) {
                                  String trackName =
                                  trackNameController.text.trim();
                                  String? karaokeLink =
                                  karaokeLinkController.text.trim();
                                  String? lyrics = lyricsController.text.trim();
                                  String? chord = chordController.text.trim();
                                  String? description =
                                  descriptionController.text.trim();
                                  await model.updateInfoNewTrack(
                                    trackName: trackName,
                                    karaokeLink: karaokeLink,
                                    lyrics: lyrics,
                                    chordString: chord,
                                    description: description,
                                  );
                                  if (!mounted) return;
                                  Navigator.pop(context);
                                }
                              } else {
                                AppToaster.showToast(context: context, msg: "Image file and track file must not be null", type: AppToasterType.warning,);
                              }

                            },
                            child: const Text(
                              'Upload',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}