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
        color: Colors.white,
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
                        FilledButton.icon(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                              minimumSize: MaterialStateProperty.all(Size.zero),
                            ),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.message,
                              size: 12,
                            ),
                            label: const Text(
                              'Contact directly',
                              style: TextStyle(fontSize: 12),
                            )),
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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: const Image(
                      image: AssetImage('assets/child.jpg'),
                      width: double.infinity,
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
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.remove_red_eye),
                          label: const Text(
                            '148',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.mark_chat_read),
                          label: const Text(
                            '65',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        // Add your logic here
                      },
                    ),
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
