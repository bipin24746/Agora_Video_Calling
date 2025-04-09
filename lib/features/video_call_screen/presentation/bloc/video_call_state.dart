part of 'video_call_bloc.dart';

class VideoCallState extends Equatable {
  final bool isMicOn;
  final bool isVideoOn;
  final bool isCameraFront;
  final bool localUserJoined;
  final VideoCallUserEntity? remoteUser;

  const VideoCallState({
    this.isMicOn = true,
    this.isVideoOn = false,
    this.isCameraFront = true,
    this.localUserJoined = false,
    this.remoteUser,
  });

  @override
  List<Object?> get props => [
    isMicOn,
    isVideoOn,
    isCameraFront,
    localUserJoined,
    remoteUser,
  ];
}
