import 'package:flutter/material.dart';
import 'package:tiktok_mate/ui/widgets/video_control_bar.dart';
import 'package:video_player/video_player.dart';

class AppVideoPlayer extends StatefulWidget {
  const AppVideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  final String videoUrl;

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late DoubleTapAction _lastAction;
  late Animation<double> _sizeAnimation;
  late Animation<double> _fadeAnimation;
  late AnimationController _animationController;
  IconData? _lastAnimationIcon;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _sizeAnimation = Tween<double>(begin: 28, end: 72).animate(_animationController);
    _fadeAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0, end: 1), weight: 1),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1, end: 0), weight: 1),
    ]).animate(_animationController);
    _lastAction = DoubleTapAction.none;
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  void _onVideoTapped(TapDownDetails _) {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
      _playAnimation(_controller.value.isPlaying ? Icons.play_arrow : Icons.pause);
    });
  }

  void _playAnimation(IconData icon) {
    _lastAnimationIcon = icon;
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized ? _buildVideoPlayer() : _buildLoading();
  }

  Widget _buildLoading() {
    return const Text('processando vídeo');
  }

  Widget _buildVideoPlayer() {
    return Stack(
      children: [
        Center(
          child: GestureDetector(
            onTapDown: _onVideoTapped,
            onDoubleTap: () {
              const offset = Duration(seconds: 10);
              if (_lastAction == DoubleTapAction.back) {
                _controller.seekTo(_controller.value.position - offset);
                _playAnimation(Icons.fast_rewind);
              } else if (_lastAction == DoubleTapAction.forward) {
                _controller.seekTo(_controller.value.position + offset);
                _playAnimation(Icons.fast_forward);
              }
            },
            onDoubleTapDown: (details) {
              final half = MediaQuery.of(context).size.width / 2;
              _lastAction =
                  details.globalPosition.dx > half ? DoubleTapAction.forward : DoubleTapAction.back;
            },
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(
                _controller,
              ),
            ),
          ),
        ),
        Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Material(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(
                      _lastAnimationIcon,
                      color: Colors.white,
                      size: _sizeAnimation.value,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 0,
          width: MediaQuery.of(context).size.width,
          child: VideoControlBar(controller: _controller),
        ),
      ],
    );
  }
}

enum DoubleTapAction { forward, back, none }
