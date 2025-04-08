import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:injectable/injectable.dart';

abstract class VideoCallDataSource {
  Future<void> initialize();
  Future<void> join();
  Future<void> leave();
  Future<void> muteMic(bool mute);
  Future<void> enableVideo(bool enable);
  Future<void> switchCamera();
}

@LazySingleton(as: VideoCallDataSource)
class VideoCallRemoteDataSourceImpl implements VideoCallDataSource {
  static const String appId = "87d0d177403944578e53b56b14ae2adf";
  static const String token =
      "007eJxTYJi8/Pa6tjUS24KOZVV4/ma68PCrlXbjqyus28J32lxJ8XdQYLAwTzFIMTQ3NzEwtjQxMTW3SDU1TjI1SzI0SUw1SkxJ+136Ob0hkJHhK/s0FkYGCATxeRjSMouKS5IzEvPyUnMYGAD6ASTX";
  static const String channelName = 'firstchannel';

  RtcEngine? _engine;

  bool get _isInitialized => _engine != null;

  @override
  Future<void> initialize() async {
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(appId: appId));

    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print('✅ Local user joined: ${connection.localUid}');
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print('👤 Remote user joined: $remoteUid');
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          print('❌ Remote user left: $remoteUid');
        },
      ),
    );

    await _engine!.enableVideo();
    await _engine!.startPreview();
  }

  void _checkInitialization() {
    if (!_isInitialized) {
      throw Exception("Agora engine is not initialized. Call initialize() first.");
    }
  }

  @override
  Future<void> join() async {
    _checkInitialization();
    await _engine!.joinChannel(
      token: token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  Future<void> leave() async {
    _checkInitialization();
    await _engine!.leaveChannel();
  }

  @override
  Future<void> muteMic(bool mute) async {
    _checkInitialization();
    await _engine!.muteLocalAudioStream(mute);
  }

  @override
  Future<void> enableVideo(bool enable) async {
    _checkInitialization();
    if (enable) {
      await _engine!.enableVideo();
      await _engine!.startPreview();
    } else {
      await _engine!.disableVideo();
    }
  }

  @override
  Future<void> switchCamera() async {
    _checkInitialization();
    await _engine!.switchCamera();
  }
}
