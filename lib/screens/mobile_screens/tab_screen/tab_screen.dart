import 'package:flutter/material.dart';
import 'package:music_app/screens/mobile_screens/tab_screen/tabs/library_tab/library_tab.dart';
import 'package:provider/provider.dart';

import '../../../utils/asset_paths.dart';
import '../../../view_models/home_pager_view_model.dart';
import '../../../view_models/play_view_model.dart';
import '../../../widgets/mini_play_track_widget.dart';
import 'tabs/home_tab/home_tab.dart';
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
  final _listTab = [
    const HomeTab(),
    const SearchTab(),
    const SongRecognitionTab(),
    const YourTrackTab(),
    const LibraryTab(),
  ];

  @override
  void dispose() {
    Provider.of<HomePagerViewModel>(context).disposePageController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const TabNavBar(),
      backgroundColor: Colors.transparent,
      drawerScrimColor: Colors.transparent,
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AssetPaths.imagePath.getBackgroundImagePath),
                fit: BoxFit.cover),
          ),
          child: Consumer<PlayViewModel>(builder: (context, model, child) {
            var isPlaying = model.currentTrack != null;
            return SafeArea(
              child: Column(children: [
                Expanded(
                  child: PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _listTab.length,
                      itemBuilder: (_, index) => _listTab[index],
                      allowImplicitScrolling: false,
                      controller: Provider.of<HomePagerViewModel>(context)
                          .pageController,
                      scrollDirection: Axis.horizontal),
                ),
                isPlaying ? const MiniPlayTrackWidget() : const SizedBox(),
              ]),
            );
          })),
    );
  }
}
