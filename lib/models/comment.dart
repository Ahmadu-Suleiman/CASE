import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String commentText;
  String authorId;
  String caseRecordId;
  String commentType;
  Timestamp dateCreated;
  late CommunityMember author;

  Comment(
      {required this.commentText,
      required this.authorId,
      required this.caseRecordId,
      required this.commentType,
      required this.dateCreated,
      required this.author});
  Comment.forUpload(
      {required this.commentText,
      required this.authorId,
      required this.caseRecordId,
      required this.commentType,
      required this.dateCreated});

  // Convert a Comment object into a Map
  Map<String, dynamic> toMap() {
    return {
      'commentText': commentText,
      'authorId': authorId,
      'commentType': commentType,
      'dateCreated': dateCreated,
      'caseRecordId': caseRecordId
    };
  }

  static Future<Comment> fromMap(Map<String, dynamic> map) async {
    String authorId = map['authorId'];
    CommunityMember member =
        await DatabaseMember(uid: authorId).getCommunityMember();
    return Comment(
        commentText: map['commentText'],
        authorId: authorId,
        caseRecordId: map['caseRecordId'],
        commentType: map['commentType'],
        dateCreated: map['dateCreated'],
        author: member);
  }
}
