import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:case_be_heard/custom_widgets/audio_widget.dart';
import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/models/video.dart';
import 'package:case_be_heard/services/databases/case_database.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:case_be_heard/shared/case_helper.dart';
import 'package:case_be_heard/shared/case_values.dart';
import 'package:case_be_heard/shared/style.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool addLink = false;
  bool loading = false;
  String progress = CaseValues.investigationPending;

  String title = '', summary = '', detailedDescription = '', mainImagePath = '';
  List<String> photos = [];
  List<Video> videos = [];
  List<String> audios = [];
  List<String> links = [];

  Future<void> _scrollToBottom() async {
    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    CommunityMember member = context.watch<CommunityMember>();
    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                title: const Text('Upload a case',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                actions: [
                  IconButton(
                      icon: const Icon(Icons.upload, color: Colors.white),
                      onPressed: () async {
                        if (title.isEmpty) {
                          Utility.showSnackBar(context, 'Please add title');
                        } else if (summary.isEmpty) {
                          Utility.showSnackBar(context, 'Please add summary');
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
                              location: member.location!,
                              photos: photos.map((path) => path).toList(),
                              videos: videos,
                              audios: audios,
                              links: links);
                          await DatabaseCase.uploadCaseRecord(caseRecord);
                          await DatabaseMember.addCaseOrPetitionCommunity(
                              member, widget.communityId);
                          if (context.mounted) {
                            CaseHelper.showNextSteps(
                                context, title, detailedDescription, summary);
                          }
                        }
                      })
                ]),
            resizeToAvoidBottomInset: true,
            body: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 35.0),
                child: ListView(controller: _scrollController, children: [
                  Center(
                      child: Column(children: [
                    DropdownButton<String>(
                        value: progress,
                        underline: Container(),
                        icon: const Icon(Icons.arrow_drop_down),
                        style: Theme.of(context).textTheme.labelLarge,
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
                          await Utility.addMainImage((imagePath) =>
                              setState(() => mainImagePath = imagePath));
                        },
                        icon: const Icon(Icons.image),
                        label: Text('Add main image',
                            style: TextStyle(
                                fontSize: 14, color: Style.primaryColor))),
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: mainImagePath.isNotEmpty
                                ? Image.file(File(mainImagePath),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 250)
                                : Container())),
                    const SizedBox(height: 20),
                    TextFormField(
                        initialValue: title,
                        onChanged: (value) => title = value,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  if (title.isNotEmpty ||
                                      detailedDescription.isNotEmpty) {
                                    CaseHelper.showRecommendedTitle(context,
                                        title, detailedDescription, summary);
                                  } else {
                                    Utility.showSnackBar(context,
                                        'Please add a title and some details first');
                                  }
                                },
                                icon: Icon(Icons.lightbulb_outline,
                                    color: Style.primaryColor)),
                            hintText: 'Case title',
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                        maxLines: 1,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black)),
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
                                icon: Icon(Icons.lightbulb_outline,
                                    color: Style.primaryColor)),
                            hintText: 'Detailed description',
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                        minLines: 10,
                        maxLines: null,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black)),
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
                                icon: Icon(Icons.lightbulb_outline,
                                    color: Style.primaryColor)),
                            hintText: 'Summary',
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                        maxLines: 6,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black))
                  ])),
                  if (photos.isNotEmpty ||
                      videos.isNotEmpty ||
                      audios.isNotEmpty ||
                      links.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Center(
                        child: Text('Media',
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.bold))),
                    const SizedBox(height: 20),
                  ],
                  if (photos.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text('Photos',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: photos.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4),
                        itemBuilder: (context, index) {
                          return Stack(children: [
                            Image.file(File(photos[index]),
                                fit: BoxFit.cover, width: 250, height: 250),
                            Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.remove_circle),
                                  color: Colors.red,
                                  onPressed: () =>
                                      {setState(() => photos.removeAt(index))},
                                ))
                          ]);
                        })
                  ],
                  if (videos.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text('Videos',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: videos.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4),
                        itemBuilder: (context, index) {
                          return Stack(children: [
                            Image.memory(videos[index].thumbnail!,
                                fit: BoxFit.cover, width: 250, height: 250),
                            Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                    icon: const Icon(Icons.remove_circle),
                                    color: Colors.red,
                                    onPressed: () => {
                                          setState(() => videos.removeAt(index))
                                        }))
                          ]);
                        }),
                    const SizedBox(height: 20)
                  ],
                  if (audios.isNotEmpty) ...[
                    const Text('Audios',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
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
                                  path: audios[index]));
                        }),
                    const SizedBox(height: 20)
                  ],
                  if (links.isNotEmpty)
                    const Text('Links',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Container(
                      child: addLink
                          ? TextField(
                              controller: linkController,
                              decoration: InputDecoration(
                                  labelText: 'Enter text',
                                  suffixIcon: IconButton(
                                      icon: Icon(Icons.add_circle,
                                          color: Style.primaryColor),
                                      onPressed: () {
                                        String link = linkController.text;
                                        if (link.isNotEmpty &&
                                            Utility.isValidUrl(link)) {
                                          setState(() => links.add(link));
                                          _scrollToBottom();
                                        } else {
                                          Utility.showSnackBar(
                                              context, 'Invalid Link');
                                        }
                                      })))
                          : Container()),
                  if (links.isNotEmpty)
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: links
                            .asMap()
                            .entries
                            .mapIndexed((index, element) => Dismissible(
                                key: Key('${links[index]}_$index'),
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
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Style.primaryColor,
                                            decorationThickness: 2.0,
                                            fontSize: 14,
                                            color: Style.primaryColor)))))
                            .toList())
                ])),
            bottomSheet: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () async {
                        await CaseHelper.addPhotos((photoList) =>
                            setState(() => photos.addAll(photoList)));
                      },
                      icon: Icon(Icons.photo, color: Style.primaryColor)),
                  IconButton(
                      onPressed: () async {
                        await CaseHelper.addVideo(
                            (video) => setState(() => videos.add(video)));
                      },
                      icon: Icon(Icons.video_camera_back,
                          color: Style.primaryColor)),
                  IconButton(
                      onPressed: () async {
                        await CaseHelper.addAudios((audioList) =>
                            setState(() => audios.addAll(audioList)));
                      },
                      icon: Icon(Icons.audio_file, color: Style.primaryColor)),
                  IconButton(
                      onPressed: () async {
                        setState(() => addLink = !addLink);
                        _scrollToBottom();
                      },
                      icon: Icon(Icons.link, color: Style.primaryColor)),
                ]));
  }
}
