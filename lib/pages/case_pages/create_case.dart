import 'dart:io';
import 'package:case_be_heard/custom_widgets/audio_widget.dart';
import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/models/video.dart';
import 'package:case_be_heard/services/databases/case_database.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:case_be_heard/shared/case_helper.dart';
import 'package:case_be_heard/shared/case_values.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';

class CreateCase extends StatefulWidget {
  final String communityId;
  const CreateCase({super.key, required this.communityId});

  @override
  State<CreateCase> createState() => _CreateCaseState();
}

class _CreateCaseState extends State<CreateCase> {
  final audioPlayer = AudioPlayer();
  final linkController = TextEditingController();
  bool addLink = false;
  bool loading = false;
  String progress = CaseValues.investigationPending;

  String title = '', summary = '', detailedDescription = '', mainImagePath = '';
  List<String> photos = [];
  List<Video> videos = [];
  List<String> audios = [];
  List<String> links = [];

  @override
  Widget build(BuildContext context) {
    CommunityMember member = context.watch<CommunityMember>();
    return loading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: true,
            body: Material(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(children: [
                      Center(
                          child: Column(children: [
                        const Text(
                          'Create a new Case',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropdownButton<String>(
                            value: progress,
                            items: CaseValues.dropdownItemsProgress
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                progress = newValue!;
                              });
                            }),
                        const SizedBox(height: 20),
                        TextButton.icon(
                            onPressed: () async {
                              if (title.isEmpty) {
                                Utility.showSnackBar(
                                    context, 'Please add title');
                              } else if (summary.isEmpty) {
                                Utility.showSnackBar(
                                    context, 'Please add summary');
                              } else if (detailedDescription.isEmpty) {
                                Utility.showSnackBar(
                                    context, 'Please add the details');
                              } else if (mainImagePath.isEmpty) {
                                Utility.showSnackBar(
                                    context, 'Please add main image');
                              } else {
                                setState(() => loading = true);
                                String type = await CaseHelper.getCaseCategory(
                                    title, detailedDescription, summary);
                                CaseRecord caseRecord = CaseRecord.forUpload(
                                    uidMember: member.id!,
                                    communityId: widget.communityId,
                                    dateCreated: Timestamp.now(),
                                    title: title,
                                    summary: summary,
                                    details: detailedDescription,
                                    type: type,
                                    progress: progress,
                                    mainImage: mainImagePath,
                                    location: member.location,
                                    photos: photos.map((path) => path).toList(),
                                    videos: videos,
                                    audios: audios,
                                    links: links);
                                await DatabaseCase.uploadCaseRecord(caseRecord);
                                await DatabaseMember.addCaseOrPetitionCommunity(
                                    member, widget.communityId);
                                if (context.mounted) {
                                  CaseHelper.showNextSteps(context, title,
                                      detailedDescription, summary);
                                }
                              }
                            },
                            icon: const Icon(Icons.upload),
                            label: const Text('Upload Case',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                ))),
                        TextButton.icon(
                            onPressed: () async {
                              await Utility.addMainImage((imagePath) =>
                                  setState(() => mainImagePath = imagePath));
                            },
                            icon: const Icon(Icons.image),
                            label: const Text('Add main image',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                ))),
                        const SizedBox(height: 20),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: mainImagePath.isNotEmpty
                                  ? Image.file(
                                      File(mainImagePath),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 250,
                                    )
                                  : Container(),
                            )),
                        const SizedBox(height: 20),
                        TextFormField(
                            initialValue: title,
                            onChanged: (value) => title = value,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      if (title.isNotEmpty ||
                                          detailedDescription.isNotEmpty) {
                                        CaseHelper.showRecommendedTitle(
                                            context,
                                            title,
                                            detailedDescription,
                                            summary);
                                      } else {
                                        Utility.showSnackBar(context,
                                            'Please add a title and some details first');
                                      }
                                    },
                                    icon: const Icon(Icons.lightbulb_outline)),
                                hintText: 'Case title',
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ))),
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            )),
                        const SizedBox(height: 20),
                        TextFormField(
                            initialValue: detailedDescription,
                            onChanged: (value) => detailedDescription = value,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      if (title.isNotEmpty ||
                                          detailedDescription.isNotEmpty) {
                                        CaseHelper.showRecommendedDescription(
                                            context,
                                            title,
                                            detailedDescription,
                                            summary);
                                      } else {
                                        Utility.showSnackBar(context,
                                            'Please add a title and some details first');
                                      }
                                    },
                                    icon: const Icon(Icons.lightbulb_outline)),
                                hintText: 'Detailed description',
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ))),
                            minLines: 10,
                            maxLines: null,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            )),
                        const SizedBox(height: 20),
                        TextFormField(
                            initialValue: summary,
                            onChanged: (value) => summary = value,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      CaseHelper.showRecommendedSummary(context,
                                          title, detailedDescription, summary);
                                    },
                                    icon: const Icon(Icons.lightbulb_outline)),
                                hintText: 'Summary',
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ))),
                            maxLines: 6,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ))
                      ])),
                      const SizedBox(height: 20),
                      const Center(
                          child: Text('Media',
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ))),
                      const SizedBox(height: 20),
                      const Text('Photos',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      TextButton.icon(
                          onPressed: () async {
                            await CaseHelper.addPhotos((photoList) =>
                                setState(() => photos.addAll(photoList)));
                          },
                          icon: const Icon(Icons.image),
                          label: const Text('Upload photos here',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ))),
                      const SizedBox(height: 20),
                      GridView.builder(
                          shrinkWrap:
                              true, // Use shrinkWrap to avoid unbounded height
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: photos.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                3, // Adjust the number of columns as needed
                          ),
                          itemBuilder: (context, index) {
                            return Stack(children: [
                              Image.file(
                                File(photos[index]),
                                fit: BoxFit.cover,
                                width: 250,
                                height: 250,
                              ),
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.remove_circle),
                                    color: Colors.red,
                                    onPressed: () => {
                                      setState(() => photos.removeAt(index))
                                    },
                                  ))
                            ]);
                          }),
                      const SizedBox(height: 20),
                      const Text('Videos',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 20),
                      TextButton.icon(
                          onPressed: () async {
                            await CaseHelper.addVideo(
                                (video) => setState(() => videos.add(video)));
                          },
                          icon: const Icon(Icons.image),
                          label: const Text('Upload videos here',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ))),
                      const SizedBox(height: 20),
                      GridView.builder(
                          shrinkWrap:
                              true, // Use shrinkWrap to avoid unbounded height
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: videos.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                3, // Adjust the number of columns as needed
                          ),
                          itemBuilder: (context, index) {
                            return Stack(children: [
                              Image.memory(
                                videos[index].thumbnail!,
                                fit: BoxFit.cover,
                                width: 250,
                                height: 250,
                              ),
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.remove_circle),
                                    color: Colors.red,
                                    onPressed: () => {
                                      setState(() => videos.removeAt(index))
                                    },
                                  ))
                            ]);
                          }),
                      const SizedBox(height: 20),
                      const Text('Audio',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 20),
                      TextButton.icon(
                          onPressed: () async {
                            await CaseHelper.addAudios((audioList) =>
                                setState(() => audios.addAll(audioList)));
                          },
                          icon: const Icon(Icons.image),
                          label: const Text('Upload audios here',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ))),
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
                          }),
                      const SizedBox(height: 20),
                      const Text('External links',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 20),
                      TextButton.icon(
                          onPressed: () async {
                            setState(() => addLink = !addLink);
                          },
                          icon: const Icon(Icons.image),
                          label: const Text('Upload links here',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ))),
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
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Invalid Link',
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                          ))));
                                            }
                                          })))
                              : Container()),
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
                                      Utility.openLink(context, links[index]);
                                    },
                                    icon: const Icon(Icons.link),
                                    label: Text(links[index],
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.blue,
                                          decorationThickness: 2.0,
                                          fontSize: 14,
                                          color: Colors.blue,
                                        ))));
                          })
                    ]))));
  }
}
