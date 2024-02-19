import 'dart:math';

import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMember {
  // collection reference
  static final CollectionReference communityMemberCollection =
      FirebaseFirestore.instance.collection('communityMembers');

  static Future<void> updateCommunityMemberData(CommunityMember member) async {
    return await communityMemberCollection.doc(member.id).set({
      'firstName': member.firstName,
      'lastName': member.lastName,
      'email': member.email,
      'phoneNumber': member.phoneNumber,
      'occupation': member.occupation,
      'location': member.location,
      'gender': member.gender,
      'bio': member.bio,
      'photoUrl': member.photoUrl,
    });
  }

  static CommunityMember _communityMemberFromSnapshot(
      DocumentSnapshot snapshot) {
    return CommunityMember.full(
        id: snapshot.id,
        firstName: snapshot['firstName'] ?? '',
        lastName: snapshot['lastName'] ?? '',
        email: snapshot['email'] ?? '',
        phoneNumber: snapshot['phoneNumber'] ?? '',
        occupation: snapshot['occupation'] ?? '',
        location: snapshot['location'],
        gender: snapshot['gender'] ?? '',
        photoUrl: snapshot['photoUrl'] ?? '',
        bio: snapshot['bio'] ?? '',
        bookmarkCaseIds: Utility.stringList(snapshot, 'bookmarksCase'));
  }

  static Stream<List<CommunityMember?>> get communityMembers {
    return communityMemberCollection.snapshots().map((snapshots) {
      return snapshots.docs.map(_communityMemberFromSnapshot).toList();
    });
  }

  static Stream<CommunityMember?>? getMember(String? uid) {
    return communityMemberCollection
        .doc(uid)
        .snapshots()
        .map(_communityMemberFromSnapshot);
  }

  static Future<CommunityMember> getCommunityMember(String uid) async {
    return _communityMemberFromSnapshot(
        await communityMemberCollection.doc(uid).get());
  }

  static Future<List<CommunityMember>> getCommunityMembers(
      List<String> memberIds) async {
    return await Future.wait(memberIds.map((memberId) =>
        communityMemberCollection
            .doc(memberId)
            .get()
            .then(_communityMemberFromSnapshot)));
  }

  static Future<List<CommunityMember>> getCommunityMembersByIds(
      List<String> ids) async {
    List<CommunityMember> communityMembers = [];

    // Split the list into chunks of   10 or fewer
    List<List<String>> chunks = List.generate((ids.length / 10).ceil(), (i) {
      int start = i * 10;
      int end = min(start + 10, ids.length);
      return ids.sublist(start, end);
    });

    // Query Firestore for each chunk and merge the results
    for (var chunk in chunks) {
      QuerySnapshot querySnapshot = await communityMemberCollection
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      communityMembers.addAll(querySnapshot.docs
          .map((doc) => _communityMemberFromSnapshot(doc))
          .toList());
    }
    return communityMembers;
  }

  static Future<void> addBookmarkCaseRecord(
      CommunityMember member, CaseRecord caseRecord) async {
    String memberId = member.id!;
    String caseRecordId = caseRecord.id;
    await communityMemberCollection.doc(memberId).update({
      'bookmarksCase': FieldValue.arrayUnion([caseRecordId])
    });
  }

  static Future<void> removeBookmarkCase(
      CommunityMember member, CaseRecord caseRecord) async {
    String memberId = member.id!;
    String caseRecordId = caseRecord.id;
    await communityMemberCollection.doc(memberId).update({
      'bookmarksCase': FieldValue.arrayRemove([caseRecordId])
    });
  }
}
