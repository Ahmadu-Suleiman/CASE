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
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:case_be_heard/shared/case_helper.dart';
import 'package:case_be_heard/shared/case_values.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/style.dart';
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
  String commentsType = CaseValues.commentOthers;
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
                DatabaseCase.addCaseRead(member.id!, caseRecord);
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
                          color: CaseHelper.isBookmark(member, caseRecord)
                              ? Style.primaryColor
                              : Colors.black,
                          onPressed: () async {
                            if (CaseHelper.isBookmark(member, caseRecord)) {
                              await DatabaseMember.removeBookmarkCaseRecord(
                                      member, caseRecord)
                                  .then((bookmarkCaseIds) => setState(() =>
                                      member.bookmarkCaseIds =
                                          bookmarkCaseIds));
                            } else {
                              await DatabaseMember.addBookmarkCaseRecord(
                                      member, caseRecord)
                                  .then((bookmarkCaseIds) => setState(() =>
                                      member.bookmarkCaseIds =
                                          bookmarkCaseIds));
                            }
                          })
                    ]),
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
                                        height: 250)))),
                        const SizedBox(height: 20),
                        Text(caseRecord.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        const SizedBox(height: 20),
                        const Text('Details',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        const SizedBox(height: 12),
                        Text(caseRecord.details,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black)),
                        const SizedBox(height: 20),
                        const Text('Summary',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        const SizedBox(height: 12),
                        Text(caseRecord.summary,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black))
                      ])),
                      if (caseRecord.photos.isNotEmpty ||
                          caseRecord.videos.isNotEmpty ||
                          caseRecord.audios.isNotEmpty ||
                          caseRecord.links.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        const Center(
                            child: Text('Media',
                                style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold))),
                        const SizedBox(height: 20),
                      ],
                      if (caseRecord.photos.isNotEmpty) ...[
                        const Text('Photos',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        GridView.count(
                            shrinkWrap: true,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            children: caseRecord.photos
                                .map((photo) => ClickableImage(imageUrl: photo))
                                .toList()),
                        const SizedBox(height: 20)
                      ],
                      if (caseRecord.videos.isNotEmpty) ...[
                        const Text('Videos',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
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
                                    child: Image.network(video.thumbnailUrl!,
                                        fit: BoxFit.cover,
                                        width: 250,
                                        height: 250)))
                                .toList()),
                        const SizedBox(height: 20)
                      ],
                      if (caseRecord.audios.isNotEmpty) ...[
                        const Text('Audio',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        Column(
                            children: caseRecord.audios
                                .map((audio) => AudioWidget(
                                    audioPlayer: _audioPlayer, path: audio))
                                .toList()),
                        const SizedBox(height: 20)
                      ],
                      if (caseRecord.links.isNotEmpty) ...[
                        const Text('External links',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
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
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Colors.blue,
                                            decorationThickness: 2.0,
                                            fontSize: 14,
                                            color: Colors.blue))))
                                .toList())
                      ],
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: comments.length,
                                  itemBuilder: (context, index) {
                                    Comment comment = comments[index];
                                    return GestureDetector(
                                        onLongPress: () {
                                          CaseHelper.editOrDeleteCommentAsOwner(
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
                                              comment.commentType = commentType;
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
