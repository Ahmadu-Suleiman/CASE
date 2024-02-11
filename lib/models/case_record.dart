import 'package:case_be_heard/models/community_member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class CaseRecord {
  String uid = generateCaseId();
  String dateCreated = FieldValue.serverTimestamp().toString();
  String uidMember;
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
      required this.dateCreated,
      required this.title,
      required this.shortDescription,
      required this.detailedDescription,
      required this.type,
      required this.progress,
      required this.mainImage,
      required this.location,
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
      required this.location,
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

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'uidMember': uidMember,
      'dateCreated': dateCreated,
      'title': title,
      'shortDescription': shortDescription,
      'detailedDescription': detailedDescription,
      'type': type,
      'progress': progress,
      'mainImage': mainImage,
      'location': location,
      'photos': photos,
      'videos': videos,
      'audios': audios,
      'links': links,
    };
  }

  static String generateCaseId() {
    DateTime now = DateTime.now();
    String timestamp = DateFormat('yyyyMMddHHmmss').format(now);

    String randomStr = const Uuid().v4();
    return '$timestamp-$randomStr';
  }
}

class CaseRecordAndThumbnails {
  CaseRecord caseRecord;
  List<Uint8List?> thumbnails;

  CaseRecordAndThumbnails({required this.caseRecord, required this.thumbnails});
}
