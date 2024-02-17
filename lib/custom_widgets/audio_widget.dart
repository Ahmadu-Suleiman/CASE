import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioWidget extends StatelessWidget {
  const AudioWidget({super.key, required this.audioPlayer, required this.path});

  final AudioPlayer audioPlayer;
  final String path;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () {
            audioPlayer.play(DeviceFileSource(path));
          }),
      IconButton(
          icon: const Icon(Icons.pause),
          onPressed: () {
            audioPlayer.source.toString();
            audioPlayer.play(DeviceFileSource(audioPlayer.source.toString()));
          })
    ]));
  }
}
