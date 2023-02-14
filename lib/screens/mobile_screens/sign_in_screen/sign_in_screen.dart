import 'package:flutter/material.dart';
import 'package:music_app/repositories/global_repo.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/asset_paths.dart';
import '../../../utils/exception.dart';
import '../../../view_models/user_view_model.dart';
import '../../../widgets/app_toaster.dart';
import '../../../widgets/general_header.dart';
import '../sign_up_screen/sign_up_screen.dart';

final globalRepo = GlobalRepo.getInstance;

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

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
                  const GeneralHeader(title: "Sign in"),
                  TextFormField(
                    controller: emailController,
                    cursorColor: AppColor.onPrimaryColor,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: AppColor.greyColor, width: 2.0),
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
                        'Email',
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
                    controller: passwordController,
                    cursorColor: AppColor.onPrimaryColor,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: AppColor.greyColor, width: 2.0),
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
                      label: Text('Password'),
                    ),
                    style: const TextStyle(color: AppColor.onPrimaryColor),
                    autocorrect: false,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "You must enter this field!";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  !isLoading ? SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColor.primaryColor),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            side: BorderSide(color: AppColor.primaryColor),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();
                          try {
                            await globalRepo.signInWithEmail(email, password);
                            var currentUser = await globalRepo.getCurrentUser();
                            if (currentUser != null) {
                              if (!mounted) return;
                              Provider.of<UserViewModel>(context, listen: false)
                                  .setCurrentUser(currentUser);
                              Navigator.pop(context);
                              AppToaster.showToast(
                                context: context,
                                msg: 'Sign in successfully',
                                type: AppToasterType.success,
                              );
                            } else {
                              if (!mounted) return;
                              AppToaster.showToast(context: context, msg: 'Failed', type: AppToasterType.failed);
                            }
                          } catch (e) {
                            if (e is UserNotFoundAuthException) {
                              AppToaster.showToast(context: context, msg: 'User not found', type: AppToasterType.failed);
                            } else if (e is WrongPasswordAuthException) {
                              AppToaster.showToast(context: context, msg: 'Wrong password', type: AppToasterType.failed);
                            } else {
                              AppToaster.showToast(context: context, msg: e.toString(), type: AppToasterType.failed);
                            }
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ) : const Center(child: CircularProgressIndicator()),
                  const SizedBox(
                    height: 20,
                  ),
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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const SignUpScreen()));
                        },
                        child: const Text(
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
      ),
    );
  }
}