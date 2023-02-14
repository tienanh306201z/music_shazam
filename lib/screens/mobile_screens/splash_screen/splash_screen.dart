import 'package:flutter/material.dart';
import 'package:music_app/utils/asset_paths.dart';
import 'package:provider/provider.dart';

import '../../../navigations/app_nav_host.dart';
import '../../../utils/app_colors.dart';
import '../../../view_models/playlist_view_model.dart';
import '../../../view_models/track_view_model.dart';
import '../../../view_models/user_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var _startAnim = false;

  @override
  void initState() {
    super.initState();
    opacityAnim();
    Provider.of<TrackViewModel>(context, listen: false).getAllTracks();
    Provider.of<TrackViewModel>(context, listen: false).getTop10Tracks();
    Provider.of<PlaylistViewModel>(context, listen: false).getAllPlaylist();
    Provider.of<UserViewModel>(context, listen: false).init();
    Future.delayed(const Duration(seconds: 3)).then((value) =>
        Navigator.of(context).pushReplacementNamed(AppRoutes.tabScreen.name));
  }

  void opacityAnim() async {
    Future.delayed(const Duration(milliseconds: 300),).then((_) {
      setState(() {
        _startAnim = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AssetPaths.imagePath.getBackgroundImagePath),
                fit: BoxFit.cover)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 100.0),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 2500),
                opacity: _startAnim ? 1.0 : 0.0,
                child: Image.asset(
                  AssetPaths.imagePath.getAppLogoImagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const Spacer(),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 2500),
              opacity: _startAnim ? 1.0 : 0.0,
              child: const Text(
                "Muzikal",
                style: TextStyle(
                    color: AppColor.onPrimaryColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w700,
                    height: 32.0 / 24.0),
              ),
            ),
            const SizedBox(
              height: 32.0,
            )
          ],
        ),
      ),
    );
  }
}
