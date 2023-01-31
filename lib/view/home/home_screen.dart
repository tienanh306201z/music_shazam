import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  bool isplaying1 = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Initializing the Music Player and adding a single [PlaylistItem]
  Future<void> initPlatformState() async {
    try {
      await assetsAudioPlayer.open(
        Audio.network("https://firebasestorage.googleapis.com/v0/b/music-app-c388e.appspot.com/o/songs%2F9fa2e420-a06f-11ed-a3d1-c5ddf14590d8%2Fy2mate.com%20-%20%C4%90I%20%C4%90%E1%BB%82%20TR%E1%BB%9E%20V%E1%BB%80%202%20OFFICIAL%20%20CHUY%E1%BA%BEN%20%C4%90I%20C%E1%BB%A6A%20N%C4%82M%20%20SOOBIN%20HO%C3%80NG%20S%C6%A0N%20x%20BITIS%20HUNTER.mp3?alt=media&token=8ac5e0f6-bdae-4a31-9be6-45a41a4dd854"),
      );
    } catch (t) {
      //mp3 unreachable
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music Player App"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  "Song name",
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                 "Artist name",
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                Card(
                  child: Image.network("https://firebasestorage.googleapis.com/v0/b/music-app-c388e.appspot.com/o/images%2F9fa2e420-a06f-11ed-a3d1-c5ddf14590d8%2FFB_IMG_1614082135835.jpg?alt=media&token=cf381643-d488-4af6-a483-ff5cd799b39e", height: 350.0),
                  elevation: 10.0,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 100.0,
                    ),
                    IconButton(
                        icon: Icon(isplaying1 ? Icons.pause:Icons.play_arrow),
                        iconSize: 60.0,
                        color: isplaying1? Colors.blue:Colors.black,
                        onPressed: (){
                          if(isplaying1){
                            assetsAudioPlayer.pause();

                            setState(() {
                              isplaying1=false;
                            });
                          }
                          else{
                            setState(() {
                              isplaying1=true;
                            });

                            assetsAudioPlayer.play();
                          }
                        }),

                    SizedBox(
                      width: 10.0,
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.stop,
                        ),
                        color: isplaying1?Colors.black:Colors.blue,
                        iconSize: 60.0,
                        onPressed: (){
                          assetsAudioPlayer.stop();
                          setState(() {
                            isplaying1=false;
                          });
                        }
                    ),

                  ],
                )
              ],
            )),
      ),
    );
  }
}
