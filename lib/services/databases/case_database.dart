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

  static Future<void> uploadCaseRecord(CaseRecord caseRecord) async {
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

    await caseCollection.doc(caseRecord.uid).set(caseRecord.toMap());
  }

  static Future<void> fetchCaseRecords(
      {int limit = 10,
      DocumentSnapshot? pageKey,
      required PagingController pagingController}) async {
    QuerySnapshot querySnapshot;
    if (pageKey != null) {
      querySnapshot = await caseCollection
          .orderBy('dateCreated', descending: true)
          .startAfterDocument(pageKey)
          .limit(limit)
          .get();
    } else {
      querySnapshot = await caseCollection
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
}
