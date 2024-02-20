import 'package:case_be_heard/custom_widgets/cached_image.dart';
import 'package:case_be_heard/models/comment.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/shared/case_values.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;
  final bool isCaseRecordCreator;
  final Function(String) onChangeCategory;

  const CommentWidget({
    super.key,
    required this.comment,
    required this.isCaseRecordCreator,
    required this.onChangeCategory,
  });

  @override
  Widget build(BuildContext context) {
    CommunityMember author = comment.author;
    return Card(
        margin: const EdgeInsets.all(4.0),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CachedAvatar(
                  url: author.photoUrl,
                  size: 20,
                  onPressed: () {
                    context.push('${Routes.memberProfileOthers}/${author.id}');
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(Utility.getFirstAndlastName(author)),
                            Text(
                                'Uploaded ${timeago.format(comment.dateCreated.toDate())}')
                          ]),
                      Text(comment.commentText)
                    ])),
              ]),
              if (isCaseRecordCreator)
                DropdownButton<String>(
                    value: comment.commentType,
                    items: CaseValues.dropdownItemsCommentsType
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      onChangeCategory(newValue!);
                    })
            ])));
  }
}
