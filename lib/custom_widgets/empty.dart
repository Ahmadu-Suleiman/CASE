import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  const Empty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.brown[100],
        child: const Center(
            child: Icon(
          Icons.info,
          size: 50.0,
          color: Colors.grey,
        )));
  }
}
