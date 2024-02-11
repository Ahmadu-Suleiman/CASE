import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/services/storage.dart';
import 'package:case_be_heard/shared/case_helper.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseCase {
  // collection reference
  static final CollectionReference caseCollection =
      FirebaseFirestore.instance.collection('caseRecords');

  static Future<DocumentReference> _uploadCaseInit(
      CaseRecord caseRecord, String uidMember) async {
    return await caseCollection.add({
      'uidMember': uidMember,
      'title': caseRecord.title,
      'shortDescription': caseRecord.shortDescription,
      'detailedDescription': caseRecord.detailedDescription,
      'dateCreated': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> _updateCase(
      CaseRecord caseRecord, String uidCase, String uidMember) async {
    return await caseCollection.doc(uidCase).set({
      'uidMember': uidMember,
      'title': caseRecord.title,
      'shortDescription': caseRecord.shortDescription,
      'detailedDescription': caseRecord.detailedDescription,
      'mainImage': caseRecord.mainImage,
      'photos': caseRecord.photos,
      'videos': caseRecord.videos,
      'audios': caseRecord.audios,
      'links': caseRecord.links,
    });
  }

  static CaseRecord _caseRecordFromSnapshot(DocumentSnapshot snapshot) {
    return CaseRecord(
      uidMember: snapshot['uidMember'],
      title: snapshot['title'],
      shortDescription: snapshot['shortDescription'],
      detailedDescription: snapshot['detailedDescription'],
      mainImage: snapshot['mainImage'],
      photos: Utility.stringList(snapshot, 'photos'),
      videos: Utility.stringList(snapshot, 'videos'),
      audios: Utility.stringList(snapshot, 'audios'),
      links: Utility.stringList(snapshot, 'links'),
    );
  }

  static Stream<List<CaseRecord?>> get caseRecords {
    return caseCollection.snapshots().map((snapshots) {
      return snapshots.docs.map(_caseRecordFromSnapshot).toList();
    });
  }

  static Stream<List<CaseRecord?>> caseRecordsMember(String uidMember) {
    return caseCollection
        .where('uidMember', isEqualTo: uidMember)
        .snapshots()
        .map((snapshots) {
      return snapshots.docs.map(_caseRecordFromSnapshot).toList();
    });
  }

  static Future<CaseRecord> getCaseRecord(String uidCase) async {
    return _caseRecordFromSnapshot(await caseCollection.doc(uidCase).get());
  }

  static Future<void> uploadCaseRecord(
      CaseRecord caseRecord, String uidMember) async {
    DocumentReference caseRef = await _uploadCaseInit(caseRecord, uidMember);
    caseRecord.mainImage = await StorageService.uploadCaseRecordMainImage(
        caseRef.id, caseRecord.mainImage);
    caseRecord.photos = await StorageService.uploadCaseRecordPhotos(
        caseRef.id, caseRecord.photos);
    caseRecord.videos = await StorageService.uploadCaseRecordVideos(
        caseRef.id, caseRecord.videos);
    caseRecord.audios = await StorageService.uploadCaseRecordAudios(
        caseRef.id, caseRecord.audios);

    return await _updateCase(caseRecord, caseRef.id, uidMember);
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
