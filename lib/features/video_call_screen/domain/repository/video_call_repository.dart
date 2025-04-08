abstract class VideoCallRepository {
  Future<void> join();
  Future<void> leave();
  Future<void> muteMic(bool mute);
  Future<void> switchCamera();
  Future<void> enableVideo(bool enable);
}
