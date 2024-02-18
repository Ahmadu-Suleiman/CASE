import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  final String authorName;
  final String profilePictureUrl;
  final String commentText;
  final String commentDate;

  const CommentWidget({
    super.key,
    required this.authorName,
    required this.profilePictureUrl,
    required this.commentText,
    required this.commentDate,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(profilePictureUrl),
      ),
      title: Text(
        authorName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(commentText),
      trailing: Text(commentDate),
    );
  }
}
