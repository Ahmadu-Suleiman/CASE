import 'package:flutter/material.dart';

class CreateCase extends StatefulWidget {
  const CreateCase({super.key});

  @override
  State<CreateCase> createState() => _CreateCaseState();
}

class _CreateCaseState extends State<CreateCase> {
  List<String> images = [
    'child.jpg',
    'child2.jpg',
    'child3.jpg',
    'profile.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      
      child: ListView(
        children: const [
           Center(
            child: Text(
              'Create a new Case',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
           SizedBox(
            height: 20,
          ),
           Text(
            'Case title',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
           TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
            maxLines: 1,
            style:  TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
           Text(
            'Short description',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            maxLines: 3,
            style:  TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
           Text(
            'Detailed description',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
           TextField(
            style:  TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
