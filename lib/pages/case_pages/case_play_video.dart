import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CaseVideoPlayer extends StatefulWidget {
  const CaseVideoPlayer({super.key});

  @override
  State<CaseVideoPlayer> createState() => _CaseVideoPlayerState();
}

class _CaseVideoPlayerState extends State<CaseVideoPlayer> {
  VideoPlayerController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String? videoUrl =
        ModalRoute.of(context)?.settings.arguments as String?;
    if (videoUrl != null && _controller == null) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      _controller!.addListener(() {
        setState(() {});
      });
      _controller!.initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized.
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
              child: VideoPlayer(_controller!),
            ),
          );
  }
}
