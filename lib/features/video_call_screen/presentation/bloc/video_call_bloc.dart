import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:video_calling_app/features/video_call_screen/domain/use_cases/enable_video_use_case.dart';
import 'package:video_calling_app/features/video_call_screen/domain/use_cases/join_channel_use_case.dart';
import 'package:video_calling_app/features/video_call_screen/domain/use_cases/leave_channel_use_case.dart';
import 'package:video_calling_app/features/video_call_screen/domain/use_cases/mute_mic_use_case.dart';
import 'package:video_calling_app/features/video_call_screen/domain/use_cases/switch_camera_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:video_calling_app/features/video_call_screen/presentation/bloc/video_call_event.dart';
import 'video_call_event.dart';
import 'video_call_state.dart';



@injectable
class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  final JoinVideoCallUseCase joinCall;
  final LeaveVideoCallUseCase leaveCall;
  final MuteMicUseCase muteMic;
  final SwitchCameraUseCase switchCamera;
  final EnableVideoUseCase enableVideo;

  VideoCallBloc({
    required this.joinCall,
    required this.leaveCall,
    required this.muteMic,
    required this.switchCamera,
    required this.enableVideo,
  }) : super(VideoCallInitial()) {
    on<JoinCallEvent>((event, emit) async {
      emit(VideoCallInProgress());
      try {
        await joinCall();
        emit(VideoCallJoined());
      } catch (e) {
        emit(VideoCallError(e.toString()));
      }
    });

    on<LeaveCallEvent>((event, emit) async {
      emit(VideoCallInProgress());
      try {
        await leaveCall();
        emit(VideoCallLeft());
      } catch (e) {
        emit(VideoCallError(e.toString()));
      }
    });

    on<MuteMicEvent>((event, emit) async {
      try {
        await muteMic(event.mute);
        emit(VideoCallMicMuted(event.mute));
      } catch (e) {
        emit(VideoCallError(e.toString()));
      }
    });

    on<SwitchCameraEvent>((event, emit) async {
      try {
        await switchCamera();
      } catch (e) {
        emit(VideoCallError(e.toString()));
      }
    });

    on<EnableVideoEvent>((event, emit) async {
      try {
        await enableVideo(event.enable);
        emit(VideoCallVideoToggled(event.enable));
      } catch (e) {
        emit(VideoCallError(e.toString()));
      }
    });
  }
}
