import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

class CasePhotoViewer extends StatelessWidget {
  const CasePhotoViewer({super.key});

  @override
  Widget build(BuildContext context) {
    final String photoUrl =
        ModalRoute.of(context)!.settings.arguments as String;
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
