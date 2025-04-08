import 'package:equatable/equatable.dart';

abstract class VideoCallState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VideoCallInitial extends VideoCallState {}

class VideoCallInProgress extends VideoCallState {}

class VideoCallJoined extends VideoCallState {}

class VideoCallLeft extends VideoCallState {}

class VideoCallMicMuted extends VideoCallState {
  final bool isMuted;
  VideoCallMicMuted(this.isMuted);

  @override
  List<Object?> get props => [isMuted];
}

class VideoCallVideoToggled extends VideoCallState {
  final bool isVideoOn;
  VideoCallVideoToggled(this.isVideoOn);

  @override
  List<Object?> get props => [isVideoOn];
}

class VideoCallError extends VideoCallState {
  final String message;
  VideoCallError(this.message);

  @override
  List<Object?> get props => [message];
}
