import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:case_be_heard/custom_widgets/audio_widget.dart';
import 'package:case_be_heard/custom_widgets/clickable_image.dart';
import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/case_database.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/utility.dart';
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
  final _audioPlayer = AudioPlayer();
  final _scrollController = ScrollController();

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
                body: ListView(controller: _scrollController, children: [
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
                                    color: Colors.blue,
                                  ))))
                          .toList())
                ]));
          } else {
            return const Loading();
          }
        });
  }
}
