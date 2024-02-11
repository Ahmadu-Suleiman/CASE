import 'package:case_be_heard/models/video.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CaseHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<void> addMainImage(Function(String) updateMainImage) async {
    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) updateMainImage(image.path);
  }

  static Future<void> addPhotos(Function(List<XFile>) updatePhotos) async {
    List<XFile> photoList = await _picker.pickMultiImage();
    if (photoList.isNotEmpty) updatePhotos(photoList);
  }

  static Future<void> addVideo(Function(Video) updateVideos) async {
    final videoFile = await _picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (videoFile != null) {
      final thumbnailData = await getThumbnail(videoFile.path);
      if (thumbnailData != null) updateVideos(Video(videoFile, thumbnailData));
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
      quality: 25,
    );
  }
}
