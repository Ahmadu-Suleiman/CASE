import 'package:case_be_heard/custom_widgets/cached_image.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MembersListWidget extends StatelessWidget {
  final CommunityMember member;
  const MembersListWidget({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      CachedAvatar(
          url: member.photoUrl,
          size: 20,
          onPressed: () =>
              context.push('${Routes.memberProfileOthers}/${member.uid}')),
      const SizedBox(width: 4),
      Column(children: [
        Text(Utility.getFirstAndlastName(member), maxLines: 1),
        const SizedBox(height: 2),
        Text(member.occupation, maxLines: 1)
      ])
    ]);
  }
}
