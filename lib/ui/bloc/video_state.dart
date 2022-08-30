part of 'video_cubit.dart';

class VideoState extends Equatable {
  final String originalUrl;
  final AsyncData<String> videoUrl;

  const VideoState({
    required this.originalUrl,
    required this.videoUrl,
  });

  const VideoState.initial(this.originalUrl) : videoUrl = const AsyncData.nothing();

  VideoState copyWith({
    String? originalUrl,
    AsyncData<String>? videoUrl,
  }) {
    return VideoState(
      originalUrl: originalUrl ?? this.originalUrl,
      videoUrl: videoUrl ?? this.videoUrl,
    );
  }

  @override
  List<Object> get props => [originalUrl, videoUrl];
}
