import 'package:flutter/material.dart';
import 'package:music_app/view/song/playlist_screen.dart';
import 'package:music_app/view/widgets/song_item.dart';
import 'package:music_app/view_model/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
        child: Consumer<HomeViewModel>(
          builder: (context, model, child) {
            return model.songs.isNotEmpty
                ? Column(
                    children: [
                      Column(
                        children: model.songs
                            .map((song) => SongItem(song: song))
                            .toList(),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => PlaylistScreen()));
                        },
                        child: Text('Playlist'),
                      ),
                    ],
                  )
                : const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
