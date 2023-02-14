import 'package:flutter/material.dart';
import 'package:music_app/screens/mobile_screens/detected_song_screen/detected_song_screen.dart';
import 'package:music_app/screens/mobile_screens/playlist_screen/playlist_screen.dart';
import 'package:music_app/screens/mobile_screens/profile_screen/profile_screen.dart';
import 'package:music_app/screens/mobile_screens/sign_in_screen/sign_in_screen.dart';
import 'package:music_app/screens/mobile_screens/sign_up_screen/sign_up_screen.dart';
import 'package:music_app/screens/mobile_screens/tab_screen/tab_screen.dart';

import '../screens/mobile_screens/play_screen/play_screen.dart';
import '../screens/mobile_screens/splash_screen/splash_screen.dart';

enum AppRoutes {
  splashScreen,
  signUpScreen,
  signInScreen,
  tabScreen,
  playScreen,
  detectedSongScreen,
  playlistScreen,
  profileScreen
}

class AppNavHost {
  static final Map<String, WidgetBuilder> routes = {
    AppRoutes.splashScreen.name: (_) => const SplashScreen(),
    AppRoutes.signUpScreen.name: (_) => const SignUpScreen(),
    AppRoutes.signInScreen.name: (_) => const SignInScreen(),
    AppRoutes.tabScreen.name: (_) => const TabScreen(),
    AppRoutes.playScreen.name: (_) => const PlayScreen(),
    AppRoutes.detectedSongScreen.name: (_) => const DetectedSongScreen(),
    AppRoutes.playlistScreen.name: (_) => const PlaylistScreen(),
    AppRoutes.profileScreen.name: (_) => const ProfileScreen(),
  };
}