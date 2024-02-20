import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityMember {
  String? id;
  String firstName = '';
  String lastName = '';
  String email = '';
  String phoneNumber = '';
  String occupation = '';
  String gender = '';
  String photoUrl = '';
  String bio = '';
  bool verified = false;
  late GeoPoint location;
  List<String> bookmarkCaseIds = [];
  List<String> bookmarkPetitionIds = [];

  CommunityMember.empty();
  CommunityMember({required this.id});
  CommunityMember.full(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phoneNumber,
      required this.occupation,
      required this.location,
      required this.gender,
      required this.photoUrl,
      required this.bio,
      required this.bookmarkCaseIds,
      required this.bookmarkPetitionIds});
}
