import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_app/utils/extension.dart';

import '../../utils/helper.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [

        ],
      ),
    );
  }

}
