import 'package:case_be_heard/shared/style.dart';
import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String text;
  final double fontSize;

  const IconText(
      {super.key,
      required this.icon,
      required this.iconSize,
      required this.text,
      required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: Style.primaryColor, size: iconSize),
          const SizedBox(width: 8),
          Flexible(
              child: Text(text,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: fontSize)))
        ]);
  }
}
