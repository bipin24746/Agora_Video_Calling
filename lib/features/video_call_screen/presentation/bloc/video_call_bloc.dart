

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:video_calling_app/features/video_call_screen/domain/entities/video_call_user_entity.dart';
import 'package:video_calling_app/features/video_call_screen/domain/use_cases/end_call_usecase.dart';
import 'package:video_calling_app/features/video_call_screen/domain/use_cases/start_video_call_usecase.dart';
import 'package:video_calling_app/features/video_call_screen/domain/use_cases/toggle_camera_usecase.dart';
import 'package:video_calling_app/features/video_call_screen/domain/use_cases/toggle_mic_usecase.dart';
import 'package:video_calling_app/features/video_call_screen/domain/use_cases/toggle_video_usecase.dart';
import 'package:video_calling_app/features/video_call_screen/domain/entities/video_call_user_entity.dart';

part 'video_call_event.dart';
part 'video_call_state.dart';


@injectable
class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  final StartVideoCallUseCase startVideoCallUseCase;
  final EndCallUseCase endCallUseCase;
  final ToggleMicUseCase toggleMicUseCase;
  final ToggleVideCallUseCase toggleCameraUseCase;
  final ToggleVideoUseCase toggleVideoUseCase;

  VideoCallBloc({
    required this.startVideoCallUseCase,
    required this.endCallUseCase,
    required this.toggleMicUseCase,
    required this.toggleCameraUseCase,
    required this.toggleVideoUseCase,
  }) : super(const VideoCallState()) {
    on<InitializeCallEvent>(_onInitializeCall);
    on<EndCallEvent>(_onEndCall);
    on<ToggleMicEvent>(_onToggleMic);
    on<ToggleVideoEvent>(_onToggleVideo);
    on<SwitchCameraEvent>(_onSwitchCamera);
    on<RemoteUserJoinedEvent>(_onRemoteUserJoined);
    on<RemoteUserLeftEvent>(_onRemoteUserLeft);
  }

  Future<void> _onInitializeCall(
      InitializeCallEvent event, Emitter<VideoCallState> emit) async {
    await startVideoCallUseCase.call();
    emit(VideoCallState(
      isMicOn: true,
      isVideoOn: false,
      isCameraFront: true,
      localUserJoined: true,
    ));
  }

  Future<void> _onEndCall(
      EndCallEvent event, Emitter<VideoCallState> emit) async {
    await endCallUseCase.call();
    emit(const VideoCallState());
  }

  Future<void> _onToggleMic(
      ToggleMicEvent event, Emitter<VideoCallState> emit) async {
    // Toggle mic status
    final newMicStatus = !state.isMicOn;

    // Call the use case to toggle the mic
    await toggleMicUseCase.call(newMicStatus);

    // Emit the updated state
    emit(VideoCallState(
      isMicOn: newMicStatus,  // Updated mic status
      isVideoOn: state.isVideoOn,
      isCameraFront: state.isCameraFront,
      localUserJoined: state.localUserJoined,
      remoteUser: state.remoteUser,
    ));
  }


  Future<void> _onToggleVideo(
      ToggleVideoEvent event, Emitter<VideoCallState> emit) async {
    final newVideoStatus = !state.isVideoOn;
    await toggleVideoUseCase.call(newVideoStatus);
    emit(VideoCallState(
      isMicOn: state.isMicOn,
      isVideoOn: newVideoStatus,
      isCameraFront: state.isCameraFront,
      localUserJoined: state.localUserJoined,
      remoteUser: state.remoteUser,
    ));
  }

  Future<void> _onSwitchCamera(
      SwitchCameraEvent event, Emitter<VideoCallState> emit) async {
    final newCameraDirection = !state.isCameraFront;
    await toggleCameraUseCase.call();
    emit(VideoCallState(
      isMicOn: state.isMicOn,
      isVideoOn: state.isVideoOn,
      isCameraFront: newCameraDirection,
      localUserJoined: state.localUserJoined,
      remoteUser: state.remoteUser,
    ));
  }

  void _onRemoteUserJoined(
      RemoteUserJoinedEvent event, Emitter<VideoCallState> emit) {
    final remoteUser = VideoCallUserEntity(uid: event.uid);
    emit(VideoCallState(
      isMicOn: state.isMicOn,
      isVideoOn: state.isVideoOn,
      isCameraFront: state.isCameraFront,
      localUserJoined: state.localUserJoined,
      remoteUser: remoteUser,
    ));
  }

  void _onRemoteUserLeft(
      RemoteUserLeftEvent event, Emitter<VideoCallState> emit) {
    emit(VideoCallState(
      isMicOn: state.isMicOn,
      isVideoOn: state.isVideoOn,
      isCameraFront: state.isCameraFront,
      localUserJoined: state.localUserJoined,
      remoteUser: null,
    ));
  }
}
