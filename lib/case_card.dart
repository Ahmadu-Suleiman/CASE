import 'package:flutter/material.dart';

class CaseCard extends StatelessWidget {
  final String text;

  const CaseCard({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Case(text: text);
  }
}

class Case extends StatelessWidget {
  const Case({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/child3.jpg'),
                      radius: 30,
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        'genthamid@gmail.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      FilledButton.icon(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.brown)),
                          onPressed: () {},
                          icon: const Icon(
                            Icons.message,
                            size: 12,
                          ),
                          label: const Text(
                            'Direct contact',
                            style: TextStyle(fontSize: 12),
                          )),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Progress: Investigation pending',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
              const Text(
                'Type: Missing Person',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.verified),
                label: const Text(
                  'Verified Case',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: const Image(
                    image: AssetImage('assets/child.jpg'),
                    width: 300,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
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
