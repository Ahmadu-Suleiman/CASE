import 'package:case_be_heard/shared/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class CommunityHelper {
  static final _gemini = Gemini.instance;
  static void showRecommendedName(
      BuildContext context, String name, String description) async {
    Utility.showSnackBar(context, 'Generating title, please wait');
    _gemini.text('''Generate a concise one-line name for a community.

    Create a title based on the provided details:
    Name: "$name"
    Description: "$description"

    Avoid the use of asterisks for formatting and refrain from including titles or headings.''').then(
        (value) => {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: const Text('Recommended name'),
                        content: Text(
                          value?.output ?? 'No name generated',
                        ),
                        actions: <Widget>[
                          TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          TextButton(
                              child: const Text('Copy'),
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: value?.output ?? ''));
                                Navigator.of(context).pop();
                              })
                        ]);
                  })
            });
  }

  static void showRecommendedDescription(
      BuildContext context, String name, String description) async {
    Utility.showSnackBar(context, 'Generating description, please wait');
    _gemini.text('''
    Generate a concise and comprehensive description for a community.

    Craft a coherent paragraph with a length of under 50 words based on the provided details:
    Name: "$name"
    Description: "$description"

    Avoid the use of asterisks for formatting.''').then((value) => {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text('Recommended description'),
                    content: Text(
                      value?.output ?? 'No description generated',
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                          child: const Text('Copy'),
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: value?.output ?? ''));
                            Navigator.of(context).pop();
                          })
                    ]);
              })
        });
  }

  static void showRecommendedRegulations(BuildContext context, String name,
      String description, String regulation) async {
    Utility.showSnackBar(context, 'Generating description, please wait');
    _gemini.text('''
    Generate a concise and comprehensive regulations for a community. The details are provided as:
    Name: "$name"
    Description: "$description"
    Regulations: "$regulation"

    Avoid the use of asterisks for formatting.''').then((value) => {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text('Recommended regulations'),
                    content: Text(
                      value?.output?.replaceAll('*', '') ??
                          'No description generated',
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                          child: const Text('Copy'),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                text:
                                    value?.output?.replaceAll('*', '') ?? ''));
                            Navigator.of(context).pop();
                          })
                    ]);
              })
        });
  }
}
