import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/models/video.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class CaseRecord {
  late String uid;
  late Timestamp dateCreated;
  String uidMember;
  String title = '', details = '', summary = '', type, progress, mainImage = '';
  late List<String> views, reads;
  late CommunityMember member;
  late GeoPoint location;
  late List<String> photos, audios, links;
  late List<Video> videos;

  CaseRecord(
      {required this.uid,
      required this.uidMember,
      required this.member,
      required this.dateCreated,
      required this.title,
      required this.details,
      required this.summary,
      required this.type,
      required this.progress,
      required this.views,
      required this.reads,
      required this.mainImage,
      required this.location,
      required this.photos,
      required this.videos,
      required this.audios,
      required this.links});
  CaseRecord.forUpload(
      {required this.uidMember,
      required this.dateCreated,
      required this.title,
      required this.details,
      required this.summary,
      required this.type,
      required this.progress,
      required this.mainImage,
      required this.location,
      required this.photos,
      required this.videos,
      required this.audios,
      required this.links});
  CaseRecord.forUpdate(
      {required this.uid,
      required this.uidMember,
      required this.title,
      required this.details,
      required this.summary,
      required this.type,
      required this.progress,
      required this.mainImage,
      required this.location,
      required this.photos,
      required this.videos,
      required this.audios,
      required this.links});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'uidMember': uidMember,
      'dateCreated': dateCreated,
      'title': title,
      'details': details,
      'summary': summary,
      'type': type,
      'progress': progress,
      'views': views,
      'reads': reads,
      'mainImage': mainImage,
      'location': location,
      'photos': photos,
      'videos': videos.map((video) => video.videoUrl),
      'thumbnails': videos.map((video) => video.thumbnailUrl),
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
