

import 'package:injectable/injectable.dart';
import 'package:video_calling_app/features/video_call_screen/data/data_source/video_call_remote_data_source.dart';
import 'package:video_calling_app/features/video_call_screen/domain/repositories/video_call_repository.dart';


@LazySingleton(as: VideoCallRepository)
class VideoCallRepositoryImpl implements VideoCallRepository {
  final VideoCallRemoteDataSource remoteDataSource;

  VideoCallRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> initAgora() => remoteDataSource.initAgora();

  @override
  Future<void> joinChannel() => remoteDataSource.joinChannel();

  @override
  Future<void> leaveChannel() => remoteDataSource.leaveChannel();

  @override
  Future<void> toggleMic(bool isMicOn) => remoteDataSource.toggleMic(isMicOn);

  @override
  Future<void> toggleVideo(bool isVideoOn) => remoteDataSource.toggleVideo(isVideoOn);

  @override
  Future<void> switchCamera() => remoteDataSource.switchCamera();
}
