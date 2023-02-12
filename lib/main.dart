import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_app/screens/mobile_screens/tab_screen/tab_screen.dart';
import 'package:music_app/view_models/playlist_view_model.dart';
import 'package:music_app/view_models/profile_view_model.dart';
import 'package:music_app/view_models/track_view_model.dart';
import 'package:music_app/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

import 'view_models/play_view_model.dart';
import 'view_models/upload_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UploadViewModel()),
        ChangeNotifierProvider(create: (_) => PlayViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => PlaylistViewModel()),
        ChangeNotifierProvider(create: (_) => TrackViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Muzikal',
        theme: ThemeData.light().copyWith(
            useMaterial3: true, textTheme: GoogleFonts.montserratTextTheme()),
        home: const TabScreen(),
      ),
    );
  }
}
