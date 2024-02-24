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
import 'package:case_be_heard/shared/style.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
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
  final ScrollController _scrollController = ScrollController();

  final _commentController = TextEditingController();
  String commentsType = CaseValues.commentOthers;
  bool addLink = false;
  bool isLoading = false;

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

  Future<void> _scrollToBottom() async {
    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  @override //TODO: BUILD ONCE
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
            return isLoading
                ? const Loading()
                : Scaffold(
                    appBar: AppBar(
                        backgroundColor: Style.primaryColor,
                        leading: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        title: const Text('Edit case',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        actions: [
                          IconButton(
                              icon:
                                  const Icon(Icons.upload, color: Colors.white),
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
                                  setState(() => isLoading = true);
                                  String type =
                                      await CaseHelper.getCaseCategory(
                                          title, details, summary);
                                  CaseRecord caseRecordUpload =
                                      CaseRecord.forUpdate(
                                          id: uidCase!,
                                          title: title,
                                          summary: summary,
                                          details: details,
                                          type: type,
                                          progress: progress,
                                          mainImage: mainImagePath,
                                          location: member.location!,
                                          photos: photos,
                                          videos: videos,
                                          audios: audios,
                                          links: links);
                                  await DatabaseCase.updateCaseRecord(
                                      caseRecordUpload);
                                  if (context.mounted) {
                                    CaseHelper.showNextSteps(
                                        context, title, details, summary);
                                  }
                                }
                              }),
                          IconButton(
                              icon:
                                  const Icon(Icons.delete, color: Colors.white),
                              onPressed: () async {
                                final delete =
                                    await CaseHelper.showDeleteCaseDialog(
                                        context);
                                if (delete) {
                                  setState(() => isLoading = true);
                                  await DatabaseCase.deleteCaseRecord(
                                      caseRecord);
                                  if (mounted) Navigator.pop(context);
                                }
                              })
                        ]),
                    resizeToAvoidBottomInset: true,
                    body: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 35.0),
                        child:
                            ListView(controller: _scrollController, children: [
                          Center(
                              child: Column(children: [
                            DropdownButton<String>(
                                value: progress,
                                items: CaseValues.dropdownItemsProgress
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                      value: value, child: Text(value));
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    progress = newValue!;
                                  });
                                }),
                            TextButton.icon(
                                onPressed: () async {
                                  await Utility.addMainImage((imagePath) =>
                                      setState(
                                          () => mainImagePath = imagePath));
                                },
                                icon: const Icon(Icons.image),
                                label: Text('Add main image',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Style.primaryColor))),
                            const SizedBox(height: 20),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: mainImagePath.isEmpty
                                        ? Container()
                                        : mainImagePath.startsWith('http')
                                            ? Image.network(mainImagePath,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: 250)
                                            : Image.file(File(mainImagePath),
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: 250))),
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
                                              context, title, details, summary);
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
                                      fontWeight: FontWeight.bold))),
                          const SizedBox(height: 20),
                          const Text('Photos',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
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
                                  (photos[index].startsWith('http'))
                                      ? Image.network(photos[index],
                                          fit: BoxFit.cover,
                                          width: 250,
                                          height: 250)
                                      : Image.file(File(photos[index]),
                                          fit: BoxFit.cover,
                                          width: 250,
                                          height: 250),
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
                                  (videos[index].thumbnailUrl != null)
                                      ? Image.network(
                                          videos[index].thumbnailUrl!,
                                          fit: BoxFit.cover,
                                          width: 250,
                                          height: 250)
                                      : Image.memory(videos[index].thumbnail!,
                                          fit: BoxFit.cover,
                                          width: 250,
                                          height: 250),
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                          icon: const Icon(Icons.remove_circle),
                                          color: Colors.red,
                                          onPressed: () => {
                                                setState(() =>
                                                    videos.removeAt(index))
                                              }))
                                ]);
                              }),
                          const SizedBox(height: 20),
                          const Text('Audio',
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
                                      path: audios[index]),
                                );
                              }),
                          const SizedBox(height: 20),
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
                                                String link =
                                                    linkController.text;
                                                if (link.isNotEmpty &&
                                                    Utility.isValidUrl(link)) {
                                                  setState(
                                                      () => links.add(link));
                                                  _scrollToBottom();
                                                } else {
                                                  Utility.showSnackBar(
                                                      context, 'Invalid Link');
                                                }
                                              })))
                                  : Container()),
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
                                            Utility.openLink(
                                                context, links[index]);
                                          },
                                          icon: const Icon(Icons.link),
                                          label: Text(links[index],
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor:
                                                      Style.primaryColor,
                                                  decorationThickness: 2.0,
                                                  fontSize: 14,
                                                  color: Style.primaryColor)))))
                                  .toList()),
                          const SizedBox(height: 20),
                          const Text('Comments',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          TextButton.icon(
                              style: TextButton.styleFrom(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.zero),
                              onPressed: () => _showCommentsType(context),
                              icon: const Icon(Icons.arrow_drop_down),
                              label: Text(commentsType)),
                          StreamBuilder<List<Comment>>(
                              stream: DatabaseComments.getComments(
                                  caseRecord.id, commentsType),
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
                                      member.id == caseRecord.member.id;
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
                                                      () => {setState(() {})});
                                            },
                                            child: CommentWidget(
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
                                      icon: Icon(Icons.send,
                                          color: Style.primaryColor),
                                      onPressed: () async {
                                        String text = _commentController.text;
                                        if (text.isNotEmpty) {
                                          _commentController.text = '';
                                          Comment comment = Comment.forUpload(
                                            caseRecordId: caseRecord.id,
                                            commentText: text,
                                            authorId: member.id!,
                                            commentType:
                                                CaseValues.commentOthers,
                                            dateCreated: Timestamp.now(),
                                          );
                                          DatabaseComments.addComment(
                                              context, comment);
                                        }
                                      })))
                        ])),
                    bottomSheet: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () async {
                                await CaseHelper.addPhotos((photoList) =>
                                    setState(() => photos.addAll(photoList)));
                              },
                              icon:
                                  Icon(Icons.photo, color: Style.primaryColor)),
                          IconButton(
                              onPressed: () async {
                                await CaseHelper.addVideo((video) =>
                                    setState(() => videos.add(video)));
                              },
                              icon: Icon(Icons.video_camera_back,
                                  color: Style.primaryColor)),
                          IconButton(
                              onPressed: () async {
                                await CaseHelper.addAudios((audioList) =>
                                    setState(() => audios.addAll(audioList)));
                              },
                              icon: Icon(Icons.audio_file,
                                  color: Style.primaryColor)),
                          IconButton(
                              onPressed: () async {
                                setState(() => addLink = !addLink);
                                _scrollToBottom();
                              },
                              icon:
                                  Icon(Icons.link, color: Style.primaryColor)),
                        ]));
          }
          return const Loading();
        });
  }

  void _showCommentsType(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              padding: const EdgeInsets.all(8),
              height: 200,
              alignment: Alignment.center,
              child: ListView.builder(
                  itemCount: CaseValues.itemsCommentsType.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextButton.icon(
                            label: Text(CaseValues.itemsCommentsType[index],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            icon: const Icon(Icons.comment),
                            onPressed: () {
                              setState(() => commentsType =
                                  CaseValues.itemsCommentsType[index]);
                              Navigator.of(context).pop();
                            }));
                  }));
        });
  }
}
