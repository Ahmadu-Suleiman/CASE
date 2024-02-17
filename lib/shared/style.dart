import 'package:flutter/material.dart';

class Style {
  static Color primaryColor = const Color(0xFFF4B360);
  static Color secondaryColor = const Color(0xFFE7E7E7);

  static const textInputDecoration = InputDecoration(
      fillColor: Colors.white,
      filled: true,
      contentPadding: EdgeInsets.all(12.0),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.pink, width: 2.0),
      ));
}
