import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:case_be_heard/services/storage.dart';
import 'package:case_be_heard/shared/case_helper.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseCase {
  // collection reference
  static final CollectionReference caseCollection =
      FirebaseFirestore.instance.collection('caseRecords');

  static Future<CaseRecord> _caseRecordFromSnapshot(
      DocumentSnapshot snapshot) async {
    CommunityMember member =
        await DatabaseMember(uid: snapshot['uidMember']).getCommunityMember();
    return CaseRecord(
      uid: snapshot['uid'] ?? '',
      uidMember: snapshot['uidMember'] ?? '',
      dateCreated: snapshot['dateCreated'] ?? Timestamp.now(),
      member: member,
      title: snapshot['title'] ?? '',
      shortDescription: snapshot['shortDescription'] ?? '',
      detailedDescription: snapshot['detailedDescription'] ?? '',
      type: snapshot['type'] ?? '',
      progress: snapshot['progress'] ?? '',
      mainImage: snapshot['mainImage'] ?? '',
      location: Utility.stringList(snapshot, 'photos'),
      photos: Utility.stringList(snapshot, 'photos'),
      videos: Utility.stringList(snapshot, 'videos'),
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

  static Future<List<CaseRecord>> getAllCaseRecords() async {
    // Fetch all documents from the collection
    QuerySnapshot querySnapshot = await caseCollection.get();
    // Convert each document to a CaseRecord and wait for all futures to complete

    List<Future<CaseRecord>> caseRecordFutures =
        querySnapshot.docs.map(_caseRecordFromSnapshot).toList();
    return await Future.wait(caseRecordFutures);
  }

  static Future<void> uploadCaseRecord(CaseRecord caseRecord) async {
    caseRecord.mainImage = await StorageService.uploadCaseRecordMainImage(
        caseRecord.uid, caseRecord.mainImage);
    caseRecord.photos = await StorageService.uploadCaseRecordPhotos(
        caseRecord.uid, caseRecord.photos);
    caseRecord.videos = await StorageService.uploadCaseRecordVideos(
        caseRecord.uid, caseRecord.videos);
    caseRecord.audios = await StorageService.uploadCaseRecordAudios(
        caseRecord.uid, caseRecord.audios);

    await caseCollection.doc(caseRecord.uid).set(caseRecord.toMap());
  }

  static Future<CaseRecordAndThumbnails> getCaseRecordAndThumbnails(
      String uidCase) async {
    CaseRecord caseRecord = await getCaseRecord(uidCase);
    List<Uint8List?> thumbnails = List.empty(growable: true);
    for (int i = 0; i < caseRecord.videos.length; i++) {
      thumbnails[i] = await CaseHelper.getThumbnail(caseRecord.videos[i]);
    }
    return CaseRecordAndThumbnails(
        caseRecord: caseRecord, thumbnails: thumbnails);
  }
}
