import 'package:case_be_heard/services/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:case_be_heard/models/community.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class DatabaseCommunity {
  static final CollectionReference communityCollection =
      FirebaseFirestore.instance.collection('communities');

  static Future<DocumentReference> uploadCommunityData(
      Community community) async {
    DocumentReference communityRef =
        await communityCollection.add(<String, dynamic>{});
    String id = communityRef.id;
    community.image =
        await StorageService.uploadCommunityImage(id, community.image);
    return await communityCollection.add({
      'name': community.name,
      'image': community.image,
      'state': community.state,
      'countryISO': community.countryISO,
      'adminIds': community.adminIds,
      'memberIds': community.memberIds,
      'dateCreated': community.dateCreated,
      'description': community.description,
      'regulations': community.regulations
    });
  }

  static Future<void> updateCommunityData(Community community) async {
    community.image = await StorageService.updateCommunityImage(
        community.id, community.image);
    return await communityCollection.doc(community.id).set({
      'name': community.name,
      'image': community.image,
      'state': community.state,
      'countryISO': community.countryISO,
      'adminIds': community.adminIds,
      'memberIds': community.memberIds,
      'dateCreated': community.dateCreated,
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
        adminIds: Utility.stringList(snapshot, 'adminIds'),
        memberIds: Utility.stringList(snapshot, 'memberIds'),
        regulations: Utility.stringList(snapshot, 'regulations'));
  }

  static Stream<List<Community?>> get communities {
    return communityCollection.snapshots().map((snapshots) {
      return snapshots.docs.map(_communityFromSnapshot).toList();
    });
  }

  static Stream<Community?>? getCommunity(String? stateId) {
    return communityCollection
        .doc(stateId)
        .snapshots()
        .map(_communityFromSnapshot);
  }

  static Future<Community> getCommunityById(String stateId) async {
    return _communityFromSnapshot(await communityCollection.doc(stateId).get());
  }

  static Future<void> fetchCommunities(
      {int limit = 10,
      DocumentSnapshot? pageKey,
      required PagingController pagingController,
      required String state,
      required String countryISO}) async {
    QuerySnapshot querySnapshot;
    Query query = communityCollection
        .orderBy('dateCreated', descending: true)
        .where('state', isEqualTo: state)
        .where('countryISO', isEqualTo: countryISO);

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
}
