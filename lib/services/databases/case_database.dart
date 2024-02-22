import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/models/video.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:case_be_heard/services/storage.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:quiver/iterables.dart';

class DatabaseCase {
  // collection reference
  static final CollectionReference caseCollection =
      FirebaseFirestore.instance.collection('caseRecords');

  static Future<CaseRecord> _caseRecordFromSnapshot(
      DocumentSnapshot snapshot) async {
    String uid = snapshot['uidMember'];
    CommunityMember member = await DatabaseMember.getCommunityMember(uid);
    List<String> videoLinks = Utility.stringList(snapshot, 'videos');
    List<String> thumbnails = Utility.stringList(snapshot, 'thumbnails');
    List<Video> videos = List.generate(videoLinks.length, (index) {
      String videoLink = videoLinks[index];
      String thumbnail = thumbnails[index];
      return Video.fromCase(videoLink, thumbnail);
    });

    return CaseRecord(
        id: snapshot.id,
        uidMember: snapshot['uidMember'] ?? '',
        dateCreated: snapshot['dateCreated'] ?? Timestamp.now(),
        member: member,
        communityId: snapshot['communityId'] ?? '',
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
        viewIds: Utility.stringList(snapshot, 'viewIds'),
        readIds: Utility.stringList(snapshot, 'readIds'));
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

  static Future<List<CaseRecord>> getCaseRecordsByIds(List<String> ids) async {
    List<CaseRecord> caseRecords = [];

    List<List<String>> chunks = partition(ids, 10).toList();

    for (var chunk in chunks) {
      QuerySnapshot querySnapshot = await caseCollection
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      List<CaseRecord> caseRecordsFromFuture = await Future.wait(querySnapshot
          .docs
          .map((doc) => _caseRecordFromSnapshot(doc))
          .toList());

      caseRecords.addAll(caseRecordsFromFuture);
    }
    return caseRecords;
  }

  static Future<void> fetchCaseRecords(
      {int limit = 10,
      DocumentSnapshot? pageKey,
      required PagingController pagingController,
      String? progress,
      String? memberId,
      String? communityId,
      List<String>? communityIds}) async {
    QuerySnapshot querySnapshot;
    Query query = caseCollection.orderBy('dateCreated', descending: true);

    if (progress != null) {
      query = query.where('progress', isEqualTo: progress);
    }
    if (memberId != null) {
      query = query.where('uidMember', isEqualTo: memberId);
    }
    if (communityId != null) {
      query = query.where('communityId', isEqualTo: communityId);
    }
    if (communityIds != null && communityIds.isNotEmpty) {
      for (var communityId in communityIds) {
        query = query.where('communityIds', arrayContains: communityId);
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

    _handleQuerySnapshot(querySnapshot.docs, pagingController, limit);
  }

  static void _handleQuerySnapshot(List<QueryDocumentSnapshot> docs,
      PagingController pagingController, int limit) async {
    if (docs.isNotEmpty) {
      List<Future<CaseRecord>> caseRecordFutures =
          docs.map(_caseRecordFromSnapshot).toList();
      final caseRecordList = await Future.wait(caseRecordFutures);
      final bool isLastPage = caseRecordList.length < limit;
      final DocumentSnapshot? lastDoc = isLastPage ? null : docs.last;

      if (isLastPage) {
        pagingController.appendLastPage(caseRecordList);
      } else {
        pagingController.appendPage(caseRecordList, lastDoc);
      }
    } else {
      pagingController.appendLastPage(<CaseRecord>[]);
    }
  }

  static Future<void> uploadCaseRecord(CaseRecord caseRecord) async {
    DocumentReference caseRef = await caseCollection.add(<String, dynamic>{});
    String id = caseRef.id;

    caseRecord.dateCreated = Timestamp.now();
    caseRecord.viewIds = [];
    caseRecord.readIds = [];
    caseRecord.mainImage = await StorageService.uploadCaseRecordMainImage(
        id, caseRecord.mainImage);
    caseRecord.photos =
        await StorageService.uploadCaseRecordPhotos(id, caseRecord.photos);
    List<String> videoLinks =
        await StorageService.uploadCaseRecordVideos(id, caseRecord.videos);
    List<String> thumbnails =
        await StorageService.uploadCaseRecordThumbnails(id, caseRecord.videos);

    caseRecord.videos = List.generate(videoLinks.length, (index) {
      String videoLink = videoLinks[index];
      String thumbnail = thumbnails[index];
      return Video.fromCase(videoLink, thumbnail);
    });

    caseRecord.audios =
        await StorageService.uploadCaseRecordAudios(id, caseRecord.audios);

    await caseCollection.doc(id).set(caseRecord.toMap());
  }

  static Future<void> updateCaseRecord(CaseRecord caseRecord) async {
    caseRecord.mainImage = await StorageService.updateCaseRecordMainImage(
        caseRecord.id, caseRecord.mainImage);
    caseRecord.photos = await StorageService.updateCaseRecordPhotos(
        caseRecord.id, caseRecord.photos);
    List<String> videoLinks = await StorageService.updateCaseRecordVideos(
        caseRecord.id, caseRecord.videos);
    List<String> thumbnails = await StorageService.updateCaseRecordThumbnails(
        caseRecord.id, caseRecord.videos);

    caseRecord.videos = List.generate(videoLinks.length, (index) {
      String videoLink = videoLinks[index];
      String thumbnail = thumbnails[index];
      return Video.fromCase(videoLink, thumbnail);
    });

    caseRecord.audios = await StorageService.updateCaseRecordAudios(
        caseRecord.id, caseRecord.audios);

    await caseCollection.doc(caseRecord.id).update(caseRecord.toMap());
  }

  static Future<void> deleteCaseRecord(CaseRecord caseRecord) async {
    await StorageService.deleteCaseRefernces(caseRecord.id);
    await caseCollection.doc(caseRecord.id).delete();
  }

  static Future<void> addCaseView(
      String memberId, CaseRecord caseRecord) async {
    String caseId = caseRecord.id;
    await caseCollection.doc(caseId).update({
      'viewIds': FieldValue.arrayUnion([memberId])
    });
  }

  static Future<void> addCaseRead(
      String memberId, CaseRecord caseRecord) async {
    String caseId = caseRecord.id;
    await caseCollection.doc(caseId).update({
      'readIds': FieldValue.arrayUnion([memberId])
    });
  }
}
