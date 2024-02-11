import 'package:flutter/foundation.dart';

class CaseRecord {
  late String dateCreated;
  String uidMember,
      title,
      shortDescription,
      detailedDescription,
      mainImage = '';
  late List<String> location, photos, videos, audios, links = [];

  CaseRecord(
      {required this.uidMember,
      required this.title,
      required this.shortDescription,
      required this.detailedDescription,
      required this.mainImage,
      required this.photos,
      required this.videos,
      required this.audios,
      required this.links});
  CaseRecord.init(
      {required this.uidMember,
      required this.title,
      required this.shortDescription,
      required this.detailedDescription});
}

class CaseRecordAndThumbnails {
  CaseRecord caseRecord;
  List<Uint8List?> thumbnails;

  CaseRecordAndThumbnails({required this.caseRecord, required this.thumbnails});
}
