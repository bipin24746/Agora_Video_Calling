import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_calling_app/constant/constant.dart';

abstract class VideoCallRemoteDataSource{
  Future<void> initAgora();
  Future<void> joinChannel();
  Future<void> leaveChannel();
  Future<void> toggleMic(bool isMicOn);
  Future<void> toggleVideo(bool isVideoOn);
  Future<void> switchCamera();
  RtcEngine get engine;
}

@LazySingleton(as: VideoCallRemoteDataSource)
class VideoCallRemoteDataSourceImpl implements VideoCallRemoteDataSource{
  late final RtcEngine _engine;

  @override
  RtcEngine get engine => _engine;

  @override
  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );
    await _engine.enableVideo();
    await _engine.startPreview();
  }

  @override
  Future<void> joinChannel() async {
    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  @override
  Future<void> leaveChannel() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  @override
  Future<void> toggleMic(bool isMicOn) async {
    await _engine.muteLocalAudioStream(!isMicOn);
  }

  @override
  Future<void> toggleVideo(bool isVideoOn) async {
    await _engine.muteLocalVideoStream(!isVideoOn);
    if (isVideoOn) {
      await _engine.startPreview();
    } else {
      await _engine.stopPreview();
    }
  }

  @override
  Future<void> switchCamera() async {
    await _engine.switchCamera();
  }

}