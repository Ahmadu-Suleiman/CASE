import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconText({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Icon(
        icon,
        color: Colors.blue,
      ),
      const SizedBox(width: 8), // Space between the icon and the text
      Text(text, style: const TextStyle(fontSize: 14, color: Colors.blue))
    ]);
  }
}
