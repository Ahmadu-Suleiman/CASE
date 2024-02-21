import 'package:cloud_firestore/cloud_firestore.dart';

class Petition {
  late String id;
  String title;
  String description;
  String image;
  List<String> signatoryIds;
  int target;
  String memberId;
  String category;
  Timestamp dateCreated;
  late String communityId;

  Petition({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.signatoryIds,
    required this.target,
    required this.memberId,
    required this.category,
    required this.dateCreated,
    required this.communityId,
  });

  Petition.forUpload({
    required this.title,
    required this.description,
    required this.image,
    required this.signatoryIds,
    required this.target,
    required this.memberId,
    required this.category,
    required this.dateCreated,
    required this.communityId,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'signatoryIds': signatoryIds,
      'memberId': memberId,
      'dateCreated': dateCreated,
      'target': target,
      'category': category,
      'communityId': communityId,
    };
  }

  static Petition fromMap(Map<String, dynamic> map, String id) {
    return Petition(
      id: id,
      title: map['title'],
      description: map['description'],
      image: map['image'],
      signatoryIds: map['signatoryIds'].cast<String>(),
      target: map['target'],
      memberId: map['memberId'],
      dateCreated: map['dateCreated'],
      category: map['category'],
      communityId: map['communityId'],
    );
  }
}
