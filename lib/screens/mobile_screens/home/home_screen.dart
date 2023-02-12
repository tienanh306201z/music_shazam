// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../view_models/home_view_model.dart';
// import '../../../widgets/card_item_widget.dart';
// import '../song/playlist_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
//         child: Consumer<HomeViewModel>(
//           builder: (context, model, child) {
//             return model.playlists.isNotEmpty
//                 ? Column(
//                     children: [
//                       Column(
//                         children: model.playlists
//                             .map((playlist) {
//                               return CardItemWidget(
//                                 name: playlist.name,
//                                 imageURL: playlist.imageURL ?? "https://reactnative-examples.com/wp-content/uploads/2022/02/default-loading-image.png",
//                                 onTap: () {
//                                   Navigator.push(context, MaterialPageRoute(builder: (_) => PlaylistScreen(playlist: playlist,)));
//                                 },
//                               );
//                         })
//                             .toList(),
//                       ),
//                     ],
//                   )
//                 : const CircularProgressIndicator();
//           },
//         ),
//       ),
//     );
//   }
// }
