import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioWidget extends StatelessWidget {
  const AudioWidget(
      {super.key,
      required this.audioPlayer,
      required this.path,
      required this.remove});

  final AudioPlayer audioPlayer;
  final String path;
  final Function remove;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              audioPlayer.play(DeviceFileSource(path));
            },
          ),
          IconButton(
            icon: const Icon(Icons.pause),
            onPressed: () {
              audioPlayer.pause();
            },
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: remove(),
          ),
        ],
      ),
    );
  }
}
