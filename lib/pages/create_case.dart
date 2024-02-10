import 'dart:io';
import 'package:case_be_heard/custom_widgets/audio_widget.dart';
import 'package:case_be_heard/models/video.dart';
import 'package:case_be_heard/utility.dart';
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
  final linkController = TextEditingController();

  Image? image;
  List<Widget> linkWidgets = [];
  List<Widget> addlinkWidgets = [];

  List<XFile> photos = List.empty(growable: true);
  List<Video> videos = List.empty(growable: true);
  List<String> audios = List.empty(growable: true);
  List<String> links = List.empty(growable: true);

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

  void addVideo() async {
    final videoFile = await _picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (videoFile != null) {
      final thumbnailData = await VideoThumbnail.thumbnailData(
        video: videoFile.path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 250,
        maxWidth: 250,
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

  void appendlinkWidgets(TextEditingController linkControllers) {
    setState(() {
      addlinkWidgets = [
        Expanded(
          child: TextField(
            maxLines: 1,
            controller: linkControllers,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
        IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () {
              String link = linkController.text;
              if (link.isNotEmpty && Utility.isValidUrl(link)) {
                setState(() {
                  links.add(link);
                  addlinkWidgets.clear();
                });
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
            })
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Material(
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
                        icon: const Icon(Icons.create),
                        label: const Text(
                          'Create',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                      ),
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
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: audios.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      key: Key(audios[index]),
                      onDismissed: (direction) {
                        setState(() {
                          audioPlayer.pause();
                          audios.removeAt(index);
                        });
                      },
                      background: Container(color: Colors.red),
                      child: AudioWidget(
                          audioPlayer: audioPlayer, path: audios[index]),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'External links',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () async {
                    appendlinkWidgets(linkController);
                  },
                  icon: const Icon(Icons.image),
                  label: const Text(
                    'Upload links here',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(children: addlinkWidgets),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: links.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                        key: Key(links[index]),
                        onDismissed: (direction) {
                          setState(() {
                            links.removeAt(index);
                          });
                        },
                        background: Container(color: Colors.red),
                        child: TextButton.icon(
                          onPressed: () {
                            Utility.openLink(context, links[index]);
                          },
                          icon: const Icon(Icons.link),
                          label: Text(
                            links[index],
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue,
                              decorationThickness: 2.0,
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ));
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
