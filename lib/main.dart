import 'package:flutter/material.dart';
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

class _MyHomePageState extends State<MyHomePage> {
  late VideoPlayerController _controller;
  late DoubleTapAction _lastAction;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://v16m.tiktokcdn.com/9d685a814bfcf596f7eaaa28132d71f2/630b42ad/video/tos/useast2a/tos-useast2a-pve-0068/b4b2efa695a54c45aa04f01254ef56c8/?a=1180&ch=0&cr=0&dr=0&lr=all&cd=0%7C0%7C0%7C0&cv=1&br=640&bt=320&cs=0&ds=6&ft=lUxGYHnMMyq8Z2-q0he2NFR2dIJGb&mime_type=video_mp4&qs=0&rc=aThpaTtpNDUzO2hmOGc0OkBpamxoaWY6ZnZ1PDMzNzczM0AuNi8vY2I1XmMxXzNjL2NjYSNfM2czcjRnZnBgLS1kMTZzcw%3D%3D&l=2022082804225201021713510318BCAA8C&btag=80000&cc=3')
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.addListener(() {
      setState(() {});
    });
    _lastAction = DoubleTapAction.none;
  }

  void _onVideoTapped() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
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
                    onTap: _onVideoTapped,
                    onDoubleTap: () {
                      const offset = Duration(seconds: 10);
                      if (_lastAction == DoubleTapAction.back) {
                        _controller.seekTo(_controller.value.position - offset);
                      } else if (_lastAction == DoubleTapAction.forward) {
                        _controller.seekTo(_controller.value.position + offset);
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
                Positioned(
                  bottom: 0,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                      ),
                      Material(
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _controller.value.isPlaying
                                        ? _controller.pause()
                                        : _controller.play();
                                  });
                                },
                                icon: Icon(
                                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${_controller.value.position.format()} / ${_controller.value.duration.format()}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
