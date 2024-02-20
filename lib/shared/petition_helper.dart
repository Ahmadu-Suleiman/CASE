import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/models/petition.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class PetitionHelper {
  static final ImagePicker _picker = ImagePicker();
  static final _gemini = Gemini.instance;

  static void showRecommendedTitle(
      BuildContext context, String title, String details) async {
    Utility.showSnackBar(context, 'Generating title, please wait');
    _gemini.text(
        '''Generate a concise one-line title (20 words or less) for a petition.

    Create a title based on the provided details:
    Title: "$title"
    Details: "$details"

    Avoid the use of asterisks for formatting and refrain from including titles or headings.''').then(
        (value) => {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: const Text('Recommended Title'),
                        content: Text(
                          value?.output ?? 'No title generated',
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
      BuildContext context, String title, String details) async {
    Utility.showSnackBar(context, 'Generating description, please wait');
    _gemini.text('''_generate_petition_description(title, details):
    Generate a concise and comprehensive description for a petition.

    Craft a coherent first-person paragraph with a length of under 50 words based on the provided details:
    Title: "$title"
    Details: "$details"

    Avoid the use of asterisks for formatting and refrain from including titles or headings.''').then(
        (value) => {
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

  static Future<String> getCaseCategory(
      String title, String description) async {
    final result =
        await _gemini.text('''Determine the legal category for this petition:
              Title: "$title"
              Description: "$description". Generate the category as a single term. 
              Do not include asterisks for formating.''');
    return result!.output ?? 'Unknown';
  }

  static Future<String> getNextSteps(String title, String description) async {
    final result = await _gemini.text('''Provide guidance on the recommended 
    next steps for my petition, considering the details provided:
    Title: "$title"
    Description: "$description". Do not include asterisks for formating.''');
    return result!.output ?? 'Unknown';
  }

  static showNextSteps(
      BuildContext context, String title, String description) async {
    String nextSteps = await getNextSteps(title, description);
    if (context.mounted) {
      context.replace('${Routes.nextSteps}/$nextSteps');
    }
  }

  static bool isBookmark(CommunityMember member, Petition petition) {
    return member.bookmarkCaseIds.contains(petition.id);
  }
}
