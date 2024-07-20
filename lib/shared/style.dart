import 'package:flutter/material.dart';

class Style {
  static Color mainColor = const Color(0xFFF4B360);
  static Color mainColorDark = const Color(0xFF111F28);

  static final textInputDecoration = InputDecoration(
      contentPadding: const EdgeInsets.all(12.0),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Colors.red, width: 1.0)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Colors.red, width: 1.0)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Colors.black, width: 1.0)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(width: 1.0)));

  static final buttonDecoration = ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(14.0),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)));
  static final buttonGoogleDecoration = OutlinedButton.styleFrom(
      padding: const EdgeInsets.all(14.0),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero));

  static InputDecoration descriptiveDecoration(String hint) => InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always, labelText: hint);
}
