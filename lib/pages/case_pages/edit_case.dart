import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:case_be_heard/custom_widgets/audio_widget.dart';
import 'package:case_be_heard/custom_widgets/comment_widget.dart';
import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/models/comment.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/models/video.dart';
import 'package:case_be_heard/services/databases/case_database.dart';
import 'package:case_be_heard/services/databases/comments_database.dart';
import 'package:case_be_heard/shared/case_helper.dart';
import 'package:case_be_heard/shared/case_values.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditCase extends StatefulWidget {
  final String caseId;
  const EditCase({super.key, required this.caseId});

  @override
  State<EditCase> createState() => _EditCaseState();
}

class _EditCaseState extends State<EditCase> {
  final audioPlayer = AudioPlayer();
  final linkController = TextEditingController();
  final titleController = TextEditingController();
  final detailController = TextEditingController();
  final summaryController = TextEditingController();

  final _commentController = TextEditingController();
  String commentsType = CaseValues.commentVerified;
  bool addLink = false;
  bool loading = false;

  late CaseRecord caseRecord;
  String? uidCase;
  String progress = CaseValues.investigationPending;
  String title = '', summary = '', details = '', mainImagePath = '';
  List<String> photos = [];
  List<Video> videos = [];
  List<String> audios = [];
  List<String> links = [];

  @override
  void initState() {
    super.initState();
    uidCase = widget.caseId;
  }

  @override
  Widget build(BuildContext context) {
    CommunityMember member = context.watch<CommunityMember>();
    return FutureBuilder(
        future: DatabaseCase.getCaseRecord(widget.caseId),
        builder: (BuildContext context, AsyncSnapshot<CaseRecord> snapshot) {
          if (snapshot.hasData) {
            caseRecord = snapshot.data!;
            progress = caseRecord.progress;
            title = caseRecord.title;
            summary = caseRecord.summary;
            details = caseRecord.details;
            mainImagePath = caseRecord.mainImage;
            photos = caseRecord.photos;
            videos = caseRecord.videos;
            audios = caseRecord.audios;
            links = caseRecord.links;

            titleController.text = title;
            detailController.text = details;
            summaryController.text = summary;
            return (!loading)
                ? Scaffold(
                    resizeToAvoidBottomInset: true,
                    body: Material(
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListView(children: [
                              Center(
                                  child: Column(children: [
                                const Text(
                                  'Edit Case',
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
                                      } else if (summary.isEmpty) {
                                        Utility.showSnackBar(
                                            context, 'Please add summary');
                                      } else if (details.isEmpty) {
                                        Utility.showSnackBar(
                                            context, 'Please add the details');
                                      } else if (mainImagePath.isEmpty) {
                                        Utility.showSnackBar(
                                            context, 'Please add main image');
                                      } else {
                                        setState(() => loading = true);
                                        String type =
                                            await CaseHelper.getCaseCategory(
                                                title, details, summary);
                                        CaseRecord caseRecord =
                                            CaseRecord.forUpdate(
                                                uid: uidCase!,
                                                uidMember: member.uid!,
                                                title: title,
                                                summary: summary,
                                                details: details,
                                                type: type,
                                                progress: progress,
                                                mainImage: mainImagePath,
                                                location: member.location,
                                                photos: photos,
                                                videos: videos,
                                                audios: audios,
                                                links: links);
                                        await DatabaseCase.updateCaseRecord(
                                            caseRecord);
                                        if (context.mounted) {
                                          CaseHelper.showNextSteps(
                                              context, title, details, summary);
                                        }
                                      }
                                    },
                                    icon: const Icon(Icons.upload),
                                    label: const Text('Update Case',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                        ))),
                                TextButton.icon(
                                    onPressed: () async {
                                      final delete =
                                          await CaseHelper.showDeleteCaseDialog(
                                              context);
                                      if (delete) {
                                        setState(() => loading = true);
                                        await DatabaseCase.deleteCaseRecord(
                                            caseRecord);
                                        if (mounted) Navigator.pop(context);
                                      }
                                    },
                                    icon: const Icon(Icons.upload),
                                    label: const Text('Delete Case',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                        ))),
                                DropdownButton<String>(
                                    value: progress,
                                    items: CaseValues.dropdownItemsProgress
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
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
                                TextButton.icon(
                                    onPressed: () async {
                                      await CaseHelper.addMainImage(
                                          (imagePath) => setState(
                                              () => mainImagePath = imagePath));
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
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: mainImagePath.isEmpty
                                            ? Container()
                                            : mainImagePath.startsWith('http')
                                                ? Image.network(
                                                    mainImagePath,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: 250,
                                                  )
                                                : Image.file(
                                                    File(mainImagePath),
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: 250,
                                                  ))),
                                const SizedBox(height: 20),
                                TextFormField(
                                    controller: titleController,
                                    onChanged: (value) => title = value,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              if (title.isNotEmpty ||
                                                  details.isNotEmpty) {
                                                CaseHelper.showRecommendedTitle(
                                                    context,
                                                    title,
                                                    details,
                                                    summary);
                                              } else {
                                                Utility.showSnackBar(context,
                                                    'Please add a title and some details first');
                                              }
                                            },
                                            icon: const Icon(
                                                Icons.lightbulb_outline)),
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
                                    controller: detailController,
                                    onChanged: (value) => details = value,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              if (title.isNotEmpty ||
                                                  details.isNotEmpty) {
                                                CaseHelper
                                                    .showRecommendedDescription(
                                                        context,
                                                        title,
                                                        details,
                                                        summary);
                                              } else {
                                                Utility.showSnackBar(context,
                                                    'Please add a title and some details first');
                                              }
                                            },
                                            icon: const Icon(
                                                Icons.lightbulb_outline)),
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
                                    controller: summaryController,
                                    onChanged: (value) => summary = value,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              CaseHelper.showRecommendedSummary(
                                                  context,
                                                  title,
                                                  details,
                                                  summary);
                                            },
                                            icon: const Icon(
                                                Icons.lightbulb_outline)),
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
                                        setState(
                                            () => photos.addAll(photoList)));
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
                                      (photos[index].startsWith('http'))
                                          ? Image.network(
                                              photos[index],
                                              fit: BoxFit.cover,
                                              width: 250,
                                              height: 250,
                                            )
                                          : Image.file(
                                              File(photos[index]),
                                              fit: BoxFit.cover,
                                              width: 250,
                                              height: 250,
                                            ),
                                      Positioned(
                                          top: 0,
                                          right: 0,
                                          child: IconButton(
                                            icon:
                                                const Icon(Icons.remove_circle),
                                            color: Colors.red,
                                            onPressed: () => {
                                              setState(
                                                  () => photos.removeAt(index))
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
                                    await CaseHelper.addVideo((video) =>
                                        setState(() => videos.add(video)));
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
                                      (videos[index].thumbnailUrl != null)
                                          ? Image.network(
                                              videos[index]
                                                  .thumbnailUrl!, // Replace with your actual image URL
                                              fit: BoxFit.cover,
                                              width: 250,
                                              height:
                                                  250, // Optional: Show an error icon if the image fails to load
                                            )
                                          : Image.memory(
                                              videos[index].thumbnail!,
                                              fit: BoxFit.cover,
                                              width: 250,
                                              height: 250,
                                            ),
                                      Positioned(
                                          top: 0,
                                          right: 0,
                                          child: IconButton(
                                            icon:
                                                const Icon(Icons.remove_circle),
                                            color: Colors.red,
                                            onPressed: () => {
                                              setState(
                                                  () => videos.removeAt(index))
                                            },
                                          ))
                                    ]);
                                  }),
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
                                        setState(
                                            () => audios.addAll(audioList)));
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
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
                                                    String link =
                                                        linkController.text;
                                                    if (link.isNotEmpty &&
                                                        Utility.isValidUrl(
                                                            link)) {
                                                      setState(() =>
                                                          links.add(link));
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                                      'Invalid Link',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                      ))));
                                                    }
                                                  })))
                                      : Container()),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: links.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Dismissible(
                                        key: Key(links[index]),
                                        onDismissed: (direction) {
                                          setState(() => links.removeAt(index));
                                        },
                                        background:
                                            Container(color: Colors.red),
                                        child: TextButton.icon(
                                            onPressed: () {
                                              Utility.openLink(
                                                  context, links[index]);
                                            },
                                            icon: const Icon(Icons.link),
                                            label: Text(links[index],
                                                style: const TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor: Colors.blue,
                                                  decorationThickness: 2.0,
                                                  fontSize: 14,
                                                  color: Colors.blue,
                                                ))));
                                  }),
                              SegmentedButton<String>(
                                showSelectedIcon: false,
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius
                                          .zero, // This removes the curve
                                    ),
                                  ),
                                ),
                                segments: const <ButtonSegment<String>>[
                                  ButtonSegment<String>(
                                      value: CaseValues.commentVerified,
                                      label: Text(CaseValues.commentVerified),
                                      icon: Icon(Icons.verified)),
                                  ButtonSegment<String>(
                                      value: CaseValues.commentUseful,
                                      label: Text(CaseValues.commentUseful),
                                      icon: Icon(Icons.thumb_up)),
                                  ButtonSegment<String>(
                                      value: CaseValues.commentOthers,
                                      label: Text(CaseValues.commentOthers),
                                      icon: Icon(Icons.more_vert)),
                                ],
                                selected: <String>{commentsType},
                                onSelectionChanged: (Set<String> newSelection) {
                                  setState(
                                      () => commentsType = newSelection.first);
                                },
                              ),
                              StreamBuilder<List<Comment>>(
                                  stream: DatabaseComments.getComments(
                                      caseRecord.uid, commentsType),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<Comment>> snapshot) {
                                    if (snapshot.hasError) {
                                      return const Text('Something went wrong');
                                    }
                                    if (snapshot.hasData) {
                                      List<Comment> comments =
                                          snapshot.data as List<Comment>;
                                      if (comments.isEmpty) {
                                        return const Text('No comments');
                                      }

                                      bool isCaseRecordCreator =
                                          member.uid == caseRecord.member.uid;
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: comments.length,
                                          itemBuilder: (context, index) {
                                            Comment comment = comments[index];
                                            return GestureDetector(
                                                onLongPress: () {
                                                  CaseHelper
                                                      .editOrDeleteCommentAsOwner(
                                                          context,
                                                          comment,
                                                          () => {
                                                                setState(() {})
                                                              });
                                                },
                                                child: CommentWidget(
                                                    author: member,
                                                    comment: comment,
                                                    isCaseRecordCreator:
                                                        isCaseRecordCreator,
                                                    onChangeCategory:
                                                        (commentType) async {
                                                      comment.commentType =
                                                          commentType;
                                                      await DatabaseComments
                                                          .updateComment(
                                                              context, comment);
                                                      setState(() {});
                                                    }));
                                          });
                                    }
                                    return const Text('No comments');
                                  }),
                              TextField(
                                  autofocus: true,
                                  minLines: 4,
                                  maxLines: null,
                                  controller: _commentController,
                                  decoration: InputDecoration(
                                      hintText: 'Write a comment...',
                                      suffixIcon: IconButton(
                                          icon: const Icon(Icons.send),
                                          onPressed: () async {
                                            String text =
                                                _commentController.text;
                                            if (text.isNotEmpty) {
                                              _commentController.text = '';
                                              Comment comment =
                                                  Comment.forUpload(
                                                caseRecordId: caseRecord.uid,
                                                commentText: text,
                                                authorId: member.uid!,
                                                commentType:
                                                    CaseValues.commentOthers,
                                                dateCreated: Timestamp.now(),
                                              );
                                              DatabaseComments.addComment(
                                                  context, comment);
                                            }
                                          })))
                            ]))))
                : const Loading();
          }
          return const Loading();
        });
  }
}
