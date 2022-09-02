import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoControlBar extends StatefulWidget {
  const VideoControlBar({
    Key? key,
    required this.controller,
    required this.isFullscreen,
    required this.setFullscreen,
  }) : super(key: key);

  final VideoPlayerController controller;
  final bool isFullscreen;
  final ValueSetter<bool> setFullscreen;

  @override
  State<VideoControlBar> createState() => _VideoControlBarState();
}

class _VideoControlBarState extends State<VideoControlBar> {
  bool get isPlaying => widget.controller.value.isPlaying;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _toggleController() {
    isPlaying ? widget.controller.pause() : widget.controller.play();
  }

  void _toggleFullscreen() {
    widget.setFullscreen(!widget.isFullscreen);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
        Row(
          children: [
            IconButton(
              onPressed: _toggleController,
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            ),
            Text(
              '${widget.controller.value.position.format()} / '
              '${widget.controller.value.duration.format()}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        IconButton(
          icon: Icon(widget.isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen),
          onPressed: _toggleFullscreen,
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
