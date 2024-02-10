import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final _storageRef = FirebaseStorage.instance.ref();
  static final _profileImagesRef = _storageRef.child("profileImages");
  static final _mainImageCaseRef = _storageRef.child("mainImageCase");
  static final _photosCaseRef = _storageRef.child("photosCase");
  static final _videosCaseRef = _storageRef.child("videosCase");
  static final _audiosCaseRef = _storageRef.child("audiosCase");

  static Future<String> uploadProfileImage(String uid, File file) async {
    String fileName = uid;
    final imageRef = _profileImagesRef.child(fileName);
    await imageRef.putFile(file);
    return await imageRef.getDownloadURL();
  }

  static Future<String> uploadCaseRecordMainImage(
      String uidCase, String filePath) async {
    String fileName = '$uidCase mainImage';
    final mainImageRef = _mainImageCaseRef.child(fileName);
    await mainImageRef.putFile(File(filePath));
    return await mainImageRef.getDownloadURL();
  }

  static Future<List<String>> uploadCaseRecordPhotos(
      String uidCase, List<String> filePaths) async {
    List<String> photoLinks = List.empty(growable: true);
    for (int i = 0; i < filePaths.length; i++) {
      File file = File(filePaths[i]);
      String fileName = '$uidCase photo $i';
      final photoRef = _photosCaseRef.child(fileName);
      await photoRef.putFile(file);
      String photoLink = await photoRef.getDownloadURL();
      photoLinks.add(photoLink);
    }
    return photoLinks;
  }

  static Future<List<String>> uploadCaseRecordVideos(
      String uidCase, List<String> filePaths) async {
    List<String> videoLinks = List.empty(growable: true);
    for (int i = 0; i < filePaths.length; i++) {
      File file = File(filePaths[i]);
      String fileName = '$uidCase video $i';
      final videoRef = _videosCaseRef.child(fileName);
      await videoRef.putFile(file);
      String videoLink = await videoRef.getDownloadURL();
      videoLinks.add(videoLink);
    }
    return videoLinks;
  }

  static Future<List<String>> uploadCaseRecordAudios(
      String uidCase, List<String> filePaths) async {
    List<String> audioLinks = List.empty(growable: true);
    for (int i = 0; i < filePaths.length; i++) {
      File file = File(filePaths[i]);
      String fileName = '$uidCase audio $i';
      final audioRef = _audiosCaseRef.child(fileName);
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
