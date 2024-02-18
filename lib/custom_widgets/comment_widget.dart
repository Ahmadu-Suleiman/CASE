import 'package:case_be_heard/custom_widgets/cached_image.dart';
import 'package:case_be_heard/shared/case_values.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  final String authorName;
  final String profilePictureUrl;
  final String commentText;
  final String commentType;
  final Timestamp commentDate;
  final bool isCaseRecordCreator;
  final Function(String) onChangeCategory;

  const CommentWidget({
    super.key,
    required this.authorName,
    required this.profilePictureUrl,
    required this.commentText,
    required this.commentType,
    required this.commentDate,
    required this.isCaseRecordCreator,
    required this.onChangeCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(4.0),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CachedAvatar(url: profilePictureUrl, size: 20),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(authorName),
                          Text(
                              'Uploaded ${timeago.format(commentDate.toDate())}')
                        ]),
                    Text(commentText)
                  ])),
              if (isCaseRecordCreator)
                DropdownButton<String>(
                  value: commentType,
                  items: CaseValues.dropdownItemsCommentsType
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    onChangeCategory(newValue!);
                  },
                ),
            ])));
  }
}
