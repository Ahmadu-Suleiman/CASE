import 'dart:io';
import 'package:case_be_heard/models/video.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class CaseHelper {
  static final ImagePicker _picker = ImagePicker();
  static final gemini = Gemini.instance;
  static final safetySettings = [
    SafetySetting(
      category: SafetyCategory.harassment,
      threshold: SafetyThreshold.blockNone,
    ),
    SafetySetting(
      category: SafetyCategory.hateSpeech,
      threshold: SafetyThreshold.blockNone,
    ),
    SafetySetting(
      category: SafetyCategory.dangerous,
      threshold: SafetyThreshold.blockNone,
    ),
    SafetySetting(
      category: SafetyCategory.sexuallyExplicit,
      threshold: SafetyThreshold.blockNone,
    )
  ];
  static final dropdownItems = [
    'Investigation pending',
    'Investigation ongoing',
    'Case solved'
  ];

  static Future<void> addMainImage(Function(String) updateMainImage) async {
    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) updateMainImage(image.path);
  }

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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Invalid Link",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
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
    final capturedContext = context;
    gemini.text(
        '''Give me a one line title in less than 20 words of this my civil or 
    criminal case with these details written by me.\n$title\n$details\nsummary\n$summary.''').then(
        (value) => {
              showDialog(
                context: capturedContext,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Recommended Title'),
                    content: Text(
                      value?.output ??
                          'No title generated. Please remove potential curse words',
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
                        },
                      ),
                    ],
                  );
                },
              )
            });
  }

  static void showRecommendedDescription(BuildContext context, String title,
      String details, String summary) async {
    final capturedContext = context;
    gemini.text(
        '''Give me a better detailed description in less than 150 words of this my civil or 
    criminal case with these details written by me.\n$title\n$details\nsummary\n$summary. 
    Generate as paragraphs.''').then((value) => {
          showDialog(
            context: capturedContext,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Recommended description'),
                content: Text(
                  value?.output ??
                      'No description generated. Please remove potential curse words',
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
                    },
                  ),
                ],
              );
            },
          )
        });
  }

  static void showRecommendedSummary(BuildContext context, String title,
      String details, String summary) async {
    final capturedContext = context;
    gemini.text(
        '''Give me a maximum of three line summary as a single paragraph in less than 25 words of this my civil or 
    criminal case with these details written by me.\n$title\n$details\nsummary\n$summary.''').then(
        (value) => {
              showDialog(
                context: capturedContext,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Recommended Summary'),
                    content: Text(
                      value?.output ??
                          'No summary generated. Please remove potential curse words',
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
                        },
                      ),
                    ],
                  );
                },
              )
            });
  }

  static Future<String> getCaseCategory(
      String title, String description, String summary) async {
    final result = await gemini.text(
        '''Give me the category of this civil or criminal case as a one term.
\n$title,\n$description\n "summary"\n$summary.''');
    return result!.output ?? 'Unknown';
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
                  },
                ),
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) isDeleted = result;
    return isDeleted;
  }
}
