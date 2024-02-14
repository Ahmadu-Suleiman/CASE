import 'dart:io';
import 'dart:typed_data';
import 'package:case_be_heard/models/video.dart';
import 'package:case_be_heard/shared/case_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final _storageRef = FirebaseStorage.instance.ref();
  static final _profileImagesRef = _storageRef.child("profileImages");
  static final _mainImageCaseRef = _storageRef.child("mainImageCase");
  static final _photosCaseRef = _storageRef.child("photosCase");
  static final _videosCaseRef = _storageRef.child("videosCase");
  static final _audiosCaseRef = _storageRef.child("audiosCase");
  static final _thumbnailsCaseRef = _storageRef.child("thumbnailsCase");

  static Future<String> uploadProfileImage(String uid, File file) async {
    String fileName = uid;
    final imageRef = _profileImagesRef.child(fileName);
    await imageRef.putFile(file);
    return await imageRef.getDownloadURL();
  }

  static Future<String> uploadCaseRecordMainImage(
      String uidCase, String filePath) async {
    final fileName = '$uidCase mainImage';
    final mainImageRef = _mainImageCaseRef.child(fileName);
    await mainImageRef.putFile(File(filePath));
    return await mainImageRef.getDownloadURL();
  }

  static Future<List<String>> uploadCaseRecordPhotos(
      String uidCase, List<String> filePaths) async {
    List<String> photoLinks = List.empty(growable: true);
    for (int i = 0; i < filePaths.length; i++) {
      final file = File(filePaths[i]);
      final fileName = '$uidCase photo $i';
      final photoRef = _photosCaseRef.child(fileName);
      await photoRef.putFile(file);
      final photoLink = await photoRef.getDownloadURL();
      photoLinks.add(photoLink);
    }
    return photoLinks;
  }

  static Future<List<String>> uploadCaseRecordVideos(
      String uidCase, List<Video> videos) async {
    List<String> videoLinks = List.empty(growable: true);
    for (int i = 0; i < videos.length; i++) {
      final file = videos[i].file;
      final fileName = '$uidCase video $i';
      final videoRef = _videosCaseRef.child(fileName);
      await videoRef.putFile(file!);
      String videoLink = await videoRef.getDownloadURL();
      videoLinks.add(videoLink);
    }
    return videoLinks;
  }

  static Future<List<String>> uploadCaseRecordThumbnails(
      String uidCase, List<Video> videos) async {
    List<String> thumbnailLinks = List.empty(growable: true);
    for (int i = 0; i < videos.length; i++) {
      final path = videos[i].file!.path;
      final fileName = '$uidCase thumbnail $i';
      Uint8List? thumbnail = await CaseHelper.getThumbnail(path);
      final thumbnailRef = _thumbnailsCaseRef.child(fileName);
      await thumbnailRef.putData(thumbnail!);
      final thumbnailLink = await thumbnailRef.getDownloadURL();
      thumbnailLinks.add(thumbnailLink);
    }
    return thumbnailLinks;
  }

  static Future<List<String>> uploadCaseRecordAudios(
      String uidCase, List<String> filePaths) async {
    List<String> audioLinks = List.empty(growable: true);
    for (int i = 0; i < filePaths.length; i++) {
      final file = File(filePaths[i]);
      final fileName = '$uidCase audio $i';
      final audioRef = _audiosCaseRef.child(fileName);
      await audioRef.putFile(file);
      final videoLink = await audioRef.getDownloadURL();
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

  static Future<int?> getFileSizeFromFirebaseStorage(String downloadUrl) async {
    final storageRef = FirebaseStorage.instance.refFromURL(downloadUrl);
    final metadata = await storageRef.getMetadata();
    return metadata.size;
  }
}
