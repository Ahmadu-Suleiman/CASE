import 'package:flutter/material.dart';

class Style {
  static Color primaryColor = const Color(0xFFF4B360);
  static Color secondaryColor = const Color(0xFFE7E7E7);

  static Color colorDark = const Color(0xFF111F28);
  static Color secondaryColorDark = const Color(0xFF1A3140);

  static final textInputDecoration = InputDecoration(
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.all(12.0),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 2.0),
      ));
}
