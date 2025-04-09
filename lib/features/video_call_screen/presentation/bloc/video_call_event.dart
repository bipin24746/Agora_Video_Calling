part of 'video_call_bloc.dart';



abstract class VideoCallEvent extends Equatable {
  const VideoCallEvent();

  @override
  List<Object?> get props => [];
}



class InitializeCallEvent extends VideoCallEvent {}

class ToggleMicEvent extends VideoCallEvent {}

class ToggleVideoEvent extends VideoCallEvent {}

class SwitchCameraEvent extends VideoCallEvent {}

class EndCallEvent extends VideoCallEvent {}

class RemoteUserJoinedEvent extends VideoCallEvent {
  final int uid;

  const RemoteUserJoinedEvent(this.uid);

  @override
  List<Object?> get props => [uid];
}

class RemoteUserLeftEvent extends VideoCallEvent {
  final int uid;

  const RemoteUserLeftEvent(this.uid);

  @override
  List<Object?> get props => [uid];
}
