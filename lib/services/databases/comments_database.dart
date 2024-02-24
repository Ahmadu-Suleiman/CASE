import 'package:case_be_heard/models/comment.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseComments {
  static final CollectionReference commentsCollection =
      FirebaseFirestore.instance.collection('caseComments');

  static Future<void> addComment(BuildContext context, Comment comment) async {
    commentsCollection.add({...comment.toMap()}).then(
        (_) => Utility.showSnackBar(context, 'comment added'));
  }

  static Future<void> updateComment(
      BuildContext context, Comment updatedComment) async {
    return commentsCollection
        .doc(updatedComment.commentId)
        .update(updatedComment.toMap())
        .then((_) => Utility.showSnackBar(context, 'comment updated'));
  }

  static Future<void> deleteComment(
      BuildContext context, Comment comment) async {
    return commentsCollection
        .doc(comment.commentId)
        .delete()
        .then((_) => Utility.showSnackBar(context, 'comment deleted'));
  }

  static Stream<List<Comment>> getComments(
      String caseRecordId, String commentsType) {
    return commentsCollection
        .where('caseRecordId', isEqualTo: caseRecordId)
        .where('commentType', isEqualTo: commentsType)
        .orderBy('dateCreated', descending: true)
        .snapshots()
        .asyncMap((snapshots) async {
      List<Future<Comment>> commentFutures = snapshots.docs
          .map((doc) =>
              Comment.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      List<Comment> comments = await Future.wait(commentFutures);
      return comments;
    });
  }

  static Future<int> getCommentCounts(String caseRecordId) async {
    final snapshot = await commentsCollection
        .where('caseRecordId', isEqualTo: caseRecordId)
        .get();
    return snapshot.docs.length;
  }
}
