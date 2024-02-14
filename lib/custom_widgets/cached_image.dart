import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedAvatar extends StatelessWidget {
  final String url;
  final double size;

  const CachedAvatar({super.key, required this.url, this.size = 30});

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