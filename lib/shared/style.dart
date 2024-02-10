import 'package:flutter/material.dart';

class Style {
  static Color primaryColor = getColor('#F4B360');
  static Color secondaryColor = getColor('##E7E7E7');

  static const textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    contentPadding: EdgeInsets.all(12.0),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.pink, width: 2.0),
    ),
  );

  static Color getColor(String hex) =>
      Color(int.parse('0xFF${hex.substring(2)}'));
}
