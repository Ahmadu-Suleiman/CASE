import 'package:flutter/material.dart';

class CasePage extends StatefulWidget {
  const CasePage({super.key});

  @override
  State<CasePage> createState() => _CasePageState();
}

class _CasePageState extends State<CasePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Others'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Relevant'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Verified'),
            ),
          ],
        ),
      ),
      body: Container(), // Add other widgets here
    );
}
}