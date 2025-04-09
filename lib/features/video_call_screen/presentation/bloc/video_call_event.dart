abstract class VideoCallEvent {}

class StartVideoCall extends VideoCallEvent {}

class JoinChannel extends VideoCallEvent {}

class LeaveChannel extends VideoCallEvent {}

class RemoteUserJoined extends VideoCallEvent {
  final int remoteUid;
  RemoteUserJoined(this.remoteUid);
}

class RemoteUserLeft extends VideoCallEvent {
  final int remoteUid;
  RemoteUserLeft(this.remoteUid);
}
