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
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(children: [
              CachedAvatar(
                  url: member.photoUrl,
                  size: 25,
                  onPressed: () => context
                      .push('${Routes.memberProfileOthers}/${member.id}')),
              const SizedBox(width: 4),
              Column(children: [
                Text(Utility.getFirstAndlastName(member),
                    style: Theme.of(context).textTheme.labelLarge, maxLines: 1),
                const SizedBox(height: 2)
              ])
            ])),
        const Divider()
      ],
    );
  }
}
