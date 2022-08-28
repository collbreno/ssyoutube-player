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

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://v16m.tiktokcdn.com/9d685a814bfcf596f7eaaa28132d71f2/630b42ad/video/tos/useast2a/tos-useast2a-pve-0068/b4b2efa695a54c45aa04f01254ef56c8/?a=1180&ch=0&cr=0&dr=0&lr=all&cd=0%7C0%7C0%7C0&cv=1&br=640&bt=320&cs=0&ds=6&ft=lUxGYHnMMyq8Z2-q0he2NFR2dIJGb&mime_type=video_mp4&qs=0&rc=aThpaTtpNDUzO2hmOGc0OkBpamxoaWY6ZnZ1PDMzNzczM0AuNi8vY2I1XmMxXzNjL2NjYSNfM2czcjRnZnBgLS1kMTZzcw%3D%3D&l=2022082804225201021713510318BCAA8C&btag=80000&cc=3')
      ..initialize().then((_) {
        setState(() {});
      });
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
                  child: InkWell(
                    onTap: _onVideoTapped,
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
                  child: VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                  ),
                ),
              ],
            )
          : const Text('Loading...'),
    );
  }
}
