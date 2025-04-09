import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_calling_app/constant/constant.dart';
import 'package:video_calling_app/di/injection.dart';
import 'package:video_calling_app/features/video_call_screen/presentation/bloc/video_call_bloc.dart';
import 'package:video_calling_app/router/app_router.gr.dart';

@RoutePage()
class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool _isMicOn = true;
  bool _isCameraFront = true;
  bool _isVideoOn = false;

  @override
  void initState() {
    super.initState();
    _startVideoCalling();
  }

  // Main setup process for initiating the video call
  Future<void> _startVideoCalling() async {
    await _requestPermissions();
    await _initializeAgoraVoiceSDK();
    await _setupLocalVideo();
    _setupEventHandlers();
    await _joinChannel();
  }

  // Set up the Agora RTC engine instance
  Future<void> _initializeAgoraVoiceSDK() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
  }

  // Join a channel for video calling
  // Join a channel
  Future<void> _joinChannel() async {
    await _engine.joinChannel(
      token: token,
      channelId: channel,
      options: const ChannelMediaOptions(
        autoSubscribeVideo:
            true, // Automatically subscribe to all video streams
        autoSubscribeAudio:
            true, // Automatically subscribe to all audio streams
        publishCameraTrack: true, // Publish camera-captured video
        publishMicrophoneTrack: true, // Publish microphone-captured audio
        // Use clientRoleBroadcaster to act as a host or clientRoleAudience for audience
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
      uid: 0,
    );
  }

  // Register an event handler for Agora RTC
  void _setupEventHandlers() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("Local user ${connection.localUid} joined");
          setState(() => _localUserJoined = true);
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("Remote user $remoteUid joined");
          setState(() => _remoteUid = remoteUid);
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("Remote user $remoteUid left");
          setState(() => _remoteUid = null);
        },
      ),
    );
  }

  Future<void> _setupLocalVideo() async {
    // The video module and preview are disabled by default.
    await _engine.enableVideo();
    await _engine.startPreview();
  }

  // Displays the local user's video view using the Agora engine.
  Widget _localVideo() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine, // Uses the Agora engine instance
        canvas: const VideoCanvas(
          uid: 0, // Specifies the local user
          renderMode:
              RenderModeType.renderModeHidden, // Sets the video rendering mode
        ),
      ),
    );
  }

  // If a remote user has joined, render their video, else display a waiting message
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine, // Uses the Agora engine instance
          canvas: VideoCanvas(uid: _remoteUid), // Binds the remote user's video
          connection:
              const RtcConnection(channelId: channel), // Specifies the channel
        ),
      );
    } else {
      return const Text(
        'Waiting for remote user to join...',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> _requestPermissions() async {
    await [Permission.microphone, Permission.camera].request();
  }

  @override
  void dispose() {
    _cleanupAgoraEngine();
    super.dispose();
  }

  // Leaves the channel and releases resources
  Future<void> _cleanupAgoraEngine() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  // Handle the "End Call" functionality
  Future<void> _endCall() async {
    await _cleanupAgoraEngine(); // Clean up Agora resources
    AutoRouter.of(context).replace(ConversationScreenRoute());
  }

  // Toggle microphone state
  Future<void> _toggleMic() async {
    try {
      if (_isMicOn) {
        await _engine.muteLocalAudioStream(true);
      } else {
        await _engine.muteLocalAudioStream(false);
      }
      setState(() {
        _isMicOn = !_isMicOn;
      });
    } catch (e) {
      print("Error toggling microphone: $e");
    }
  }

  // Switch between front and back camera
  Future<void> _toggleCamera() async {
    try {
      await _engine.switchCamera();
      setState(() {
        _isCameraFront = !_isCameraFront;
      });
    } catch (e) {
      print("Error toggling camera: $e");
    }
  }

  // Toggle local video stream
  Future<void> _toggleVideo() async {
    try {
      if (_isVideoOn) {
        // Turn off video: mute the video stream and stop the preview
        await _engine.muteLocalVideoStream(true);
        await _engine.stopPreview();
        setState(() {
          _localUserJoined = false; // Hide the local user's video
        });
      } else {
        // Turn on video: unmute the video stream and start the preview
        await _engine.muteLocalVideoStream(false);
        await _engine.startPreview();
        setState(() {
          _localUserJoined = true; // Show the local user's video again
        });
      }

      setState(() {
        _isVideoOn = !_isVideoOn;
      });
    } catch (e) {
      print("Error toggling video: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<VideoCallBloc>(),
      child: BlocBuilder<VideoCallBloc, VideoCallState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Video Call"),
            ),
            body: Stack(
              children: [
                Center(
                  child: _remoteVideo(),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    height: 150,
                    width: 100,
                    child: _localUserJoined
                        ? _localVideo() // Only show the local video if it's on
                        : const Center(child: Text("Camera Off")),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all()),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: _toggleVideo, // Toggle video stream
                        child: Icon(
                          _isVideoOn ? Icons.videocam : Icons.videocam_off,
                          color: _isVideoOn ? Colors.black : Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        // onTap: _toggleMic, // Toggle mic state
                        // context.read<VideoCallBloc>().add(SwitchCameraEvent());
                        onTap: (){
                          context.read<VideoCallBloc>().add(ToggleMicEvent());
                        },
                        child: BlocBuilder<VideoCallBloc, VideoCallState>(
                          builder: (context, state) {
                            return Icon(
                              _isMicOn ? Icons.mic : Icons.mic_off,
                              color: _isMicOn ? Colors.black : Colors.grey,
                            );
                          },
                        ),
                      ),
                      // Hide the camera toggle button if video is off
                      if (_isVideoOn)
                        GestureDetector(
                          onTap: _toggleCamera, // Toggle front/back camera
                          child: Icon(
                            _isCameraFront
                                ? Icons.camera_front
                                : Icons.camera_rear,
                          ),
                        ),
                      GestureDetector(
                        onTap: _endCall, // End the call
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              Icons.call_end,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
