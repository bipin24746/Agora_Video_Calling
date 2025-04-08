// import 'package:injectable/injectable.dart';
// import 'package:video_calling_app/features/video_call_screen/data/data_source/video_call_remote_data_source.dart';
// import 'package:video_calling_app/features/video_call_screen/domain/repository/video_call_repository.dart';
//
// @LazySingleton(as: VideoCallRepository)
// class VideoCallRepositoryImpl implements VideoCallRepository {
//   final VideoCallDataSource dataSource;
//
//   VideoCallRepositoryImpl(this.dataSource);
//
//   @override
//   Future<void> join() => dataSource.join();
//
//   @override
//   Future<void> leave() => dataSource.leave();
//
//   @override
//   Future<void> muteMic(bool mute) => dataSource.muteMic(mute);
//
//   @override
//   Future<void> enableVideo(bool enable) => dataSource.enableVideo(enable);
//
//   @override
//   Future<void> switchCamera() => dataSource.switchCamera();
// }
