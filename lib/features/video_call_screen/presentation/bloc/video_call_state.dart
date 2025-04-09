abstract class VideoCallState {}

class VideoCallInitial extends VideoCallState {}

class VideoCallLoading extends VideoCallState {
  final bool localUserJoined;
  final int? remoteUid;
  VideoCallLoading({required this.localUserJoined, this.remoteUid});
}

class VideoCallLoaded extends VideoCallState{}

class VideoCallError extends VideoCallState {
  final String message;
  VideoCallError({required this.message});
}
