import 'dart:io';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:case_be_heard/services/storage.dart';
import 'package:case_be_heard/shared/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class Utility {
  static final ImagePicker _picker = ImagePicker();

  static Future<void> addMainImage(Function(String) updateMainImage) async {
    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) updateMainImage(image.path);
  }

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
      if (context.mounted) {
        showSnackBar(context, 'Could not open link');
      }
    }
  }

  static void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 1),
        backgroundColor: Style.primaryColor));
  }

  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute;
    } catch (e) {
      return false;
    }
  }

  static getFirstAndlastName(CommunityMember member) =>
      '${member.firstName} ${member.lastName}';

  static Future<String?> pickandUpdateProfileImage(
      BuildContext context, CommunityMember member) async {
    XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);
    String? uid = member.id;
    if (imageFile != null && uid != null && context.mounted) {
      showSnackBar(context, 'Updating profile image');
      String link =
          await StorageService.uploadProfileImage(uid, File(imageFile.path));
      member.photoUrl = link;
      await DatabaseMember.updateCommunityMemberData(member);
      return link;
    }
    return null;
  }

  static List<String> stringList(DocumentSnapshot snapshot, String field) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    // Check if the data is not null and contains the field
    if (data != null && data.containsKey(field) && data[field] is List) {
      // The field exists and is a list, you can safely filter its elements
      var fieldValue = data[field] as List;
      return fieldValue.whereType<String>().toList();
    }
    // If the snapshot does not exist, the data is null, or the field is not a list, return an empty list
    return [];
  }
}
