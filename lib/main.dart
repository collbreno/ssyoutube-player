import 'package:flutter/material.dart';
import 'package:tiktok_mate/ui/widgets/video_control_bar.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late DoubleTapAction _lastAction;
  late Animation<double> _sizeAnimation;
  late Animation<double> _fadeAnimation;
  late AnimationController _animationController;
  IconData? _lastAnimationIcon;

  @override
  void initState() {
    _animationController =
        AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _sizeAnimation = Tween<double>(begin: 28, end: 72).animate(_animationController);
    _fadeAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0, end: 1), weight: 1),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1, end: 0), weight: 1),
    ]).animate(_animationController);
    super.initState();
    _controller = VideoPlayerController.network(
        'https://v19.tiktokcdn.com/1914cbc70fe51fae8cf245c9e69e8056/630d6826/video/tos/useast2a/tos-useast2a-pve-0068/b4b2efa695a54c45aa04f01254ef56c8/?a=1180&ch=0&cr=0&dr=0&lr=all&cd=0%7C0%7C0%7C0&cv=1&br=640&bt=320&cs=0&ds=6&ft=ARfLcB7qqG3mo0PWFZ7BkVQnqVOT_KJ&mime_type=video_mp4&qs=0&rc=aThpaTtpNDUzO2hmOGc0OkBpamxoaWY6ZnZ1PDMzNzczM0AuNi8vY2I1XmMxXzNjL2NjYSNfM2czcjRnZnBgLS1kMTZzcw%3D%3D&l=20220829192717010217023164013AAC38&btag=80000&cc=4')
      ..initialize().then((_) {
        setState(() {});
      });
    // _controller.addListener(() {
    //   setState(() {});
    // });
    _lastAction = DoubleTapAction.none;
  }

  void _onVideoTapped(dynamic _) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _controller.value.isInitialized
          ? Stack(
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
                      _lastAction = details.globalPosition.dx > half
                          ? DoubleTapAction.forward
                          : DoubleTapAction.back;
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
            )
          : const Text('Loading...'),
    );
  }
}

extension on Duration {
  String format() {
    return toString().split('.').first;
  }
}

enum DoubleTapAction { forward, back, none }
