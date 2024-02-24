import 'package:flutter/material.dart';

class Style {
  static Color primaryColor = const Color(0xFFF4B360);
  static Color secondaryColor = const Color(0xFFE7E7E7);

  static Color colorDarker = const Color(0xFF111F28);
  static Color colorDark = const Color(0xFF1A3140);

  static final textInputDecoration = InputDecoration(
      contentPadding: const EdgeInsets.all(12.0),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Colors.black, width: 1.0)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: primaryColor, width: 1.0)));

  static final buttonDecoration = ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(14.0),
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)));
  static final buttonGoogleDecoration = OutlinedButton.styleFrom(
      padding: const EdgeInsets.all(14.0),
      backgroundColor: Colors.white,
      foregroundColor: primaryColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero));
}
