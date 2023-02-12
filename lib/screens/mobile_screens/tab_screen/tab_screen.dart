import 'package:flutter/material.dart';

import '../../../utils/constants/asset_paths.dart';
import 'tabs/home_tab/home_tab.dart';
import 'tabs/profile_tab/profile_tab.dart';
import 'tabs/search_tab/search_tab.dart';
import 'tabs/song_recognition_tab/song_recognition_tab.dart';
import 'tabs/your_track_tab/your_track_tab.dart';
import 'widgets/tab_nav_bar.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final _pageController = PageController(initialPage: 0);

  final _listTab = [
    const HomeTab(),
    const SearchTab(),
    const SongRecognitionTab(),
    const YourTrackTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TabNavBar(pageController: _pageController),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AssetPaths.imagePath.getBackgroundImagePath),
              fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _listTab.length,
              itemBuilder: (_, index) => _listTab[index],
              allowImplicitScrolling: false,
              controller: _pageController,
              scrollDirection: Axis.horizontal),
        ),
      ),
    );
  }
}