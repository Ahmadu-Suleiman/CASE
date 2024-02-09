import 'package:case_be_heard/models/case.dart';

class CommunityMember {
  String? uid;
  String firstName = '';
  String lastName = '';
  String email = '';
  String phoneNumber = '';
  String occupation = '';
  List<String> location = [];
  String gender = '';
  String? photoUrl;
  String bio = '';
  List<Case> cases = [];

  CommunityMember({required this.uid});
  CommunityMember.empty();
  CommunityMember.full({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.occupation,
    required this.location,
    required this.gender,
    required this.photoUrl,
    required this.bio,
  });
}
