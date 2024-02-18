import 'package:case_be_heard/models/comment.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseComments {
  static final CollectionReference commentsCollection =
      FirebaseFirestore.instance.collection('caseComments');

  static Future<void> addComment(
      BuildContext context, String caseRecordId, Comment comment) async {
    commentsCollection.add({...comment.toMap()}).then(
        (_) => Utility.showSnackBar(context, 'comment added'));
  }

  static Future<void> deleteComment(
      BuildContext context, String commentId) async {
    return commentsCollection
        .doc(commentId)
        .delete()
        .then((_) => Utility.showSnackBar(context, 'comment added'));
  }

  static Stream<List<Comment>> getComments(String caseRecordId) {
    return commentsCollection
        .where('caseRecordId', isEqualTo: caseRecordId)
        .orderBy('dateCreated', descending: true)
        .snapshots()
        .asyncMap((snapshots) async {
      List<Future<Comment>> commentFutures = snapshots.docs
          .map((doc) => Comment.fromMap(doc as Map<String, dynamic>))
          .toList();
      return await Future.wait(commentFutures);
    });
  }
}
