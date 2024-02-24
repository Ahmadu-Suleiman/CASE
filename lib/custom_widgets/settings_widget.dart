import 'package:flutter/material.dart';

class SettingsWidget extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String text;
  final double fontSize;
  final Function onPressed;

  const SettingsWidget(
      {super.key,
      required this.icon,
      required this.iconSize,
      required this.text,
      required this.fontSize,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: iconSize),
            const SizedBox(width: 8),
            Flexible(
                child: Text(text,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: fontSize)))
          ]),
    );
  }
}