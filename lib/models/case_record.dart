import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/models/video.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CaseRecord {
  String id = '';
  Timestamp dateCreated = Timestamp.now();
  String uidMember = '';
  String title = '', details = '', summary = '', type, progress, mainImage = '';
  CommunityMember member = CommunityMember.empty();
  GeoPoint location;
  List<String> photos, audios, links;
  List<Video> videos = [];
  List<String> viewIds = [], readIds = [];
  String communityId = '';
  int commentCount = 0;

  CaseRecord(
      {required this.id,
      required this.uidMember,
      required this.member,
      required this.commentCount,
      required this.communityId,
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
      required this.links,
      required this.viewIds,
      required this.readIds});
  CaseRecord.forUpload(
      {required this.uidMember,
      required this.communityId,
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
      {required this.id,
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
      'uidMember': uidMember,
      'communityId': communityId,
      'dateCreated': dateCreated,
      'title': title,
      'details': details,
      'summary': summary,
      'type': type,
      'progress': progress,
      'mainImage': mainImage,
      'location': location,
      'photos': photos,
      'videos': videos.map((video) => video.videoUrl),
      'thumbnails': videos.map((video) => video.thumbnailUrl),
      'audios': audios,
      'links': links,
      'viewIds': viewIds,
      'readIds': viewIds
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      'title': title,
      'details': details,
      'summary': summary,
      'type': type,
      'progress': progress,
      'mainImage': mainImage,
      'location': location,
      'photos': photos,
      'videos': videos.map((video) => video.videoUrl),
      'thumbnails': videos.map((video) => video.thumbnailUrl),
      'audios': audios,
      'links': links,
      'viewIds': viewIds,
      'readIds': viewIds
    };
  }
}
