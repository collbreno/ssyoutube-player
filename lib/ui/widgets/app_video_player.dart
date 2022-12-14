import 'package:flutter/material.dart';
import 'package:tiktok_mate/ui/widgets/loading_indicator.dart';
import 'package:tiktok_mate/ui/widgets/video_control_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class AppVideoPlayer extends StatefulWidget {
  const AppVideoPlayer({
    Key? key,
    required this.videoUrl,
    required this.isFullscreen,
    required this.setFullscreen,
  }) : super(key: key);

  final String videoUrl;
  final bool isFullscreen;
  final ValueSetter<bool> setFullscreen;

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late DoubleTapAction _lastAction;
  late bool _isShowingControls;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    _isShowingControls = true;
    _lastAction = DoubleTapAction.none;
    _controller = VideoPlayerController.network(widget.videoUrl)..initialize();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    Wakelock.disable();
    _controller.dispose();
    super.dispose();
  }

  void _onVideoTapped(TapDownDetails _) {
    setState(() {
      _isShowingControls = !_isShowingControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized ? _buildVideoPlayer() : _buildLoading();
  }

  Widget _buildLoading() {
    return const LoadingIndicator(text: 'Processando vídeo...');
  }

  Future<bool> _onWillPop() async {
    if (widget.isFullscreen) {
      widget.setFullscreen(false);
      return false;
    }

    return true;
  }

  Widget _buildVideoPlayer() {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Stack(
        children: [
          GestureDetector(
            onTapDown: _onVideoTapped,
            onDoubleTap: _onVideoDoubleTapped,
            onDoubleTapDown: _onVideoDoubleTappedDown,
            child: Material(
              child: Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(
                    _controller,
                  ),
                ),
              ),
            ),
          ),
          if (!_controller.value.isBuffering)
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: !_isShowingControls
                    ? null
                    : Material(
                        color: Colors.black,
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.circular(100),
                        child: IconButton(
                          iconSize: 56,
                          onPressed: _playOrPauseVideo,
                          icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
                        ),
                      ),
              ),
            ),
          if (_controller.value.isBuffering)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                backgroundColor: Colors.black,
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isShowingControls
                  ? VideoControlBar(
                      controller: _controller,
                      setFullscreen: widget.setFullscreen,
                      isFullscreen: widget.isFullscreen,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  void _playOrPauseVideo() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
        _isShowingControls = false;
      }
    });
  }

  void _onVideoDoubleTappedDown(details) {
    final half = MediaQuery.of(context).size.width / 2;
    _lastAction = details.globalPosition.dx > half ? DoubleTapAction.forward : DoubleTapAction.back;
  }

  void _onVideoDoubleTapped() {
    const offset = Duration(seconds: 10);
    if (_lastAction == DoubleTapAction.back) {
      _controller.seekTo(_controller.value.position - offset);
    } else if (_lastAction == DoubleTapAction.forward) {
      _controller.seekTo(_controller.value.position + offset);
    }
  }
}

enum DoubleTapAction { forward, back, none }
