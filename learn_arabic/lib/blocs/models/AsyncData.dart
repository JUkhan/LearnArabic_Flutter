enum AsyncStatus { init, loading, error, loaded }

class AsyncData<T> {
  final T data;
  final AsyncStatus asyncStatus;
  final String errorMessage;

  AsyncData({this.data, this.asyncStatus, this.errorMessage});

  factory AsyncData.init(T data) =>
      AsyncData(data: data, asyncStatus: AsyncStatus.init);

  factory AsyncData.loaded(T data) =>
      AsyncData(data: data, asyncStatus: AsyncStatus.loaded);

  factory AsyncData.loading({T data}) =>
      AsyncData(asyncStatus: AsyncStatus.loading, data: data);

  factory AsyncData.error(String errorMessage, {T data}) => AsyncData(
      asyncStatus: AsyncStatus.error, errorMessage: errorMessage, data: data);
}
