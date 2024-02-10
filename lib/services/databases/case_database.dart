import 'package:case_be_heard/models/community_member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference communityMemberCollection =
      FirebaseFirestore.instance.collection('communityMembers');

  Future<void> updateCommunityMemberData(CommunityMember member) async {
    return await communityMemberCollection.doc(uid).set({
      'firstName': member.firstName,
      'lastName': member.lastName,
      'email': member.email,
      'phoneNumber': member.phoneNumber,
      'occupation': member.occupation,
      'location': member.location,
      'gender': member.gender,
      'bio': member.bio,
      'photoUrl': member.photoUrl,
    });
  }

  CommunityMember _communityMemberFromSnapshot(DocumentSnapshot snapshot) {
    List<String> locationList = [];
    if (snapshot['location'] is List<dynamic>) {
      locationList = List<String>.from(snapshot['location'].cast<String>());
    }
    return CommunityMember.full(
      uid: uid,
      firstName: snapshot['firstName'] ?? '',
      lastName: snapshot['lastName'] ?? '',
      email: snapshot['email'] ?? '',
      phoneNumber: snapshot['phoneNumber'] ?? '',
      occupation: snapshot['occupation'] ?? '',
      location: locationList,
      gender: snapshot['gender'] ?? '',
      photoUrl: snapshot['photoUrl'] ?? '',
      bio: snapshot['bio'] ?? '',
    );
  }

  Stream<List<CommunityMember?>> get communityMembers {
    return communityMemberCollection.snapshots().map((snapshots) {
      return snapshots.docs.map(_communityMemberFromSnapshot).toList();
    });
  }

  Stream<CommunityMember?>? get member {
    return uid != null
        ? communityMemberCollection
            .doc(uid)
            .snapshots()
            .map(_communityMemberFromSnapshot)
        : null;
  }
}