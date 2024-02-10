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

  static Future<String> uploadCaseRecordMainImage(
      String uidCase, File file) async {
    String fileName = '$uidCase mainImage';
    final mainImageRef = mainImageCaseRef.child(fileName);
    await mainImageRef.putFile(file);
    return await mainImageRef.getDownloadURL();
  }

  static Future<List<String>> uploadCaseRecordPhotos(
      String uidCase, List<File> files) async {
    List<String> photoLinks = List.empty(growable: true);
    for (int i = 0; i < files.length; i++) {
      File file = files[i];
      String fileName = '$uidCase photo $i';
      final photoRef = photosCaseRef.child(fileName);
      await photoRef.putFile(file);
      String photoLink = await photoRef.getDownloadURL();
      photoLinks.add(photoLink);
    }
    return photoLinks;
  }

  static Future<List<String>> uploadCaseRecordVideos(
      String uidCase, List<File> files) async {
    List<String> videoLinks = List.empty(growable: true);
    for (int i = 0; i < files.length; i++) {
      File file = files[i];
      String fileName = '$uidCase video $i';
      final videoRef = videosCaseRef.child(fileName);
      await videoRef.putFile(file);
      String videoLink = await videoRef.getDownloadURL();
      videoLinks.add(videoLink);
    }
    return videoLinks;
  }

  static Future<List<String>> uploadCaseRecordAudio(
      String uidCase, List<File> files) async {
    List<String> audioLinks = List.empty(growable: true);
    for (int i = 0; i < files.length; i++) {
      File file = files[i];
      String fileName = '$uidCase audio $i';
      final audioRef = audiosCaseRef.child(fileName);
      await audioRef.putFile(file);
      String videoLink = await audioRef.getDownloadURL();
      audioLinks.add(videoLink);
    }
    return audioLinks;
  }

  static deleteCaseRecordItems(
      Reference reference, String uidCaseRecord) async {
    ListResult result = await reference.listAll();
    for (Reference ref in result.items) {
      if (ref.fullPath.startsWith(uidCaseRecord)) {
        await ref.delete();
      }
    }
  }
}
