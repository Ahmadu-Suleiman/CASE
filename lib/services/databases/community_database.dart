import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:case_be_heard/models/community.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class DatabaseCommunity {
  static final CollectionReference communityCollection =
      FirebaseFirestore.instance.collection('communities');

  static Future<void> uploadCommunityData(Community community) async {
    DocumentReference communityRef =
        await communityCollection.add(<String, dynamic>{});
    String id = communityRef.id;
    community.image =
        await StorageService.uploadCommunityImage(id, community.image);
    return await communityCollection.doc(id).set({
      'name': community.name,
      'image': community.image,
      'state': community.state,
      'countryISO': community.countryISO,
      'maintainerIds': community.maintainerIds,
      'memberIds': community.memberIds,
      'dateCreated': community.dateCreated,
      'description': community.description,
      'regulations': community.regulations
    });
  }

  static Future<void> updateCommunityData(Community community) async {
    community.image = await StorageService.updateCommunityImage(
        community.id, community.image);
    return await communityCollection.doc(community.id).update({
      'name': community.name,
      'image': community.image,
      'state': community.state,
      'countryISO': community.countryISO,
      'maintainerIds': community.maintainerIds,
      'memberIds': community.memberIds,
      'description': community.description,
      'regulations': community.regulations
    });
  }

  static Community _communityFromSnapshot(DocumentSnapshot snapshot) {
    return Community(
        id: snapshot.id,
        name: snapshot['name'] ?? '',
        image: snapshot['image'] ?? '',
        state: snapshot['state'] ?? '',
        countryISO: snapshot['countryISO'] ?? '',
        dateCreated: snapshot['dateCreated'],
        description: snapshot['description'] ?? '',
        maintainerIds: Utility.stringList(snapshot, 'maintainerIds'),
        memberIds: Utility.stringList(snapshot, 'memberIds'),
        regulations: snapshot['regulations'] ?? '');
  }

  static Stream<List<Community?>> get communities {
    return communityCollection.snapshots().map((snapshots) {
      return snapshots.docs.map(_communityFromSnapshot).toList();
    });
  }

  static Stream<Community?>? getCommunity(String? id) {
    return communityCollection.doc(id).snapshots().map(_communityFromSnapshot);
  }

  static Future<Community> getCommunityById(String stateId) async {
    return _communityFromSnapshot(await communityCollection.doc(stateId).get());
  }

  static Future<List<Community>> getAllCommunitiesForState(
      {String? searchText,
      required String state,
      required String countryISO}) async {
    QuerySnapshot querySnapshot;
    Query query = communityCollection
        .orderBy('name')
        .where('state', isEqualTo: state)
        .where('countryISO', isEqualTo: countryISO);

    if (searchText != null && searchText.isNotEmpty) {
      query = query.startAt([searchText]).endAt(['$searchText\uf8ff']);
    }

    querySnapshot = await query.get();
    final caseRecords = querySnapshot.docs.map(_communityFromSnapshot).toList();
    return caseRecords;
  }

  static Future<void> fetchCommunities(
      {int limit = 10,
      DocumentSnapshot? pageKey,
      required PagingController pagingController,
      String? searchText,
      required String state,
      required String countryISO}) async {
    QuerySnapshot querySnapshot;
    Query query = communityCollection
        .orderBy('dateCreated', descending: true)
        .where('state', isEqualTo: state)
        .where('countryISO', isEqualTo: countryISO);

    if (searchText != null && searchText.isNotEmpty) {
      query = query.startAt([searchText]).endAt(['$searchText\uf8ff']);
    }

    if (pageKey != null) {
      querySnapshot =
          await query.startAfterDocument(pageKey).limit(limit).get();
    } else {
      querySnapshot = await query.limit(limit).get();
    }

    if (querySnapshot.docs.isNotEmpty) {
      final caseRecordList =
          querySnapshot.docs.map(_communityFromSnapshot).toList();
      final bool isLastPage = caseRecordList.length < 10;
      final DocumentSnapshot? lastDoc =
          isLastPage ? null : querySnapshot.docs.last;

      if (isLastPage) {
        pagingController.appendLastPage(caseRecordList);
      } else {
        pagingController.appendPage(caseRecordList, lastDoc);
      }
    } else {
      pagingController.appendLastPage(<Community>[]);
    }
  }

  static Future<Set<String>> getUniqueStates(String countryISO) async {
    QuerySnapshot querySnapshot = await communityCollection
        .where('countryISO', isEqualTo: countryISO)
        .get();
    Set<String> uniqueStates = {};

    for (var doc in querySnapshot.docs) {
      String state = doc['state'];
      uniqueStates.add(state);
    }
    return uniqueStates;
  }

  static Future<List<String>> addMaintainer(
      Community community, CommunityMember member) async {
    String memberId = member.id!;
    String communityId = community.id;
    DocumentReference communityRef = communityCollection.doc(communityId);
    await communityRef.update({
      'maintainerIds': FieldValue.arrayUnion([memberId])
    });
    // Fetch the updated document to get the new list of bookmarked petitions
    DocumentSnapshot updatedCommunityDoc = await communityRef.get();
    List<dynamic> updatedMaintainerIds =
        updatedCommunityDoc.get('maintainerIds') ?? [];
    // Convert the list of dynamic to a list of strings
    List<String> updatedMaintainers = updatedMaintainerIds.cast<String>();
    // Return the updated list of bookmarked petition IDs
    return updatedMaintainers;
  }

  static Future<List<String>> removeMaintainer(
      Community community, CommunityMember member) async {
    String memberId = member.id!;
    String communityId = community.id;
    DocumentReference communityRef = communityCollection.doc(communityId);
    await communityRef.update({
      'maintainerIds': FieldValue.arrayRemove([memberId])
    });
    // Fetch the updated document to get the new list of bookmarked petitions
    DocumentSnapshot updatedCommunityDoc = await communityRef.get();
    List<dynamic> updatedMaintainerIds =
        updatedCommunityDoc.get('maintainerIds') ?? [];
    // Convert the list of dynamic to a list of strings
    List<String> updatedMaintainers = updatedMaintainerIds.cast<String>();
    // Return the updated list of bookmarked petition IDs
    return updatedMaintainers;
  }
}
