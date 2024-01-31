import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import '../case_card.dart';

class CreateCase extends StatefulWidget {
  const CreateCase({super.key});

  @override
  State<CreateCase> createState() => _CreateCaseState();
}

class _CreateCaseState extends State<CreateCase> {
  @override
  Widget build(BuildContext context) {
    return  const Column(
      children: [
        Text(
          'Create Case',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Create a new case',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}