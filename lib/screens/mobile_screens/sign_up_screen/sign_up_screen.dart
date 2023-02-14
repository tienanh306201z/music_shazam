import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../repositories/global_repo.dart';
import '../../../utils/exception.dart';
import '../../../utils/app_flushbar.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/asset_paths.dart';
import '../../../view_models/user_view_model.dart';
import '../../../widgets/general_header.dart';

final globalRepo = GlobalRepo.getInstance;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GeneralHeader(title: "Sign up"),
              TextFormField(
                controller: nameController,
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
                  label: Text('Name',),
                ),
                style: const TextStyle(color: AppColor.onPrimaryColor),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "You must enter this field!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10,),
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
              const SizedBox(height: 10,),
              TextFormField(
                controller: confirmPasswordController,
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
                  label: Text('Confirm password'),
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
                  child: const Text('Sign up', style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
