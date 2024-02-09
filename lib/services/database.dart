import 'package:case_be_heard/models/community_member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
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

  // brew list from snapshot
  // List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.documents.map((doc) {
  //     //print(doc.data);
  //     return Brew(
  //         name: doc.data['name'] ?? '',
  //         strength: doc.data['strength'] ?? 0,
  //         sugars: doc.data['sugars'] ?? '0');
  //   }).toList();
  // }

  // user data from snapshots
  CommunityMember _communityMemberFromSnapshot(DocumentSnapshot snapshot) {
    return CommunityMember.full(
      uid: uid,
      firstName: snapshot['firstName'],
      lastName: snapshot['lastName'],
      phoneNumber: snapshot['phoneNumber'],
      email: snapshot['email'],
      occupation: snapshot['occupation'],
      gender: snapshot['gender'],
      location: snapshot['location'],
      photoUrl: snapshot['photoUrl'],
      bio: snapshot['bio'],
    );
  }

  // get brews stream
  // Stream<List<Brew>> get brews {
  //   return brewCollection.snapshots().map(_brewListFromSnapshot);
  // }

  // get user doc stream
  Stream<CommunityMember> get member {
    return communityMemberCollection
        .doc(uid)
        .snapshots()
        .map(_communityMemberFromSnapshot);
  }
}
