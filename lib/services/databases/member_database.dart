import 'dart:math';

import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/models/community.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/models/petition.dart';
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
      'communityIds': member.communityIds,
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
      bookmarkCaseIds: Utility.stringList(snapshot, 'bookmarksCase'),
      bookmarkPetitionIds: Utility.stringList(snapshot, 'bookmarksPetition'),
      communityIds: Utility.stringList(snapshot, 'communityIds'),
    );
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

    // Split the list into chunks of 10 or fewer
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

  static Future<List<String>> addBookmarkCaseRecord(
      CommunityMember member, CaseRecord caseRecord) async {
    String memberId = member.id!;
    String caseRecordId = caseRecord.id;
    DocumentReference memberRef = communityMemberCollection.doc(memberId);
    await memberRef.update({
      'bookmarksCase': FieldValue.arrayUnion([caseRecordId])
    });
    // Fetch the updated document to get the new list of bookmarked petitions
    DocumentSnapshot updatedMemberDoc = await memberRef.get();
    List<dynamic> updatedBookmarkedPetitionIds =
        updatedMemberDoc.get('bookmarksCase') ?? [];
    // Convert the list of dynamic to a list of strings
    List<String> updatedBookmarks = updatedBookmarkedPetitionIds.cast<String>();
    // Return the updated list of bookmarked petition IDs
    return updatedBookmarks;
  }

  static Future<List<String>> removeBookmarkCase(
      CommunityMember member, CaseRecord caseRecord) async {
    String memberId = member.id!;
    String caseRecordId = caseRecord.id;
    DocumentReference memberRef = communityMemberCollection.doc(memberId);
    await memberRef.update({
      'bookmarksCase': FieldValue.arrayRemove([caseRecordId])
    });
    // Fetch the updated document to get the new list of bookmarked petitions
    DocumentSnapshot updatedMemberDoc = await memberRef.get();
    List<dynamic> updatedBookmarkedPetitionIds =
        updatedMemberDoc.get('bookmarksCase') ?? [];
    // Convert the list of dynamic to a list of strings
    List<String> updatedBookmarks = updatedBookmarkedPetitionIds.cast<String>();
    // Return the updated list of bookmarked petition IDs
    return updatedBookmarks;
  }

  static Future<List<String>> addBookmarkPetition(
      CommunityMember member, Petition petition) async {
    String memberId = member.id!;
    String petitionId = petition.id;
    DocumentReference memberRef = communityMemberCollection.doc(memberId);
    await memberRef.update({
      'bookmarksPetition': FieldValue.arrayUnion([petitionId])
    });
    // Fetch the updated document to get the new list of bookmarked petitions
    DocumentSnapshot updatedMemberDoc = await memberRef.get();
    List<dynamic> updatedBookmarkedPetitionIds =
        updatedMemberDoc.get('bookmarksPetition') ?? [];
    // Convert the list of dynamic to a list of strings
    List<String> updatedBookmarks = updatedBookmarkedPetitionIds.cast<String>();
    // Return the updated list of bookmarked petition IDs
    return updatedBookmarks;
  }

  static Future<List<String>> removeBookmarkPetition(
      CommunityMember member, Petition petition) async {
    String memberId = member.id!;
    String petitionId = petition.id;
    DocumentReference memberRef = communityMemberCollection.doc(memberId);
    await memberRef.update({
      'bookmarksPetition': FieldValue.arrayRemove([petitionId])
    });
    // Fetch the updated document to get the new list of bookmarked petitions
    DocumentSnapshot updatedMemberDoc = await memberRef.get();
    List<dynamic> updatedBookmarkedPetitionIds =
        updatedMemberDoc.get('bookmarksPetition') ?? [];
    // Convert the list of dynamic to a list of strings
    List<String> updatedBookmarks = updatedBookmarkedPetitionIds.cast<String>();
    // Return the updated list of bookmarked petition IDs
    return updatedBookmarks;
  }

  static Future<List<String>> addCommunity(
      CommunityMember member, Community community) async {
    String memberId = member.id!;
    String communityId = community.id;
    DocumentReference memberRef = communityMemberCollection.doc(memberId);
    await memberRef.update({
      'bookmarksPetition': FieldValue.arrayUnion([petitionId])
    });
    // Fetch the updated document to get the new list of bookmarked petitions
    DocumentSnapshot updatedMemberDoc = await memberRef.get();
    List<dynamic> updatedBookmarkedPetitionIds =
        updatedMemberDoc.get('bookmarksPetition') ?? [];
    // Convert the list of dynamic to a list of strings
    List<String> updatedBookmarks = updatedBookmarkedPetitionIds.cast<String>();
    // Return the updated list of bookmarked petition IDs
    return updatedBookmarks;
  }

  static Future<List<String>> removeBookmarkPetition(
      CommunityMember member, Petition petition) async {
    String memberId = member.id!;
    String petitionId = petition.id;
    DocumentReference memberRef = communityMemberCollection.doc(memberId);
    await memberRef.update({
      'bookmarksPetition': FieldValue.arrayRemove([petitionId])
    });
    // Fetch the updated document to get the new list of bookmarked petitions
    DocumentSnapshot updatedMemberDoc = await memberRef.get();
    List<dynamic> updatedBookmarkedPetitionIds =
        updatedMemberDoc.get('bookmarksPetition') ?? [];
    // Convert the list of dynamic to a list of strings
    List<String> updatedBookmarks = updatedBookmarkedPetitionIds.cast<String>();
    // Return the updated list of bookmarked petition IDs
    return updatedBookmarks;
  }
}
