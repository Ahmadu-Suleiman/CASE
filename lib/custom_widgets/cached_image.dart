import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedAvatar extends StatelessWidget {
  late String url;
  late double size;
  CachedAvatar({super.key, url, size});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        backgroundImage: imageProvider,
        radius: size,
      ),
      placeholder: (context, url) => Icon(
        Icons.image,
        size: size,
      ),
      errorWidget: (context, url, error) => Icon(
        Icons.image,
        size: size,
      ),
    );
  }
}
