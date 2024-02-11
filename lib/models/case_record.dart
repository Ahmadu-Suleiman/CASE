import 'package:case_be_heard/models/community_member.dart';
import 'package:flutter/foundation.dart';

class CaseRecord {
  late String dateCreated, uid, uidMember;
  String title,
      shortDescription,
      detailedDescription,
      type,
      progress,
      mainImage = '';
  late CommunityMember member;
  late List<String> location, photos, videos, audios, links = [];

  CaseRecord(
      {required this.uid,
      required this.uidMember,
      required this.member,
      required this.title,
      required this.shortDescription,
      required this.detailedDescription,
      required this.type,
      required this.progress,
      required this.mainImage,
      required this.photos,
      required this.videos,
      required this.audios,
      required this.links});
  CaseRecord.forUpload(
      {required this.uidMember,
      required this.title,
      required this.shortDescription,
      required this.detailedDescription,
      required this.type,
      required this.progress,
      required this.mainImage,
      required this.photos,
      required this.videos,
      required this.audios,
      required this.links});
  CaseRecord.init({
    required this.uidMember,
    required this.title,
    required this.shortDescription,
    required this.detailedDescription,
    required this.type,
    required this.progress,
  });
}

class CaseRecordAndThumbnails {
  CaseRecord caseRecord;
  List<Uint8List?> thumbnails;

  CaseRecordAndThumbnails({required this.caseRecord, required this.thumbnails});
}
