import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/db_models/app_user.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/asset_paths.dart';
import '../../../view_models/profile_view_model.dart';
import '../../../view_models/user_view_model.dart';
import '../../../widgets/cached_image_widget.dart';
import '../../../widgets/general_header.dart';

class EditProfileScreen extends StatefulWidget {
  final AppUser user;

  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.user.name;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
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
                    fit: BoxFit.cover),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GeneralHeader(
                        title: "Edit profile",
                        onTap: () {
                          model.reset();
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: model.imageFile == null
                                ? checkImage()
                                : Image.file(
                              model.imageFile!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: InkWell(
                              onTap: () async {
                                await model.selectImage();
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black45.withOpacity(0.3),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          model.changeName(value);
                        },
                        controller: nameController,
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
                            'Name',
                          ),
                        ),
                        style: const TextStyle(color: AppColor.onPrimaryColor),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: model.isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                          width: 160,
                          height: 48,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              foregroundColor:
                              MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor:
                              MaterialStateProperty.all<Color>(
                                  Colors.green),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(24.0),
                                  side: const BorderSide(
                                      color: Colors.green),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (model.imageFile != null ||
                                  model.name != null) {
                                await model.updateInfo(widget.user.id);
                                if (!mounted) return;
                                await Provider.of<UserViewModel>(context,
                                    listen: false)
                                    .init();
                                model.reset();
                                if (!mounted) return;
                                Navigator.pop(context);
                              }
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget checkImage() {
    return widget.user.imageURL == null || widget.user.imageURL!.isEmpty
        ? Image.asset(
      AssetPaths.imagePath.getDefaultImagePath,
      width: 120,
      height: 120,
      fit: BoxFit.cover,
    )
        : CachedImageWidget(
      imageURL: widget.user.imageURL!,
      width: 120,
      height: 120,
    );
  }
}