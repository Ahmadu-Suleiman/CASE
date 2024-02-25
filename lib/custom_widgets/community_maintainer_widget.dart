import 'package:case_be_heard/custom_widgets/cached_image.dart';
import 'package:case_be_heard/models/community.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/community_database.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommunityMaintainerWidget extends StatelessWidget {
  final Community community;
  final CommunityMember member;
  final Function(List<String>) onChange;
  const CommunityMaintainerWidget(
      {super.key,
      required this.community,
      required this.member,
      required this.onChange});

  @override
  Widget build(BuildContext context) {
    bool isMaintainer = community.maintainerIds.contains(member.id);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(children: [
        CachedAvatar(
            url: member.photoUrl,
            onPressed: () =>
                context.push('${Routes.memberProfileOthers}/${member.id}')),
        const SizedBox(width: 8),
        Flexible(
            child: Text(Utility.getFirstAndlastName(member),
                overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 8),
        ElevatedButton(
            onPressed: () {
              if (isMaintainer) {
                DatabaseCommunity.removeMaintainer(community, member)
                    .then((maintainers) => onChange(maintainers));
              } else {
                DatabaseCommunity.addMaintainer(community, member)
                    .then((maintainers) => onChange(maintainers));
              }
            },
            child: Text(isMaintainer ? 'remove' : 'add'))
      ]),
    );
  }
}
