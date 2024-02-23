import 'package:case_be_heard/models/petition.dart';
import 'package:case_be_heard/services/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:quiver/iterables.dart';

class DatabasePetition {
  static final CollectionReference petitionCollection =
      FirebaseFirestore.instance.collection('petitions');

  static Future<Petition> _petitionFromSnapshot(
      DocumentSnapshot snapshot) async {
    return Petition.fromMap(
        snapshot.data() as Map<String, dynamic>, snapshot.id);
  }

  static Stream<List<Petition>> get petitions {
    return petitionCollection.snapshots().asyncMap((snapshots) async {
      List<Future<Petition>> petitionFutures =
          snapshots.docs.map(_petitionFromSnapshot).toList();
      return await Future.wait(petitionFutures);
    });
  }

  static Future<Petition> getPetition(String uidPetition) async {
    DocumentSnapshot docSnapshot =
        await petitionCollection.doc(uidPetition).get();
    return await _petitionFromSnapshot(docSnapshot);
  }

  static Future<List<Petition>> getPetitionsByIds(List<String> ids) async {
    List<Petition> caseRecords = [];

    List<List<String>> chunks = partition(ids, 10).toList();

    for (var chunk in chunks) {
      QuerySnapshot querySnapshot = await petitionCollection
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      List<Petition> caseRecordsFromFuture = await Future.wait(
          querySnapshot.docs.map((doc) => _petitionFromSnapshot(doc)).toList());

      caseRecords.addAll(caseRecordsFromFuture);
    }
    return caseRecords;
  }

  static Future<List<Petition>> getPetitions(String memberId) async {
    QuerySnapshot querySnapshot = await petitionCollection
        .orderBy('dateCreated', descending: true)
        .where('memberId', isEqualTo: memberId)
        .get();

    return Future.wait(querySnapshot.docs.map(_petitionFromSnapshot).toList());
  }

  static Future<void> fetchPetitions(
      {int limit = 10,
      DocumentSnapshot? pageKey,
      required PagingController pagingController,
      String? communityId,
      List<String>? communityIds}) async {
    QuerySnapshot querySnapshot;
    Query query = petitionCollection.orderBy('dateCreated', descending: true);

    if (communityId != null) {
      query = query.where('communityId', isEqualTo: communityId);
    }
    if (communityIds != null && communityIds.isNotEmpty) {
      final chunkIds = partition(communityIds, 10).toList();
      for (final communityIds in chunkIds) {
        query = query.where('communityId', whereIn: communityIds);
      }
    }

    if (pageKey != null) {
      querySnapshot =
          await query.startAfterDocument(pageKey).limit(limit).get();
    } else {
      querySnapshot = await query.limit(limit).get();
    }

    _handleQuerySnapshot(querySnapshot.docs, pagingController, limit);
  }

  static void _handleQuerySnapshot(List<QueryDocumentSnapshot> docs,
      PagingController pagingController, int limit) async {
    if (docs.isNotEmpty) {
      List<Future<Petition>> petitionFutures =
          docs.map(_petitionFromSnapshot).toList();
      final petitionList = await Future.wait(petitionFutures);
      final bool isLastPage = petitionList.length < limit;
      final DocumentSnapshot? lastDoc = isLastPage ? null : docs.last;

      if (isLastPage) {
        pagingController.appendLastPage(petitionList);
      } else {
        pagingController.appendPage(petitionList, lastDoc);
      }
    } else {
      pagingController.appendLastPage(<Petition>[]);
    }
  }

  static Future<void> uploadPetition(Petition petition) async {
    DocumentReference petitionRef =
        await petitionCollection.add(<String, dynamic>{});
    String id = petitionRef.id;

    petition.image =
        await StorageService.uploadPetitionImage(id, petition.image);
    await petitionCollection.doc(id).set(petition.toMap());
  }

  static Future<void> updatePetition(Petition petition) async {
    petition.image =
        await StorageService.updatePetitionImage(petition.id, petition.image);
    await petitionCollection.doc(petition.id).update(petition.toMap());
  }

  static Future<void> deletePetition(Petition petition) async {
    await StorageService.deleteImagePetition(petition.id);
    await petitionCollection.doc(petition.id).delete();
  }

  static Future<void> addSignature(String memberId, Petition petition) async {
    String petitionId = petition.id;
    await petitionCollection.doc(petitionId).update({
      'signatoryIds': FieldValue.arrayUnion([memberId])
    });
  }
}
