import 'dart:io';
import 'dart:typed_data';
import 'package:case_be_heard/custom_widgets/audio_widget.dart';
import 'package:case_be_heard/models/video.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CreateCase extends StatefulWidget {
  const CreateCase({super.key});

  @override
  State<CreateCase> createState() => _CreateCaseState();
}

class _CreateCaseState extends State<CreateCase> {
  final ImagePicker _picker = ImagePicker();
  final audioPlayer = AudioPlayer();
  Image? image;
  List<XFile> photos = List.empty(growable: true);
  List<Video> videos = List.empty(growable: true);
  List<String> audios = List.empty(growable: true);

  void addMainImage() async {
    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      this.image = Image.file(
        File(image.path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: 250,
      );
      setState(() {});
    }
  }

  void addPhotos() async {
    List<XFile> photoList = await _picker.pickMultiImage();
    if (photoList.isNotEmpty) {
      photos.addAll(photoList);
      setState(() {});
    }
  }

  Future addVideo() async {
    final videoFile = await _picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (videoFile != null) {
      Uint8List? thumbnailData = await VideoThumbnail.thumbnailData(
        video: videoFile.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128,
        quality: 25,
      );

      if (thumbnailData != null) {
        videos.add(Video(videoFile, thumbnailData));
        setState(() {});
      }
    }
  }

  void addAudios() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result != null) {
      audios.addAll(result.files.nonNulls
          .where((file) => file.path != null)
          .map((file) => file.path!)
          .toList());
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  const Text(
                    'Create a new Case',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: () {
                      addMainImage();
                    },
                    icon: const Icon(Icons.image),
                    label: const Text(
                      'Add main image',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: image,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const TextField(
                    decoration: InputDecoration(hintText: 'Case title'),
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Short description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Detailed description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
              minLines: 10,
              maxLines: null,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Media',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Photos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            //photos here
            TextButton.icon(
              onPressed: () async {
                addPhotos();
              },
              icon: const Icon(Icons.image),
              label: const Text(
                'Upload photos here',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              children: photos
                  .map((image) => Image.file(
                        File(image.path),
                        fit: BoxFit.cover,
                        width: 250,
                        height: 250,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Videos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () async {
                addVideo();
              },
              icon: const Icon(Icons.image),
              label: const Text(
                'Upload videos here',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              children: videos
                  .map((video) => Image.memory(
                        video.videoThumbnail,
                        fit: BoxFit.cover,
                        width: 250,
                        height: 250,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Audio',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () async {
                addAudios();
              },
              icon: const Icon(Icons.image),
              label: const Text(
                'Upload audios here',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
                children: audios
                    .asMap()
                    .entries
                    .map((audio) => Column(
                          children: [
                            AudioWidget(
                                audioPlayer: audioPlayer,
                                path: audio.value,
                                remove: () {
                                  audios.removeAt(audio.key);
                                  setState(() {});
                                })
                          ],
                        ))
                    .toList()),
            const SizedBox(height: 20),
            const Text(
              'External links',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
