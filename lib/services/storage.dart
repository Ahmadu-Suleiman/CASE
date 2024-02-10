import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final storage = FirebaseStorage.instance;
  static var storageRef = FirebaseStorage.instance.ref();
  static final profileImagesRef = storageRef.child("profileImages");
  static final mainImageCaseRef = storageRef.child("mainImageCase");
  static final photosCaseRef = storageRef.child("photosCase");
  static final videosCaseRef = storageRef.child("videosCase");
  static final audiosCaseRef = storageRef.child("audiosCase");

  static Future<String> uploadProfileImage(String uid, File file) async {
    String fileName = uid;
    final imageRef = profileImagesRef.child(fileName);
    await imageRef.putFile(file);
    return await imageRef.getDownloadURL();
  }
}
