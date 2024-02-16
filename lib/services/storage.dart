import 'dart:io';
import 'package:case_be_heard/models/video.dart';
import 'package:case_be_heard/shared/case_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static const Uuid uuid = Uuid();
  static final _storageRef = FirebaseStorage.instance.ref();
  static final _profileImagesRef = _storageRef.child("profileImages");
  static final _mainImageCaseRef = _storageRef.child("mainImageCase");
  static final _photosCaseRef = _storageRef.child("photosCase");
  static final _videosCaseRef = _storageRef.child("videosCase");
  static final _audiosCaseRef = _storageRef.child("audiosCase");
  static final _thumbnailsCaseRef = _storageRef.child("thumbnailsCase");

  static Future<String> uploadProfileImage(String uid, File file) async {
    final fileName = uid;
    final imageRef = _profileImagesRef.child(fileName);
    await imageRef.putFile(file);
    return await imageRef.getDownloadURL();
  }

  static Future<String> uploadCaseRecordMainImage(
      String uidCase, String filePath) async {
    final fileName = uidCase;
    final mainImageRef = _mainImageCaseRef.child(fileName);
    await mainImageRef.putFile(File(filePath));
    return await mainImageRef.getDownloadURL();
  }

  static Future<List<String>> uploadCaseRecordPhotos(
      String uidCase, List<String> filePaths) async {
    List<String> photoUrls = [];
    for (int i = 0; i < filePaths.length; i++) {
      final file = File(filePaths[i]);
      final fileName = uuid.v4();
      final photoRef = _photosCaseRef.child(uidCase).child(fileName);
      await photoRef.putFile(file);
      final photoUrl = await photoRef.getDownloadURL();
      photoUrls.add(photoUrl);
    }
    return photoUrls;
  }

  static Future<List<String>> uploadCaseRecordVideos(
      String uidCase, List<Video> videos) async {
    List<String> videoUrls = [];
    for (int i = 0; i < videos.length; i++) {
      final file = videos[i].file;
      final fileName = uuid.v4();
      final videoRef = _videosCaseRef.child(uidCase).child(fileName);
      await videoRef.putFile(file!);
      final videoUrl = await videoRef.getDownloadURL();
      videoUrls.add(videoUrl);
    }
    return videoUrls;
  }

  static Future<List<String>> uploadCaseRecordThumbnails(
      String uidCase, List<Video> videos) async {
    List<String> thumbnailUrls = [];
    for (int i = 0; i < videos.length; i++) {
      final path = videos[i].file!.path;
      final fileName = uuid.v4();
      final thumbnail = await CaseHelper.getThumbnail(path);
      final thumbnailRef = _thumbnailsCaseRef.child(uidCase).child(fileName);
      await thumbnailRef.putData(thumbnail!);
      final thumbnailUrl = await thumbnailRef.getDownloadURL();
      thumbnailUrls.add(thumbnailUrl);
    }
    return thumbnailUrls;
  }

  static Future<List<String>> uploadCaseRecordAudios(
      String uidCase, List<String> filePaths) async {
    List<String> audioLinks = List.empty(growable: true);
    for (int i = 0; i < filePaths.length; i++) {
      final file = File(filePaths[i]);
      final fileName = uuid.v4();
      final audioRef = _audiosCaseRef.child(uidCase).child(fileName);
      await audioRef.putFile(file);
      final videoLink = await audioRef.getDownloadURL();
      audioLinks.add(videoLink);
    }
    return audioLinks;
  }

  static Future<String> updateCaseRecordMainImage(
      String uidCase, String urlPath) async {
    if (urlPath.startsWith('http')) return urlPath;
    final fileName = uidCase;
    final mainImageRef = _mainImageCaseRef.child(fileName);
    await mainImageRef.putFile(File(urlPath));
    return await mainImageRef.getDownloadURL();
  }

  static Future<List<String>> updateCaseRecordPhotos(
      String uidCase, List<String> filePaths) async {
    final parent = _photosCaseRef.child(uidCase);
    final originalUrls = await getAllDownloadUrlsInReference(parent, uidCase);
    List<String> photoUrls = [];
    for (int i = 0; i < filePaths.length; i++) {
      final urlPath = filePaths[i];

      if (urlPath.startsWith('http')) {
        photoUrls.add(urlPath);
      } else {
        final file = File(urlPath);
        final fileName = uuid.v4();
        final photoRef = parent.child(fileName);
        await photoRef.putFile(file);
        final photoUrl = await photoRef.getDownloadURL();
        photoUrls.add(photoUrl);
      }
    }
    _deleteNotCurrentUrls(originalUrls, photoUrls, parent, uidCase);
    return photoUrls;
  }

  static Future<List<String>> updateCaseRecordVideos(
      String uidCase, List<Video> videos) async {
    final parent = _videosCaseRef.child(uidCase);
    final originalUrls = await getAllDownloadUrlsInReference(parent, uidCase);
    List<String> videoUrls = [];
    for (int i = 0; i < videos.length; i++) {
      final urlPath = videos[i].videoUrl ?? videos[i].file!.path;

      if (urlPath.startsWith('http')) {
        videoUrls.add(urlPath);
      } else {
        final file = videos[i].file;
        final fileName = uuid.v4();
        final videoRef = parent.child(fileName);
        await videoRef.putFile(file!);
        final videoUrl = await videoRef.getDownloadURL();
        videoUrls.add(videoUrl);
      }
    }
    _deleteNotCurrentUrls(originalUrls, videoUrls, parent, uidCase);
    return videoUrls;
  }

  static Future<List<String>> updateCaseRecordThumbnails(
      String uidCase, List<Video> videos) async {
    final parent = _thumbnailsCaseRef.child(uidCase);
    final originalUrls = await getAllDownloadUrlsInReference(parent, uidCase);
    List<String> thumbnailUrls = [];
    for (int i = 0; i < videos.length; i++) {
      final urlPath = videos[i].thumbnailUrl;

      if (urlPath != null && urlPath.startsWith('http')) {
        thumbnailUrls.add(urlPath);
      } else {
        final path = videos[i].file!.path;
        final fileName = uuid.v4();
        final thumbnail = await CaseHelper.getThumbnail(path);
        final thumbnailRef = parent.child(fileName);
        await thumbnailRef.putData(thumbnail!);
        final thumbnailUrl = await thumbnailRef.getDownloadURL();
        thumbnailUrls.add(thumbnailUrl);
      }
    }
    _deleteNotCurrentUrls(originalUrls, thumbnailUrls, parent, uidCase);
    return thumbnailUrls;
  }

  static Future<List<String>> updateCaseRecordAudios(
      String uidCase, List<String> filePaths) async {
    final parent = _audiosCaseRef.child(uidCase);
    final originalUrls = await getAllDownloadUrlsInReference(parent, uidCase);
    List<String> audioUrls = [];
    for (int i = 0; i < filePaths.length; i++) {
      final urlPath = filePaths[i];

      if (urlPath.startsWith('http')) {
        audioUrls.add(urlPath);
      } else {
        final file = File(filePaths[i]);
        final fileName = uuid.v4();
        final audioRef = parent.child(fileName);
        await audioRef.putFile(file);
        final videoUrl = await audioRef.getDownloadURL();
        audioUrls.add(videoUrl);
      }
    }
    _deleteNotCurrentUrls(originalUrls, audioUrls, parent, uidCase);
    return audioUrls;
  }

  static Future<List<String>> getAllDownloadUrlsInReference(
      Reference reference, String uidCase) async {
    final result = await reference.listAll();
    final files = result.items;
    final downloadUrls = <String>[];
    for (final file in files) {
      final url = await file.getDownloadURL();
      downloadUrls.add(url);
    }
    return downloadUrls;
  }

  static _deleteNotCurrentUrls(List<String> originalUrls,
      List<String> currentUrls, Reference reference, String uidCase) async {
    final notCurrentUrls =
        originalUrls.where((url) => !currentUrls.contains(url)).toList();
    for (var url in notCurrentUrls) {
      await reference.child(url).delete();
    }
  }

  static deleteCaseRefernces(String uidCase) async {
    List<Reference> parents = [
      _photosCaseRef,
      _videosCaseRef,
      _thumbnailsCaseRef,
      _audiosCaseRef
    ];

    await _mainImageCaseRef.child(uidCase).delete();
    for (final parent in parents) {
      final caseRef = parent.child(uidCase);
      try {
        await caseRef.delete();
      } on Exception {
        // some media files were not uploaded in the reference to delete
      }
    }
  }

  static Future<int?> getFileSizeFromFirebaseStorage(String downloadUrl) async {
    final storageRef = FirebaseStorage.instance.refFromURL(downloadUrl);
    final metadata = await storageRef.getMetadata();
    return metadata.size;
  }
}
