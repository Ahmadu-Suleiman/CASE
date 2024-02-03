import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class Utility {
  static late BuildContext storedContext;
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
    storedContext = context;
    if (!await launchUrl(Uri.parse(url))) {
      if (storedContext.mounted) {
        ScaffoldMessenger.of(storedContext).showSnackBar(
          const SnackBar(
            content: Text("Could not open link"),
          ),
        );
      }
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
}
