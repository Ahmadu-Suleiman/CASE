import 'package:case_be_heard/models/case.dart';
import 'package:case_be_heard/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseCase {
  // collection reference
  static final CollectionReference caseCollection =
      FirebaseFirestore.instance.collection('caseRecords');

  static Future<DocumentReference> createCase(
      CaseRecord caseRecord, String uidMember) async {
    return await caseCollection.add({
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

  static CaseRecord _caseRecordsFromSnapshot(DocumentSnapshot snapshot) {
    return CaseRecord(
      uidMember: snapshot['uidMember'],
      title: snapshot['title'],
      shortDescription: snapshot['shortDescription'],
      detailedDescription: snapshot['detailedDescription'],
      mainImage: snapshot['mainImage'],
      photos: Utility.stringList(snapshot['photos']),
      videos: Utility.stringList(snapshot['videos']),
      audios: Utility.stringList(snapshot['audios']),
      links: Utility.stringList(snapshot['links']),
    );
  }

  static Stream<List<CaseRecord?>> get caseRecords {
    return caseCollection.snapshots().map((snapshots) {
      return snapshots.docs.map(_caseRecordsFromSnapshot).toList();
    });
  }

  static Stream<List<CaseRecord?>> caseRecordsMember(String uidMember) {
    return caseCollection
        .where('uidMember', isEqualTo: uidMember)
        .snapshots()
        .map((snapshots) {
      return snapshots.docs.map(_caseRecordsFromSnapshot).toList();
    });
  }
}
