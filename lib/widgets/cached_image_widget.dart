import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/asset_paths.dart';

class CachedImageWidget extends StatelessWidget {
  final String imageURL;
  final double? border;
  final double? width;
  final double? height;

  const CachedImageWidget(
      {Key? key, required this.imageURL, this.width, this.height, this.border})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageURL,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: border != null ? BorderRadius.circular(border!) : null,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: border != null ? BorderRadius.circular(border!) : null,
        ),
        child:
            Icon(FontAwesomeIcons.music, color: Colors.grey, size: width! / 2),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: border != null ? BorderRadius.circular(border!) : null,
        ),
        child:
            Icon(FontAwesomeIcons.music, color: Colors.grey, size: width! / 2),
      ),
    );
  }
}
