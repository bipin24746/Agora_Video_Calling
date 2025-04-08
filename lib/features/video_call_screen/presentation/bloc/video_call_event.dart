import 'package:equatable/equatable.dart';

abstract class VideoCallEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class JoinCallEvent extends VideoCallEvent {}

class LeaveCallEvent extends VideoCallEvent {}

class MuteMicEvent extends VideoCallEvent {
  final bool mute;
  MuteMicEvent(this.mute);

  @override
  List<Object?> get props => [mute];
}

class SwitchCameraEvent extends VideoCallEvent {}

class EnableVideoEvent extends VideoCallEvent {
  final bool enable;
  EnableVideoEvent(this.enable);

  @override
  List<Object?> get props => [enable];
}
