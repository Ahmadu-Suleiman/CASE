import 'package:flutter/material.dart';

class CreateCase extends StatefulWidget {
  const CreateCase({super.key});

  @override
  State<CreateCase> createState() => _CreateCaseState();
}

class _CreateCaseState extends State<CreateCase> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
         Center(
          child: Text(
            'Create a mew Case',
            style: TextStyle(
              fontSize: 24,
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
          maxLines: 1,
          style:  TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
         Text(
          'Short description',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        TextField(
          maxLines: 3,
          style:  TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
         Text(
          'Detailed description',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
         TextField(
          style:  TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),


      ],
    );
  }
}
