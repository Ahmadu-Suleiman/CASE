import 'package:flutter/material.dart';

class SettingsWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onPressed;

  const SettingsWidget(
      {super.key,
      required this.icon,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onPressed(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon, size: 24),
                const SizedBox(width: 8),
                Flexible(
                    child: Text(text,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 24)))
              ]),
          const Divider()
        ]));
  }
}
