import 'package:flutter/material.dart';

class CaseCard extends StatelessWidget {
  final String text;
  const CaseCard({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/profile.png'),
                  radius: 40,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Gent',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'genthamid@gmail.com',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.message,
                        size: 20,
                      ),
                      label: const Text('Direct contact'))
                ],
              ),
            ],
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Verified Case',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.greenAccent,
                ),
              ),
              Text(
                'Progress: Investigation pending',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.greenAccent,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Image(
              image: AssetImage('assets/profile.png'),
              width: 250,
              height: 250,
            ),
          ),
          Text(
            text,
            maxLines: 3,
            style: const TextStyle(fontSize: 18.0, color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'tap for more details',
            style: TextStyle(fontSize: 12.0, color: Colors.black),
          ),
        ]),
      ),
    );
  }
}
