import 'package:cached_network_image/cached_network_image.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  @override
  Widget build(BuildContext context) {
    CommunityMember member = context.watch<CommunityMember>();
    String? photoUrl = member.photoUrl;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: CachedNetworkImageProvider(photoUrl),
            fit: BoxFit.contain,
          )),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: TextButton.icon(
                  onPressed: () async {
                    Utility.pickandUpdateProfileImage(context, member);
                  },
                  icon: const Icon(Icons.image),
                  label: const Text('Change image',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ))))),
    );
  }
}
