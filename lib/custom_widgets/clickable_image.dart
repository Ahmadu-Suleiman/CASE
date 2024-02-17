import 'package:cached_network_image/cached_network_image.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClickableImage extends StatelessWidget {
  final String imageUrl;
  const ClickableImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => context
            .push('${Routes.casePhoto}/${Uri.encodeComponent(imageUrl)}'),
        child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            width: 250,
            height: 250,
            placeholder: (context, url) => const Icon(Icons.image),
            errorWidget: (context, url, error) => const Icon(Icons.image)));
  }
}
