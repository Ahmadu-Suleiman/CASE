import 'package:cached_network_image/cached_network_image.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:flutter/material.dart';

class ClickableImage extends StatelessWidget {
  final String imageUrl;
  const ClickableImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.routeCasePhoto,
            arguments: imageUrl);
      },
      child: CachedNetworkImage(
        imageUrl: imageUrl, // Replace with your actual image URL
        fit: BoxFit.cover,
        width: 250,
        height: 250,
        placeholder: (context, url) =>
            const CircularProgressIndicator(), // Optional: Show a loading spinner while the image is being fetched
        errorWidget: (context, url, error) => const Icon(Icons
            .image), // Optional: Show an error icon if the image fails to load
      ),
    );
  }
}
