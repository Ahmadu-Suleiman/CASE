import 'dart:io';
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/models/comment.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/models/video.dart';
import 'package:case_be_heard/services/databases/comments_database.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class CaseHelper {
  static final ImagePicker _picker = ImagePicker();
  static final _gemini = Gemini.instance;

  static Future<void> addPhotos(Function(List<String>) updatePhotos) async {
    List<XFile> photoList = await _picker.pickMultiImage();
    if (photoList.isNotEmpty) {
      updatePhotos(photoList.map((file) => file.path).toList());
    }
  }

  static Future<void> addVideo(Function(Video) updateVideos) async {
    final videoFile = await _picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (videoFile != null) {
      final thumbnailData = await getThumbnail(videoFile.path);
      if (thumbnailData != null) {
        updateVideos(Video(File(videoFile.path), thumbnailData));
      }
    }
  }

  static Future<void> addAudios(Function(List<String>) updateAudios) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result != null) {
      List<String> audioLinks = result.files.nonNulls
          .where((file) => file.path != null)
          .map((file) => file.path!)
          .toList();
      updateAudios(audioLinks);
    }
  }

  static TextField appendlinkWidgets(
      BuildContext context,
      TextEditingController linkController,
      Function(String) onLinkSubmitted,
      bool showAddLink) {
    return TextField(
        controller: linkController,
        decoration: InputDecoration(
            labelText: 'Enter text',
            suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  String link = linkController.text;
                  if (link.isNotEmpty && Utility.isValidUrl(link)) {
                    onLinkSubmitted(link);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Invalid Link",
                            style: TextStyle(
                              color: Colors.red,
                            ))));
                  }
                })));
  }

  static Future<Uint8List?> getThumbnail(String path) async {
    return await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 250,
      maxWidth: 250,
      quality: 100,
    );
  }

  static void showRecommendedTitle(BuildContext context, String title,
      String details, String summary) async {
    Utility.showSnackBar(context, 'Generating title, please wait');
    _gemini.text(
        '''Generate a concise one-line title (20 words or less) for a legal case in first person.

    Craft a title based on the provided details:
    Title: "$title"
    Details: "$details"
    Summary: "$summary"

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

  static void showRecommendedDescription(BuildContext context, String title,
      String details, String summary) async {
    Utility.showSnackBar(context, 'Generating description, please wait');
    _gemini.text(
        '''Generate a comprehensive and succinct description (under 150 words) for a legal case.

    Craft coherent first-person paragraphs based on the provided details:
    Title: "$title"
    Details: "$details"
    Summary: "$summary"

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

  static void showRecommendedSummary(BuildContext context, String title,
      String details, String summary) async {
    Utility.showSnackBar(context, 'Generating summary, please wait');
    _gemini.text(
        '''Generate a concise three-line summary (less than 25 words) for my legal case in first person:
        Title: "$title"
        Details: "$details"
        Summary: "$summary".
        Avoid using asterisks for formatting and omit titles or headings.''').then(
        (value) => {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: const Text('Recommended Summary'),
                        content: Text(
                          value!.output ?? 'No summary',
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
                                    ClipboardData(text: value.output ?? ''));
                                Navigator.of(context).pop();
                              })
                        ]);
                  })
            });
  }

  static Future<String> getCaseCategory(
      String title, String description, String summary) async {
    final result =
        await _gemini.text('''Determine the legal category for this case:
              Title: "$title"
              Description: "$description"
              Summary: "$summary". Generate the category as a single term. 
              Do not include asterisks for formating.''');
    return result!.output ?? 'Unknown';
  }

  static Future<String> getNextSteps(
      String title, String description, String summary) async {
    final result = await _gemini.text('''Provide guidance on the recommended 
    next steps for my legal case, considering the details provided:
    Title: "$title"
    Description: "$description"
    Summary: "$summary". Do not include asterisks for formating.''');
    return result!.output ?? 'Unknown';
  }

  static showNextSteps(BuildContext context, String title, String description,
      String summary) async {
    String nextSteps =
        await CaseHelper.getNextSteps(title, description, summary);
    if (context.mounted) {
      context.replace('${Routes.nextSteps}/$nextSteps');
    }
  }

  static Future<bool> showDeleteCaseDialog(BuildContext context) async {
    bool isDeleted = false;
    final result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
                title: const Text('Case Deletion'),
                content: const Text(
                  'Are you sure you want to delete this case?',
                ),
                actions: <Widget>[
                  TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      }),
                  TextButton(
                      child: const Text('Delete'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      })
                ]);
          });
        });

    if (result != null) isDeleted = result;
    return isDeleted;
  }

  static editOrDeleteCommentAsOwner(
      BuildContext context, Comment comment, Function() update) {
    final commentController = TextEditingController();
    commentController.text = comment.commentText;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Comment'),
              content: TextField(
                autofocus: true,
                minLines: 4,
                maxLines: null,
                controller: commentController,
              ),
              actions: <Widget>[
                TextButton(
                    child: const Text('Delete Comment'),
                    onPressed: () {
                      DatabaseComments.deleteComment(context, comment);
                      Navigator.of(context).pop();
                      update();
                    }),
                TextButton(
                    child: const Text('Edit Comment'),
                    onPressed: () {
                      String text = commentController.text;
                      if (text.isNotEmpty) {
                        comment.commentText = text.trim();
                        DatabaseComments.updateComment(context, comment);
                        Navigator.of(context).pop();
                        update();
                      }
                    }),
              ]);
        });
  }

  static bool isBookmark(CommunityMember member, CaseRecord caseRecord) {
    return member.bookmarkCaseIds.contains(caseRecord.id);
  }
}
