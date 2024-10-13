import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerComponent extends StatefulWidget {
  final String videoUrl; // Allow different video URLs

  const VideoPlayerComponent({required this.videoUrl, Key? key}) : super(key: key);

  @override
  _VideoPlayerComponentState createState() => _VideoPlayerComponentState();
}

class _VideoPlayerComponentState extends State<VideoPlayerComponent> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Refresh UI when video is loaded
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up controller when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                VideoPlayer(_controller),
                _ControlsOverlay(controller: _controller), // Custom controls
                VideoProgressIndicator(_controller, allowScrubbing: true),
              ],
            ),
          )
        : Center(child: CircularProgressIndicator()); // Show loader while initializing
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.center,
          child: Icon(
            controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 50.0,
          ),
        ),
      ],
    );
  }
}
