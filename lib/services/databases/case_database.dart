import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/models/video.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:case_be_heard/services/storage.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class DatabaseCase {
  // collection reference
  static final CollectionReference caseCollection =
      FirebaseFirestore.instance.collection('caseRecords');

  static Future<CaseRecord> _caseRecordFromSnapshot(
      DocumentSnapshot snapshot) async {
    CommunityMember member =
        await DatabaseMember(uid: snapshot['uidMember']).getCommunityMember();
    List<String> videoLinks = Utility.stringList(snapshot, 'videos');
    List<String> thumbnails = Utility.stringList(snapshot, 'thumbnails');
    List<Video> videos = List.generate(videoLinks.length, (index) {
      String videoLink = videoLinks[index];
      String thumbnail = thumbnails[index];
      return Video.fromCase(videoLink, thumbnail);
    });

    return CaseRecord(
      uid: snapshot['uid'] ?? '',
      uidMember: snapshot['uidMember'] ?? '',
      dateCreated: snapshot['dateCreated'] ?? Timestamp.now(),
      member: member,
      title: snapshot['title'] ?? '',
      summary: snapshot['summary'] ?? '',
      details: snapshot['details'] ?? '',
      type: snapshot['type'] ?? '',
      progress: snapshot['progress'] ?? '',
      views: Utility.stringList(snapshot, 'views'),
      reads: Utility.stringList(snapshot, 'reads'),
      mainImage: snapshot['mainImage'] ?? '',
      location: snapshot['location'],
      photos: Utility.stringList(snapshot, 'photos'),
      videos: videos,
      audios: Utility.stringList(snapshot, 'audios'),
      links: Utility.stringList(snapshot, 'links'),
    );
  }

  static Stream<List<CaseRecord>> get caseRecords {
    return caseCollection.snapshots().asyncMap((snapshots) async {
      // Convert each document to a CaseRecord and wait for all futures to complete
      List<Future<CaseRecord>> caseRecordFutures =
          snapshots.docs.map(_caseRecordFromSnapshot).toList();
      return await Future.wait(caseRecordFutures);
    });
  }

  static Stream<List<CaseRecord>> caseRecordsMember(String uidMember) {
    return caseCollection
        .where('uidMember', isEqualTo: uidMember)
        .snapshots()
        .asyncMap((snapshots) async {
      // Convert each document to a CaseRecord and wait for all futures to complete
      List<Future<CaseRecord>> caseRecordFutures =
          snapshots.docs.map(_caseRecordFromSnapshot).toList();
      return await Future.wait(caseRecordFutures);
    });
  }

  static Future<CaseRecord> getCaseRecord(String uidCase) async {
    DocumentSnapshot docSnapshot = await caseCollection.doc(uidCase).get();
    return await _caseRecordFromSnapshot(docSnapshot);
  }

  static Future<void> fetchCaseRecords(
      {int limit = 10,
      DocumentSnapshot? pageKey,
      required PagingController pagingController,
      String? progress}) async {
    QuerySnapshot querySnapshot;
    Query query = caseCollection.orderBy('dateCreated', descending: true);
    if (progress != null) {
      query = query.where('progress', isEqualTo: progress);
    }

    if (pageKey != null) {
      querySnapshot =
          await query.startAfterDocument(pageKey).limit(limit).get();
    } else {
      querySnapshot = await query.limit(limit).get();
    }

    if (querySnapshot.docs.isNotEmpty) {
      List<Future<CaseRecord>> caseRecordFutures =
          querySnapshot.docs.map(_caseRecordFromSnapshot).toList();
      final caseRecordList = await Future.wait(caseRecordFutures);
      final bool isLastPage = caseRecordList.length < 10;
      final DocumentSnapshot? lastDoc =
          isLastPage ? null : querySnapshot.docs.last;

      if (isLastPage) {
        pagingController.appendLastPage(caseRecordList);
      } else {
        pagingController.appendPage(caseRecordList, lastDoc);
      }
    }
  }

  static Future<void> fetchCaseRecordsForMember(
      {int limit = 10,
      DocumentSnapshot? pageKey,
      required PagingController pagingController,
      required String caseId}) async {
    QuerySnapshot querySnapshot;
    if (pageKey != null) {
      querySnapshot = await caseCollection
          .where('id', isEqualTo: caseId)
          .orderBy('dateCreated', descending: true)
          .startAfterDocument(pageKey)
          .limit(limit)
          .get();
    } else {
      querySnapshot = await caseCollection
          .where('id', isEqualTo: caseId)
          .orderBy('dateCreated', descending: true)
          .limit(limit)
          .get();
    }

    if (querySnapshot.docs.isNotEmpty) {
      List<Future<CaseRecord>> caseRecordFutures =
          querySnapshot.docs.map(_caseRecordFromSnapshot).toList();
      final caseRecordList = await Future.wait(caseRecordFutures);
      final bool isLastPage = caseRecordList.length < 10;
      final DocumentSnapshot? lastDoc =
          isLastPage ? null : querySnapshot.docs.last;

      if (isLastPage) {
        pagingController.appendLastPage(caseRecordList);
      } else {
        pagingController.appendPage(caseRecordList, lastDoc);
      }
    }
  }

  static Future<void> uploadCaseRecord(CaseRecord caseRecord) async {
    caseRecord.uid = CaseRecord.generateCaseId();
    caseRecord.dateCreated = Timestamp.now();
    caseRecord.views = [];
    caseRecord.reads = [];
    caseRecord.mainImage = await StorageService.uploadCaseRecordMainImage(
        caseRecord.uid, caseRecord.mainImage);
    caseRecord.photos = await StorageService.uploadCaseRecordPhotos(
        caseRecord.uid, caseRecord.photos);
    List<String> videoLinks = await StorageService.uploadCaseRecordVideos(
        caseRecord.uid, caseRecord.videos);
    List<String> thumbnails = await StorageService.uploadCaseRecordThumbnails(
        caseRecord.uid, caseRecord.videos);

    caseRecord.videos = List.generate(videoLinks.length, (index) {
      String videoLink = videoLinks[index];
      String thumbnail = thumbnails[index];
      return Video.fromCase(videoLink, thumbnail);
    });

    caseRecord.audios = await StorageService.uploadCaseRecordAudios(
        caseRecord.uid, caseRecord.audios);

    await caseCollection.doc(caseRecord.uid).set(caseRecord.toMap());
  }

  static Future<void> updateCaseRecord(CaseRecord caseRecord) async {
    caseRecord.mainImage = await StorageService.updateCaseRecordMainImage(
        caseRecord.uid, caseRecord.mainImage);
    caseRecord.photos = await StorageService.updateCaseRecordPhotos(
        caseRecord.uid, caseRecord.photos);
    List<String> videoLinks = await StorageService.updateCaseRecordVideos(
        caseRecord.uid, caseRecord.videos);
    List<String> thumbnails = await StorageService.updateCaseRecordThumbnails(
        caseRecord.uid, caseRecord.videos);

    caseRecord.videos = List.generate(videoLinks.length, (index) {
      String videoLink = videoLinks[index];
      String thumbnail = thumbnails[index];
      return Video.fromCase(videoLink, thumbnail);
    });

    caseRecord.audios = await StorageService.updateCaseRecordAudios(
        caseRecord.uid, caseRecord.audios);

    await caseCollection.doc(caseRecord.uid).update(caseRecord.toMap());
  }

  static Future<void> deleteCaseRecord(CaseRecord caseRecord) async {
    await StorageService.deleteCaseRefernces(caseRecord.uid);
    await caseCollection.doc(caseRecord.uid).delete();
  }

  static Future<void> addCaseView(
      String memberId, CaseRecord caseRecord) async {
    String caseId = caseRecord.uid;
    // Create a reference to the post and its views subcollection
    CollectionReference viewsRef =
        caseCollection.doc(caseId).collection('views');

    // Check if the user has already viewed the post
    DocumentSnapshot viewDoc = await viewsRef.doc(memberId).get();
    if (!viewDoc.exists) {
      // If the user hasn't viewed the post, add a document to the views subcollection
      await viewsRef.doc(memberId).set({'viewed': Timestamp.now()});

      // Optionally, update the post document to include the user's ID in the views array
      await caseCollection.doc(caseId).update({
        'views': FieldValue.arrayUnion([memberId])
      });
    }
  }

  static Future<void> addCaseRead(
      String memberId, CaseRecord caseRecord) async {
    String caseId = caseRecord.uid;
    // Create a reference to the post and its views subcollection
    CollectionReference readsRef =
        caseCollection.doc(caseId).collection('reads');

    // Check if the user has already viewed the post
    DocumentSnapshot viewDoc = await readsRef.doc(memberId).get();
    if (!viewDoc.exists) {
      // If the user hasn't viewed the post, add a document to the views subcollection
      await readsRef.doc(memberId).set({'read': Timestamp.now()});

      // Optionally, update the post document to include the user's ID in the views array
      await caseCollection.doc(caseId).update({
        'reads': FieldValue.arrayUnion([memberId])
      });
    }
  }

  Future<List<String>> getAllViewIds(String caseId) async {
    // Create a reference to the views subcollection
    CollectionReference viewsRef =
        caseCollection.doc(caseId).collection('views');

    // Retrieve all documents in the views subcollection
    QuerySnapshot querySnapshot = await viewsRef.get();

    // Extract the IDs from the documents and return them as a list
    return querySnapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<String>> getAllReadIds(String caseId) async {
    // Create a reference to the views subcollection
    CollectionReference viewsRef =
        caseCollection.doc(caseId).collection('reads');

    // Retrieve all documents in the views subcollection
    QuerySnapshot querySnapshot = await viewsRef.get();

    // Extract the IDs from the documents and return them as a list
    return querySnapshot.docs.map((doc) => doc.id).toList();
  }
}
