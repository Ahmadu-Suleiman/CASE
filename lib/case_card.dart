import 'package:flutter/material.dart';

class CaseCard extends StatefulWidget {
  final String text;

  const CaseCard({
    super.key,
    required this.text,
  });

  @override
  State<CaseCard> createState() => _CaseCardState();
}

class _CaseCardState extends State<CaseCard> {
  @override
  Widget build(BuildContext context) {
    return Case(text: widget.text);
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
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/case_page');
      },
      child: Card(
        color: Colors.grey,
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
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
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
                const Center(
                  child: Text(
                    'Usman Salis has been missing for three days',
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  text,
                  maxLines: 3,
                  textAlign: TextAlign.center,
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
      ),
    );
  }
}
