import 'dart:io';
import 'package:case_be_heard/custom_widgets/audio_widget.dart';
import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/models/video.dart';
import 'package:case_be_heard/services/databases/case_database.dart';
import 'package:case_be_heard/shared/case_helper.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';

class EditCase extends StatefulWidget {
  const EditCase({super.key});

  @override
  State<EditCase> createState() => _EditCaseState();
}

class _EditCaseState extends State<EditCase> {
  final audioPlayer = AudioPlayer();
  final linkController = TextEditingController();
  bool addLink = false;
  bool loading = false;

  String title = '',
      shortDescription = '',
      detailedDescription = '',
      mainImagePath = '';
  List<XFile> photos = List.empty(growable: true);
  List<Video?> videos = List.empty(growable: true);
  List<String> audios = List.empty(growable: true);
  List<String> links = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    CommunityMember? member = Provider.of<CommunityMember?>(context);

    final String? uidCase =
        ModalRoute.of(context)?.settings.arguments as String?;
    if (uidCase != null) {
      return FutureBuilder(
          future: DatabaseCase.getCaseRecordAndVideos(uidCase),
          builder: (BuildContext context,
              AsyncSnapshot<CaseRecordAndVideos> snapshot) {
            if (snapshot.hasData) {
              CaseRecordAndVideos caseRecordAndVideos = snapshot.data!;
              CaseRecord caseRecord = caseRecordAndVideos.caseRecord;
              title = caseRecord.title;
              shortDescription = caseRecord.shortDescription;
              detailedDescription = caseRecord.detailedDescription;
              mainImagePath = caseRecord.mainImage;
              photos = caseRecord.photos.map((path) => XFile(path)).toList();
              videos = caseRecordAndVideos.videos;
              audios = caseRecord.audios;
              links = caseRecord.links;
              return (member != null && !loading)
                  ? Scaffold(
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
                                      onPressed: () async {
                                        if (title.isEmpty) {
                                          Utility.showSnackBar(
                                              context, 'Please add title');
                                        } else if (shortDescription.isEmpty) {
                                          Utility.showSnackBar(context,
                                              'Please add short description');
                                        } else if (detailedDescription
                                            .isEmpty) {
                                          Utility.showSnackBar(context,
                                              'Please add detailed description');
                                        } else if (mainImagePath.isEmpty) {
                                          Utility.showSnackBar(
                                              context, 'Please add main image');
                                        } else {
                                          setState(() => loading = true);
                                          CaseRecord caseRecord =
                                              CaseRecord.forUpload(
                                                  uidMember: member.uid!,
                                                  title: title,
                                                  shortDescription:
                                                      shortDescription,
                                                  detailedDescription:
                                                      detailedDescription,
                                                  type: 'Assault',
                                                  progress: 'Pending',
                                                  mainImage: mainImagePath,
                                                  location: member.location,
                                                  photos: photos
                                                      .map((file) => file.path)
                                                      .toList(),
                                                  videos: videos.nonNulls
                                                      .map((video) =>
                                                          video.file.path)
                                                      .toList(),
                                                  audios: audios,
                                                  links: links);
                                          await DatabaseCase.uploadCaseRecord(
                                              caseRecord);
                                          if (mounted) Navigator.pop(context);
                                        }
                                      },
                                      icon: const Icon(Icons.upload),
                                      label: const Text(
                                        'Upload Case',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () async {
                                        await CaseHelper.addMainImage(
                                            (imagePath) => setState(() =>
                                                mainImagePath = imagePath));
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
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        child: mainImagePath.isNotEmpty
                                            ? Image.file(
                                                File(mainImagePath),
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: 250,
                                              )
                                            : Container(),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      initialValue: title,
                                      onChanged: (value) => title = value,
                                      decoration: const InputDecoration(
                                          hintText: 'Case title'),
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      initialValue: shortDescription,
                                      onChanged: (value) =>
                                          shortDescription = value,
                                      decoration: const InputDecoration(
                                        hintText: 'Short description',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                      ),
                                      maxLines: 3,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextFormField(
                                initialValue: detailedDescription,
                                onChanged: (value) =>
                                    detailedDescription = value,
                                decoration: const InputDecoration(
                                  hintText: 'Detailed description',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                ),
                                minLines: 10,
                                maxLines: null,
                                style: const TextStyle(
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
                                  await CaseHelper.addPhotos((photoList) =>
                                      setState(() => photos.addAll(photoList)));
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
                                  await CaseHelper.addVideo((video) =>
                                      setState(() => videos.add(video)));
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
                                          video!.thumbnail!,
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
                                  await CaseHelper.addAudios((audioList) =>
                                      setState(() => audios.addAll(audioList)));
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
                                        audioPlayer: audioPlayer,
                                        path: audios[index]),
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
                                  setState(() => addLink = !addLink);
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
                              Container(
                                child: addLink
                                    ? TextField(
                                        controller: linkController,
                                        decoration: InputDecoration(
                                          labelText: 'Enter text',
                                          suffixIcon: IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () {
                                              String link = linkController.text;
                                              if (link.isNotEmpty &&
                                                  Utility.isValidUrl(link)) {
                                                setState(() => links.add(link));
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Invalid Link',
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
                                      )
                                    : Container(),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: links.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Dismissible(
                                      key: Key(links[index]),
                                      onDismissed: (direction) {
                                        setState(() => links.removeAt(index));
                                      },
                                      background: Container(color: Colors.red),
                                      child: TextButton.icon(
                                        onPressed: () {
                                          Utility.openLink(
                                              context, links[index]);
                                        },
                                        icon: const Icon(Icons.link),
                                        label: Text(
                                          links[index],
                                          style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline,
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
                      ))
                  : const Loading();
            } else {
              Navigator.pop(context);
              return const Loading();
            }
          });
    } else {
      Navigator.pop(context);
      return const Loading();
    }
  }
}
