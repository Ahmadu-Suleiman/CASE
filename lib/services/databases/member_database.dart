
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/models/community.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/models/petition.dart';
import 'package:case_be_heard/services/location.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:quiver/iterables.dart';

class DatabaseMember {
  // collection reference
  static final CollectionReference communityMemberCollection =
      FirebaseFirestore.instance.collection('communityMembers');

  static Future<void> updateCommunityMember(CommunityMember member) async {
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

  static Future<CommunityMember> _communityMemberFromSnapshot(
      DocumentSnapshot snapshot) async {
    GeoPoint location = snapshot['location'];
    Placemark placemark = await LocationService.getLocationAddress(location);
    String address = await LocationService.getLocationAddressString(location);
    return CommunityMember.full(
      id: snapshot.id,
      firstName: snapshot['firstName'] ?? '',
      lastName: snapshot['lastName'] ?? '',
      email: snapshot['email'] ?? '',
      phoneNumber: snapshot['phoneNumber'] ?? '',
      occupation: snapshot['occupation'] ?? '',
      location: location,
      gender: snapshot['gender'] ?? '',
      photoUrl: snapshot['photoUrl'] ?? '',
      bio: snapshot['bio'] ?? '',
      bookmarkCaseIds: Utility.stringList(snapshot, 'bookmarksCase'),
      bookmarkPetitionIds: Utility.stringList(snapshot, 'bookmarksPetition'),
      communityIds: Utility.stringList(snapshot, 'communityIds'),
      placemark: placemark,
      address: address,
    );
  }

  static Stream<Future<List<CommunityMember?>>> get communityMembers {
    return communityMemberCollection.snapshots().map((snapshots) {
      return Future.wait(
          snapshots.docs.map(_communityMemberFromSnapshot).toList());
    });
  }

  static Stream<CommunityMember?>? getMember(String? uid) {
    return communityMemberCollection
        .doc(uid)
        .snapshots()
        .asyncMap(_communityMemberFromSnapshot);
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

    List<List<String>> chunks = partition(ids, 10).toList();

    for (var chunk in chunks) {
      QuerySnapshot querySnapshot = await communityMemberCollection
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      final membersFutures = await Future.wait(querySnapshot.docs
          .map((doc) => _communityMemberFromSnapshot(doc))
          .toList());
      communityMembers.addAll(membersFutures);
    }
    return communityMembers;
  }

  static Future<List<CommunityMember>> getCommunityMembersForCommunity(
      String communityId) async {
    QuerySnapshot querySnapshot = await communityMemberCollection
        .where('communityIds', arrayContains: communityId)
        .get();

    return Future.wait(querySnapshot.docs
        .map((doc) => _communityMemberFromSnapshot(doc))
        .toList());
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
    List<dynamic> updatedBookmarkedCaseIds =
        updatedMemberDoc.get('bookmarksCase') ?? [];
    // Convert the list of dynamic to a list of strings
    List<String> updatedBookmarks = updatedBookmarkedCaseIds.cast<String>();
    // Return the updated list of bookmarked petition IDs
    return updatedBookmarks;
  }

  static Future<List<String>> removeBookmarkCaseRecord(
      CommunityMember member, CaseRecord caseRecord) async {
    String memberId = member.id!;
    String caseRecordId = caseRecord.id;
    DocumentReference memberRef = communityMemberCollection.doc(memberId);
    await memberRef.update({
      'bookmarksCase': FieldValue.arrayRemove([caseRecordId])
    });
    // Fetch the updated document to get the new list of bookmarked petitions
    DocumentSnapshot updatedMemberDoc = await memberRef.get();
    List<dynamic> updatedBookmarkedCaseIds =
        updatedMemberDoc.get('bookmarksCase') ?? [];
    // Convert the list of dynamic to a list of strings
    List<String> updatedBookmarks = updatedBookmarkedCaseIds.cast<String>();
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
    DocumentSnapshot updatedMemberDoc = await memberRef.get();
    List<dynamic> updatedBookmarkedPetitionIds =
        updatedMemberDoc.get('bookmarksPetition') ?? [];
    List<String> updatedBookmarks = updatedBookmarkedPetitionIds.cast<String>();
    return updatedBookmarks;
  }

  static Future<void> addCaseOrPetitionCommunity(
      CommunityMember member, String communityId) async {
    String memberId = member.id!;
    DocumentReference memberRef = communityMemberCollection.doc(memberId);
    await memberRef.update({
      'communityIds': FieldValue.arrayUnion([communityId])
    });
  }

  static Future<List<String>> addCommunity(
      CommunityMember member, Community community) async {
    String memberId = member.id!;
    String communityId = community.id;
    DocumentReference memberRef = communityMemberCollection.doc(memberId);
    await memberRef.update({
      'communityIds': FieldValue.arrayUnion([communityId])
    });
    DocumentSnapshot updatedMemberDoc = await memberRef.get();
    List<dynamic> updatedCommunityIds =
        updatedMemberDoc.get('communityIds') ?? [];
    List<String> updatedCommunities = updatedCommunityIds.cast<String>();
    return updatedCommunities;
  }

  static Future<List<String>> removeCommunity(
      CommunityMember member, Community community) async {
    String memberId = member.id!;
    String communityId = community.id;
    DocumentReference memberRef = communityMemberCollection.doc(memberId);
    await memberRef.update({
      'communityIds': FieldValue.arrayRemove([communityId])
    });
    DocumentSnapshot updatedMemberDoc = await memberRef.get();
    List<dynamic> updatedCommunityIds =
        updatedMemberDoc.get('communityIds') ?? [];
    List<String> updatedCommunities = updatedCommunityIds.cast<String>();
    return updatedCommunities;
  }
}
