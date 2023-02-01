import 'package:flutter/material.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/view/song/song_screen.dart';

class SongItem extends StatelessWidget {
  final Song song;
  const SongItem({Key? key, required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => SongScreen(song: song)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 10,),
            Image.network(
              song.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 20,),
            Container(
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 210,
                    child: Text(
                      song.name,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Text(song.artistName, style: TextStyle(fontSize: 14),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
