import 'package:flutter/material.dart';
import 'package:music_app/repositories/global_repo.dart';
import 'package:provider/provider.dart';

import '../../../repositories/exception.dart';
import '../../../utils/app_flushbar.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/asset_paths.dart';
import '../../../view_models/user_view_model.dart';
import '../../../widgets/general_header.dart';
import '../sign_up/sign_up_screen.dart';

final globalRepo = GlobalRepo.getInstance;

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GeneralHeader(title: "Sign in"),
                TextFormField(
                  controller: emailController,
                  cursorColor: AppColor.onPrimaryColor,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColor.greyColor, width: 2.0),
                    ),
                    floatingLabelStyle: TextStyle(color: AppColor.onPrimaryColor),
                    focusedBorder:UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColor.onPrimaryColor, width: 2.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    labelStyle: TextStyle(color: Colors.grey),
                    label: Text('Email',),
                  ),
                  style: const TextStyle(color: AppColor.onPrimaryColor),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: passwordController,
                  cursorColor: AppColor.onPrimaryColor,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColor.greyColor, width: 2.0),
                    ),
                    floatingLabelStyle: TextStyle(color: AppColor.onPrimaryColor),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColor.onPrimaryColor, width: 2.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    labelStyle: TextStyle(color: Colors.grey),
                    label: Text('Password'),
                  ),
                  style: const TextStyle(color: AppColor.onPrimaryColor),
                  autocorrect: false,
                  obscureText: true,
                ),
                const SizedBox(height: 20,),
                SizedBox(
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
                          side: BorderSide(color: AppColor.primaryColor),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      String email = emailController.text.trim();
                      String password = passwordController.text.trim();
                      try {
                        await globalRepo.signInWithEmail(email, password);
                        var currentUser = await globalRepo.getCurrentUser();
                        if (currentUser != null) {
                          if (!mounted) return;
                          Provider.of<UserViewModel>(context, listen: false).setCurrentUser(currentUser);
                          Navigator.pop(context);
                          AppSnackBar.showSnackBar(context, 'Sign in successfully', AppSnackBarType.success);
                        } else {
                          if (!mounted) return;
                          AppSnackBar.showSnackBar(context, 'Failed', AppSnackBarType.failed);
                        }
                      } catch (e) {
                        if (e is UserNotFoundAuthException) {
                          AppSnackBar.showSnackBar(context, 'User not found', AppSnackBarType.failed);
                        } else if (e is WrongPasswordAuthException) {
                          AppSnackBar.showSnackBar(context, 'Wrong password', AppSnackBarType.failed);
                        } else {
                          AppSnackBar.showSnackBar(context, e.toString(), AppSnackBarType.failed);
                        }
                      }
                    },
                    child: const Text('Sign in', style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                ),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    const Text(
                      'Not have account yet? ',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColor.onPrimaryColor,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpScreen()));
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.onPrimaryColor,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
