abstract class VideoCallRepository{
  Future<void> initAgora();
  Future<void> joinChannel();
  Future<void> leaveChannel();
  Future<void> toggleMic(bool isMicOn);
  Future<void> toggleVideo(bool isVideoOn);
  Future<void> switchCamera();
}