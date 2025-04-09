// video_call_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:injectable/injectable.dart';
import 'video_call_event.dart';
import 'video_call_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_calling_app/constant/constant.dart';

@injectable
class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  late RtcEngine _engine; // Agora engine
  bool _localUserJoined = true;
  int? _remoteUid;


  RtcEngine get engine => _engine;

  VideoCallBloc() : super(VideoCallInitial()) {
    on<StartVideoCall>((event, emit) async {
      await _startVideoCall(emit);
    });
    on<JoinChannel>((event, emit) async {
      await _joinChannel(emit);
    });
    on<RemoteUserJoined>((event, emit) {
      _remoteUid = event.remoteUid;
      _emitInProgressState(emit);
    });
    on<RemoteUserLeft>((event, emit) {
      _remoteUid = null;
      _emitInProgressState(emit);
    });
    on<LeaveChannel>((event, emit) async {
      await _cleanupAgoraEngine(emit);
      emit(VideoCallInitial());
    });
  }

  Future<void> _startVideoCall(Emitter<VideoCallState> emit) async {
    try {
      await _requestPermissions();
      await _initializeAgoraEngine();
      await _setupLocalVideo();
      _emitInProgressState(emit);
    } catch (e) {
      emit(VideoCallError(message: "Error starting video call: $e"));
    }
  }

  Future<void> _joinChannel(Emitter<VideoCallState> emit) async {
    try {
      await _engine.joinChannel(
        token: token,
        channelId: channel,
        options: const ChannelMediaOptions(
          autoSubscribeVideo: true,
          autoSubscribeAudio: true,
          publishCameraTrack: true,
          publishMicrophoneTrack: true,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
        uid: 0,
      );
      _emitInProgressState(emit);
    } catch (e) {
      emit(VideoCallError(message: "Error joining channel: $e"));
    }
  }

  Future<void> _initializeAgoraEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: appId, channelProfile: ChannelProfileType.channelProfileCommunication));
    _setupEventHandlers();
  }

  Future<void> _setupLocalVideo() async {
    await _engine.enableVideo();
    await _engine.startPreview();
  }

  void _setupEventHandlers() {
    _engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        _localUserJoined = true;
        add(RemoteUserJoined(0));
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        add(RemoteUserJoined(remoteUid));
      },
      onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
        add(RemoteUserLeft(remoteUid));
      },
    ));
  }

  Future<void> _requestPermissions() async {
    await [Permission.microphone, Permission.camera].request();
  }

  Future<void> _cleanupAgoraEngine(Emitter<VideoCallState> emit) async {
    try {
      await _engine.leaveChannel();
      await _engine.release();
    } catch (e) {
      emit(VideoCallError(message: "Error cleaning up Agora engine: $e"));
    }
  }

  // Helper function to emit in-progress state
  void _emitInProgressState(Emitter<VideoCallState> emit) {
    emit(VideoCallLoading(localUserJoined: _localUserJoined, remoteUid: _remoteUid));
  }
}
