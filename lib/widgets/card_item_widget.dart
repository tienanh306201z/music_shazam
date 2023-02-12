// import 'package:flutter/material.dart';
// import 'package:music_app/models/db_models/artist.dart';
//
// import '../repositories/track_repo.dart';
//
// class CardItemWidget extends StatefulWidget {
//   final String name;
//   String? artistId;
//   final String imageURL;
//   Function onTap;
//
//   CardItemWidget(
//       {Key? key, required this.name, required this.imageURL, this.artistId, required this.onTap})
//       : super(key: key);
//
//   @override
//   State<CardItemWidget> createState() => _CardItemWidgetState();
// }
//
// class _CardItemWidgetState extends State<CardItemWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         widget.onTap.call();
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 10),
//         height: 70,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(10),
//               topRight: Radius.circular(10),
//               bottomLeft: Radius.circular(10),
//               bottomRight: Radius.circular(10)
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 5,
//               blurRadius: 7,
//               offset: Offset(0, 3), // changes position of shadow
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             const SizedBox(width: 10,),
//             Image.network(
//               widget.imageURL,
//               width: 60,
//               height: 60,
//               fit: BoxFit.cover,
//             ),
//             const SizedBox(width: 20,),
//             Container(
//               height: 60,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 210,
//                     child: Text(
//                       widget.name,
//                       style: TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.bold),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   const SizedBox(height: 10,),
//                   widget.artistId != null
//                       ? FutureBuilder(
//                           future: TrackRepo().getArtistById(widget.artistId!),
//                           builder: (context, snapshot) {
//                             if (snapshot.hasData) {
//                               var artist = snapshot.data! as Artist;
//                               return Text(
//                                 artist.name, style: const TextStyle(fontSize: 14,),
//                               );
//                             } else {
//                               return SizedBox();
//                             }
//                           },
//                       )
//                       : SizedBox(),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
