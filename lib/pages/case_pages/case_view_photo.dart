import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

class CasePhotoViewer extends StatelessWidget {
  final String photoUrl;
  const CasePhotoViewer({super.key, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(photoUrl),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
