import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:case_be_heard/services/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class Utility {
  static late BuildContext _storedContext;
  static final ImagePicker _picker = ImagePicker();

  static Future<bool> checkPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      var result = await Permission.storage.request();
      return result.isGranted;
    } else {
      return true;
    }
  }

  static void openLink(BuildContext context, String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      // ignore: use_build_context_synchronously
      showSnackBar(_storedContext, 'Could not open link');
    }
  }

  static void showSnackBar(BuildContext context, String text) {
    _storedContext = context;
    if (_storedContext.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text),
        ),
      );
    }
  }

  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute;
    } catch (e) {
      return false;
    }
  }

  static getProfileImage(String photoUrl, double size) {
    return CachedNetworkImage(
      imageUrl: photoUrl,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        backgroundImage: imageProvider,
        radius: size,
      ),
      placeholder: (context, url) => const Icon(Icons.person),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  static getFirstAndlastNam(CommunityMember member) =>
      '${member.firstName} ${member.lastName}';

  static Future<String?> pickandUpdateProfileImage(
      CommunityMember member) async {
    XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);
    String? uid = member.uid;
    if (imageFile != null && uid != null) {
      String link =
          await StorageService.uploadProfileImage(uid, File(imageFile.path));
      member.photoUrl = link;
      await DatabaseMember(uid: member.uid).updateCommunityMemberData(member);
      return link;
    }
    return null;
  }

  static List<String> stringList(DocumentSnapshot snapshot, String field) =>
      snapshot[field]?.whereType<String>().toList() ?? [];
}
