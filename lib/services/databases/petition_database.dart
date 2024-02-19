import 'package:case_be_heard/models/petition.dart';
import 'package:case_be_heard/services/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabasePetition {
  static final CollectionReference petitionCollection =
      FirebaseFirestore.instance.collection('petitions');

  static Future<Petition> _petitionFromSnapshot(
      DocumentSnapshot snapshot) async {
    return Petition.fromMap(
        snapshot.data() as Map<String, dynamic>, snapshot.id);
  }

  static Stream<List<Petition>> get petitions {
    return petitionCollection.snapshots().asyncMap((snapshots) async {
      List<Future<Petition>> petitionFutures =
          snapshots.docs.map(_petitionFromSnapshot).toList();
      return await Future.wait(petitionFutures);
    });
  }

  static Future<Petition> getPetition(String uidPetition) async {
    DocumentSnapshot docSnapshot =
        await petitionCollection.doc(uidPetition).get();
    return await _petitionFromSnapshot(docSnapshot);
  }

  static Future<void> uploadPetition(Petition petition) async {
    petition.image =
        await StorageService.uploadPetitionImage(petition.id, petition.image);
    await petitionCollection.add(petition.toMap());
  }

  static Future<void> updatePetition(Petition petition) async {
    petition.image =
        await StorageService.updatePetitionImage(petition.id, petition.image);
    await petitionCollection.doc(petition.id).update(petition.toMap());
  }

  static Future<void> deletePetition(Petition petition) async {
    await StorageService.deleteImagePetition(petition.id);
    await petitionCollection.doc(petition.id).delete();
  }
}
