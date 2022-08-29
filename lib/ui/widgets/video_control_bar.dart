import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoControlBar extends StatefulWidget {
  const VideoControlBar({Key? key, required this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  State<VideoControlBar> createState() => _VideoControlBarState();
}

class _VideoControlBarState extends State<VideoControlBar> {
  bool get isPlaying => widget.controller.value.isPlaying;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  void _toggleController() {
    isPlaying ? widget.controller.pause() : widget.controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VideoProgressIndicator(
          widget.controller,
          allowScrubbing: true,
        ),
        Material(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _buildRow(),
          ),
        )
      ],
    );
  }

  Widget _buildRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: _toggleController,
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
        ),
        Text(
          '${widget.controller.value.position.format()} / '
          '${widget.controller.value.duration.format()}',
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

extension on Duration {
  String format() {
    return toString().split('.').first;
  }
}
