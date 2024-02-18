import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:case_be_heard/custom_widgets/audio_widget.dart';
import 'package:case_be_heard/custom_widgets/clickable_image.dart';
import 'package:case_be_heard/custom_widgets/comment_widget.dart';
import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/models/comment.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/case_database.dart';
import 'package:case_be_heard/services/databases/comments_database.dart';
import 'package:case_be_heard/shared/case_helper.dart';
import 'package:case_be_heard/shared/case_values.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CasePage extends StatefulWidget {
  final String caseId;
  const CasePage({super.key, required this.caseId});

  @override
  State<CasePage> createState() => _CasePageState();
}

class _CasePageState extends State<CasePage> {
  String commentsType = CaseValues.commentVerified;
  final _audioPlayer = AudioPlayer();
  final _scrollController = ScrollController();
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CommunityMember member = context.watch<CommunityMember>();
    return FutureBuilder(
        future: DatabaseCase.getCaseRecord(widget.caseId),
        builder: (BuildContext context, AsyncSnapshot<CaseRecord> snapshot) {
          if (snapshot.hasData) {
            CaseRecord caseRecord = snapshot.data!;
            _scrollController.addListener(() {
              if (_scrollController.position.pixels ==
                  _scrollController.position.maxScrollExtent) {
                DatabaseCase.addCaseRead(member.uid!, caseRecord);
              }
            });
            return Scaffold(
                appBar: AppBar(
                  title: const Image(
                    height: 80,
                    width: 80,
                    image: AssetImage('assets/case_logo_main.ico'),
                    color: Colors.brown,
                  ),
                  centerTitle: true,
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.bookmark),
                      onPressed: () {
                        // Add your logic here
                      },
                    ),
                  ],
                ),
                body: ListView(
                    padding: const EdgeInsets.all(8),
                    controller: _scrollController,
                    children: [
                      Center(
                          child: Column(children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: () => context.push(
                                    '${Routes.casePhoto}/${Uri.encodeComponent(caseRecord.mainImage)}'),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: CachedNetworkImage(
                                      imageUrl: caseRecord.mainImage,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 250,
                                    )))),
                        const SizedBox(height: 20),
                        Text(
                            caseRecord
                                .title, // Use the title if it's not null, otherwise use 'Case title' as a placeholder
                            maxLines: 1,
                            overflow: TextOverflow
                                .ellipsis, // To handle long text that might exceed one line
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            )),
                        const SizedBox(height: 20),
                        Text(
                            caseRecord
                                .summary, // Use the shortDescription if it's not null, otherwise use 'Short description' as a placeholder
                            maxLines:
                                3, // Retain the maxLines property to limit the number of lines
                            overflow: TextOverflow
                                .ellipsis, // Handle text that might exceed three lines
                            style: const TextStyle(
                              fontSize:
                                  18, // Maintain the same font size as the original TextFormField
                              color: Colors.black,
                            ))
                      ])),
                      Text(
                        caseRecord
                            .details, // Use the detailedDescription if it's not null, otherwise use 'Detailed description' as a placeholder
                        style: const TextStyle(
                          fontSize:
                              18, // Maintain the same font size as the original TextFormField
                          color: Colors.black,
                        ),
                      ),
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
                      //photos here
                      const SizedBox(height: 20),
                      GridView.count(
                        shrinkWrap: true,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        children: caseRecord.photos
                            .map(
                              (photo) => ClickableImage(
                                imageUrl: photo,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                      const Text('Videos',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 20),
                      GridView.count(
                          shrinkWrap: true,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          children: caseRecord.videos
                              .map((video) => GestureDetector(
                                  onTap: () => context.push(
                                      '${Routes.caseVideo}/${Uri.encodeComponent(video.videoUrl!)}'),
                                  child: Image.network(
                                    video
                                        .thumbnailUrl!, // Replace with your actual image URL
                                    fit: BoxFit.cover,
                                    width: 250,
                                    height:
                                        250, // Optional: Show an error icon if the image fails to load
                                  )))
                              .toList()),
                      const SizedBox(height: 20),
                      const Text('Audio',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 20),
                      Column(
                          children: caseRecord.audios
                              .map((audio) => AudioWidget(
                                  audioPlayer: _audioPlayer, path: audio))
                              .toList()),
                      const SizedBox(height: 20),
                      const Text('External links',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 20),
                      Column(
                          children: caseRecord.links
                              .map((link) => TextButton.icon(
                                  onPressed: () {
                                    Utility.openLink(context, link);
                                  },
                                  icon: const Icon(Icons.link),
                                  label: Text(link,
                                      style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.blue,
                                          decorationThickness: 2.0,
                                          fontSize: 14,
                                          color: Colors.blue))))
                              .toList()),
                      SegmentedButton<String>(
                        showSelectedIcon: false,
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.zero, // This removes the curve
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
                          setState(() => commentsType = newSelection.first);
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
                                  member.uid == caseRecord.uid;
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: comments.length,
                                  itemBuilder: (context, index) {
                                    Comment comment = comments[index];
                                    return GestureDetector(
                                        onLongPress: CaseHelper
                                            .editOrDeleteCommentAsOwner(context,
                                                comment, () => setState(() {})),
                                        child: CommentWidget(
                                            authorName:
                                                Utility.getFirstAndlastName(
                                                    comment.author),
                                            profilePictureUrl:
                                                comment.author.photoUrl,
                                            commentText: comment.commentText,
                                            commentDate: comment.dateCreated,
                                            commentType: comment.commentType,
                                            isCaseRecordCreator:
                                                isCaseRecordCreator,
                                            onChangeCategory:
                                                (commentType) async {
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
                                    String text = _commentController.text;
                                    if (text.isNotEmpty) {
                                      _commentController.text = '';
                                      Comment comment = Comment.forUpload(
                                        caseRecordId: caseRecord.uid,
                                        commentText: text,
                                        authorId: member.uid!,
                                        commentType: CaseValues.commentOthers,
                                        dateCreated: Timestamp.now(),
                                      );
                                      DatabaseComments.addComment(
                                          context, comment);
                                    }
                                  })))
                    ]));
          } else {
            return const Loading();
          }
        });
  }
}
