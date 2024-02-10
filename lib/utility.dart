import 'dart:io';

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
  static const defaultImage = AssetImage('assets/profile.png');

  static List<String> texts = [
    'John Doe went missing three days ago. If you have any information or have seen him, please contact the nearest police station immediately.',
    'John Doe went missing three days ago. If you have any information or have seen him, please contact the nearest police station immediately.',
    'John Doe went missing three days ago. If you have any information or have seen him, please contact the nearest police station immediately.',
    'John Doe went missing three days ago. If you have any information or have seen him, please contact the nearest police station immediately.',
    'John Doe went missing three days ago. If you have any information or have seen him, please contact the nearest police station immediately.',
    'John Doe went missing three days ago. If you have any information or have seen him, please contact the nearest police station immediately.',
    'John Doe went missing three days ago. If you have any information or have seen him, please contact the nearest police station immediately.',
  ];

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
    _storedContext = context;
    if (!await launchUrl(Uri.parse(url))) {
      // ignore: use_build_context_synchronously
      showSnackBar(_storedContext, 'Could not open link');
    }
  }

  static void showSnackBar(BuildContext context, String text) {
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

  static getProfileImage(String? photoUrl) {
    return photoUrl != null
        ? NetworkImage(photoUrl)
        : const AssetImage('assets/profile.png');
  }

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

  static List<String> stringList(dynamic input) {
    if (input is List<dynamic>) {
      return input.cast<String>();
    } else {
      return [];
    }
  }
}
