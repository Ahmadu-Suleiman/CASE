import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

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
  List<String> bookmarkCaseIds = [];
  List<String> bookmarkPetitionIds = [];
  List<String> communityIds = [];
  late GeoPoint location;
  late Placemark placemark;
  late String address;

  CommunityMember.empty();
  CommunityMember({required this.id});
  CommunityMember.login({required this.id, required this.email});
  CommunityMember.fromGoogle({
    required this.id,
    required this.firstName,
    required this.email,
    required this.phoneNumber,
    required this.photoUrl,
  });
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
      required this.bookmarkPetitionIds,
      required this.communityIds,
      required this.placemark,
      required this.address,
      verified});

  CommunityMember copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? occupation,
    GeoPoint? location,
    String? gender,
    String? photoUrl,
    String? bio,
    bool? verified,
    String? defaultStateCommunityId,
    List<String>? bookmarkCaseIds,
    List<String>? bookmarkPetitionIds,
    List<String>? communityIds,
    Placemark? placemark,
    String? address,
  }) {
    return CommunityMember.full(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      occupation: occupation ?? this.occupation,
      location: location ?? this.location,
      gender: gender ?? this.gender,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      verified: verified ?? this.verified,
      placemark: placemark ?? this.placemark,
      address: address ?? this.address,
      bookmarkCaseIds: bookmarkCaseIds ?? List.from(this.bookmarkCaseIds),
      bookmarkPetitionIds:
          bookmarkPetitionIds ?? List.from(this.bookmarkPetitionIds),
      communityIds: communityIds ?? List.from(this.communityIds),
    );
  }
}
