import 'package:flutter/material.dart';

class MesssageScreen extends StatelessWidget {
  final String message;
  final Icon icon;
  const MesssageScreen({super.key, required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(children: [icon, Text(message)]));
  }
}
