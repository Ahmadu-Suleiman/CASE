import 'package:case_be_heard/shared/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class CasePhotoWidget extends StatelessWidget {
  const CasePhotoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final String photoUrl =
        ModalRoute.of(context)!.settings.arguments as String;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Utility.getProfileImage(photoUrl),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
