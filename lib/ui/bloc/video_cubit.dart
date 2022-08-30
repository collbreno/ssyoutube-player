import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiktok_mate/models/async_data.dart';
import 'package:tiktok_mate/services/url_converter.dart';

part 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  final UrlConverter converter;

  VideoCubit(String url)
      : converter = UrlConverter(),
        super(VideoState.initial(url)) {
    _convertUrl();
  }

  void _convertUrl() async {
    emit(state.copyWith(videoUrl: const AsyncData.loading()));
    try {
      final videoUrl = await converter.convert(state.originalUrl);
      emit(state.copyWith(videoUrl: AsyncData.withData(videoUrl)));
    } catch (e) {
      emit(state.copyWith(videoUrl: AsyncData.withError(e)));
    }
  }
}
