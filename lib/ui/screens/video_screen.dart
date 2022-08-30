import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiktok_mate/ui/bloc/video_cubit.dart';
import 'package:tiktok_mate/ui/widgets/app_video_player.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({Key? key}) : super(key: key);

  static const routeName = '/video';

  @override
  Widget build(BuildContext context) {
    final originalUrl = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: const Text('Video')),
      body: BlocProvider(
        create: (context) => VideoCubit(originalUrl),
        child: BlocBuilder<VideoCubit, VideoState>(
          builder: (context, state) {
            if (state.videoUrl.isLoading) {
              return Text('pegando link...');
            }
            else if (state.videoUrl.hasData) {
              return AppVideoPlayer(videoUrl: state.videoUrl.data!);
            }
            else {
              return Text('Algo deu errado');
            }
          },
        ),
      ),
    );
  }
}
