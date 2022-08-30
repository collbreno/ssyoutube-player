import 'package:equatable/equatable.dart';

class AsyncData<T> extends Equatable {
  final AsyncDataStatus status;
  final T? data;
  final Object? error;

  const AsyncData.loading()
      : status = AsyncDataStatus.loading,
        data = null,
        error = null;

  const AsyncData.withData(this.data)
      : status = AsyncDataStatus.done,
        error = null;

  const AsyncData.withError(this.error)
      : status = AsyncDataStatus.done,
        data = null;

  const AsyncData.nothing()
      : status = AsyncDataStatus.none,
        data = null,
        error = null;

  bool get hasError => error != null;

  bool get hasData => data != null;

  bool get isLoading => status == AsyncDataStatus.loading;

  @override
  List<Object?> get props => [status, data, error];
}

enum AsyncDataStatus {
  none,
  loading,
  done,
}
