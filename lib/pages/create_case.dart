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
        children: [
          const Center(
            child: Text(
              'Create a new Case',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.image),
              label: const Text(
                'Add main image',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: TextField(
              decoration: InputDecoration(hintText: 'Case title'),
              maxLines: 1,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: TextField(
              decoration: InputDecoration(hintText: 'Short description'),
              maxLines: 3,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const TextField(
            decoration: InputDecoration(hintText: 'Detailed description'),
            minLines: 5,
            maxLines: null,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Media',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Photos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            children: images
                .map((image) => Image.asset(
                      'assets/$image',
                      height: 150,
                      fit: BoxFit.cover,
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            'Videos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            children: images
                .map((image) => Image.asset(
                      'assets/$image',
                      height: 150,
                      fit: BoxFit.cover,
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            'Audio',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'External links',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
