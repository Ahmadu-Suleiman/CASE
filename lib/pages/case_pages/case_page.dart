import 'package:cached_network_image/cached_network_image.dart';
import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/services/databases/case_database.dart';
import 'package:flutter/material.dart';

class CasePage extends StatefulWidget {
  const CasePage({super.key});

  @override
  State<CasePage> createState() => _CasePageState();
}

class _CasePageState extends State<CasePage> {
  @override
  Widget build(BuildContext context) {
    final String? uidCase =
        ModalRoute.of(context)?.settings.arguments as String?;
    if (uidCase != null) {
      return FutureBuilder(
          future: DatabaseCase.getCaseRecord(uidCase),
          builder: (BuildContext context, AsyncSnapshot<CaseRecord> snapshot) {
            if (snapshot.hasData) {
              CaseRecord caseRecord = snapshot.data!;
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: CachedNetworkImage(
                                  imageUrl: caseRecord.mainImage,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 250,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              initialValue: title,
                              onChanged: (value) => title = value,
                              decoration:
                                  const InputDecoration(hintText: 'Case title'),
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            Text
                            const SizedBox(height: 20),
                            TextFormField(
                              initialValue: shortDescription,
                              onChanged: (value) => shortDescription = value,
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
                        onChanged: (value) => detailedDescription = value,
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
                          await CaseHelper.addVideo(
                              (video) => setState(() => videos.add(video)));
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
                                  video.videoThumbnail!,
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
                      const DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            TabBar(
                              indicatorSize: TabBarIndicatorSize.tab,
                              tabs: [
                                Tab(text: 'others'),
                                Tab(text: 'relevant'),
                                Tab(text: 'verified'),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  Text('others'),
                                  Text('relevant'),
                                  Text('verified'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ));
            } else {
              return const Loading();
            }
          });
    } else {
      Navigator.pop(context);
      return const Loading();
    }
  }
}
