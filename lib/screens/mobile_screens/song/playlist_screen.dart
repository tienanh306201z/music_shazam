// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:music_app/repositories/track_repo.dart';
// import 'package:music_app/screens/mobile_screens/song/track_screen.dart';
// import 'package:music_app/utils/constants.dart';
//
// import '../../../models/db_models/playlist.dart';
// import '../../../models/db_models/track.dart';
// import '../../../widgets/card_item_widget.dart';
//
// class PlaylistScreen extends StatefulWidget {
//   final Playlist playlist;
//
//   const PlaylistScreen({Key? key, required this.playlist}) : super(key: key);
//
//   @override
//   State<PlaylistScreen> createState() => _PlaylistScreenState();
// }
//
// class _PlaylistScreenState extends State<PlaylistScreen> {
//   List<Track> listTrack = [];
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     widget.playlist.listTrackId.forEach((element) async {
//       var track = await TrackRepo().getTrackById(element);
//       setState(() {
//         listTrack.add(track);
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             bottom: PreferredSize(
//               preferredSize: Size.fromHeight(40),
//               child: Container(
//                 color: Colors.white,
//                 width: double.maxFinite,
//                 padding: EdgeInsets.only(top: 5, bottom: 10, left: 16, right: 16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       widget.playlist.name,
//                       style: const TextStyle(
//                           fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) => TrackScreen(playlist: widget.playlist, tracks: listTrack, isPlaylist: true)));
//                       },
//                       child: Stack(
//                         children: [
//                           Container(
//                             width: 40,
//                             height: 40,
//                             decoration: const BoxDecoration(
//                               color: Colors.blueAccent,
//                               borderRadius: BorderRadius.all(Radius.circular(20)),
//                             ),
//                           ),
//                           Positioned(
//                             top: 12,
//                             left: 12,
//                             child: Container(
//                               width: 16,
//                               height: 16,
//                               decoration: const BoxDecoration(
//                                 image: DecorationImage(
//                                   image: AssetImage('assets/icon/play-button-arrowhead.png'),
//                                   fit: BoxFit.cover,
//                                 )
//                               ),
//                             )
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             pinned: true,
//             expandedHeight: 300,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Image.network(
//                 widget.playlist.imageURL ?? Constants().loadingImage,
//                 width: double.maxFinite,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 children: listTrack
//                     .map((track) => CardItemWidget(
//                           name: track.name,
//                           imageURL: track.imageURL,
//                           artistId: track.artistId,
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (_) => TrackScreen(track: track)));
//                           },
//                         ))
//                     .toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
