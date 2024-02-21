import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NextSteps extends StatelessWidget {
  final String nextSteps;
  const NextSteps({super.key, required this.nextSteps});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: ListView(children: [
              const Text('Next possible steps',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(
                height: 16,
              ),
              SelectableText(
                nextSteps,
                style: const TextStyle(fontSize: 20),
              ),
              FilledButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: nextSteps));
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy'))
            ]))));
  }
}
