import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';

class CreateCase extends StatefulWidget {
  const CreateCase({super.key});

  @override
  State<CreateCase> createState() => _CreateCaseState();
}

class _CreateCaseState extends State<CreateCase> {
  List<String> images = [
    'child.jpg',
    'child2.jpg',
    'child3.jpg',
    'profile.png',
  ];

  final ImagePicker _picker = ImagePicker();
  Image? image;
  List<XFile> photos = List.empty(growable: true);
  List<XFile> videos = List.empty(growable: true);

  void getMainImage() async {
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

  void getPhotos() async {
    List<XFile> photoList = await _picker.pickMultiImage();
    if (photoList.isNotEmpty) {
      photos.addAll(photoList);
      setState(() {});
    }
  }

  Future getVideo(ImageSource img) async {
    final videoFile = await _picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (videoFile != null) {
      photos.add(videoFile);
      setState(() {});
    }
  }

  void pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
    } else {
      // User canceled the picker
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
                      getMainImage();
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
                getPhotos();
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
            GridView.count(
              shrinkWrap: true,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              children: videos
                  .map((video) => Image.file(
                        File(video.path),
                        fit: BoxFit.cover,
                        width: 250,
                        height: 250,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () async {
                pickAudioFile();
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
            const Text(
              'Audio',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
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
