import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiktok_mate/ui/bloc/video_cubit.dart';
import 'package:tiktok_mate/ui/widgets/app_video_player.dart';
import 'package:tiktok_mate/ui/widgets/loading_indicator.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  static const routeName = '/video';

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late bool _isFullscreen;

  @override
  void initState() {
    super.initState();
    _isFullscreen = false;
  }

  void _setFullscreen(bool value) {
    setState(() {
      _isFullscreen = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final originalUrl = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: _isFullscreen ? null : AppBar(title: const Text('Video')),
      body: BlocProvider(
        create: (context) => VideoCubit(originalUrl),
        child: BlocBuilder<VideoCubit, VideoState>(
          builder: (context, state) {
            if (state.videoUrl.isLoading) {
              return const LoadingIndicator(text: 'Processando link...');
            } else if (state.videoUrl.hasData) {
              return AppVideoPlayer(
                videoUrl: state.videoUrl.data!,
                isFullscreen: _isFullscreen,
                setFullscreen: _setFullscreen,
              );
            } else {
              return const Text('Algo deu errado');
            }
          },
        ),
      ),
    );
  }
}
