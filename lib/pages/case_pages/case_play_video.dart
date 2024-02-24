import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CaseVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const CaseVideoPlayer({super.key, required this.videoUrl});

  @override
  State<CaseVideoPlayer> createState() => _CaseVideoPlayerState();
}

class _CaseVideoPlayerState extends State<CaseVideoPlayer> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (_controller == null) {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      _controller!.addListener(() {
        setState(() {});
      });
      _controller!.initialize().then((_) {
        _controller!.play();
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(() {});
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller == null || !_controller!.value.isInitialized
        ? const Center(child: CircularProgressIndicator())
        : GestureDetector(
            onTap: () {
              setState(() {
                _controller!.value.isPlaying
                    ? _controller!.pause()
                    : _controller!.play();
              });
            },
            child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!)));
  }
}
