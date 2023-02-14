import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_app/models/in_app_models/nav_bar_model.dart';
import 'package:provider/provider.dart';

import '../../../../view_models/home_pager_view_model.dart';

class TabNavBar extends StatefulWidget {
  const TabNavBar({Key? key}) : super(key: key);

  @override
  State<TabNavBar> createState() => _TabNavBarState();
}

class _TabNavBarState extends State<TabNavBar> {
  var currentIndex = 0;

  final _listItem = [
    NavBarModel("Home", Icons.home_filled),
    NavBarModel("Search", Icons.search),
    NavBarModel("Recognition", FontAwesomeIcons.deezer),
    NavBarModel("Your track", Icons.playlist_play_rounded),
    NavBarModel("Library", Icons.stacked_bar_chart_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final pagerViewModel = Provider.of<HomePagerViewModel>(context);
    return BottomNavigationBar(
      items: _listItem
          .map((e) => BottomNavigationBarItem(
              icon: Icon(e.icon),
              label: e.title,
              backgroundColor: const Color(0xFF1A0A31)))
          .toList(),
      backgroundColor: const Color(0xFF1A0A31),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF3A61A0),
      unselectedItemColor: Colors.white,
      selectedLabelStyle: const TextStyle(color: Color(0xFF3A61A0)),
      currentIndex: currentIndex,
      onTap: (i) {
        setState(() {
          currentIndex = i;
        });
        pagerViewModel.navigateToPage(i, context);
      },
    );
  }
}
