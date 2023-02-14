import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/asset_paths.dart';
import '../../../view_models/user_view_model.dart';
import '../../../widgets/app_toaster.dart';
import '../../../widgets/cached_image_widget.dart';
import '../../../widgets/general_header.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, model, child) {
        var checkImageNull = model.currentUser?.imageURL == null || model.currentUser!.imageURL!.isEmpty;
        return Scaffold(
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AssetPaths.imagePath.getBackgroundImagePath),
                  fit: BoxFit.cover),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GeneralHeader(title: "Profile", onTap: () { },),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: checkImageNull
                                ? Image.asset(
                              AssetPaths.imagePath.getDefaultImagePath,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            )
                                : CachedImageWidget(
                              imageURL: model.currentUser!.imageURL!,
                              width: 64,
                              height: 64,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            model.currentUser?.name ?? "",
                            style: const TextStyle(
                              color: AppColor.onPrimaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProfileScreen(
                                user: model.currentUser!,
                              ),
                            ),
                          );
                        },
                        child: const Icon(Icons.edit_rounded, color: AppColor.onPrimaryColor,),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.onPrimaryColor,
                        ),
                      ),
                      Text(model.currentUser?.email ?? "", style: const TextStyle(color: AppColor.onPrimaryColor),),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  // const Text(
                  //   'Security',
                  //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      'Change password',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 160,
                      height: 48,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              side: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          await model.signOut();
                          if (!mounted) return;
                          Navigator.pop(context);
                          AppToaster.showToast(
                            context: context,
                            msg: 'Sign out successfully',
                            type: AppToasterType.success,
                          );
                        },
                        child: const Text(
                          "SIGN OUT",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}