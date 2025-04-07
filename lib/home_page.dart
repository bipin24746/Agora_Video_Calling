import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_calling_app/constant/constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required String title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    _startVideoCalling();
  }

  //main setup process for initiating the video call
  Future<void> _startVideoCalling() async {
    await _requestPermission();
    await _initializeAgoraVideoSDK();
    await _setupLocalVideo();
    _setupEventHandlers();
    await _joinChannel();
  }

  //initialize the engine for real time communication
  Future<void> _initializeAgoraVideoSDK() async {
    _engine = createAgoraRtcEngine(); //creates an instance of the rtc(real time communication) engine
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
  }

  Future<void> _joinChannel() async {
    await _engine.joinChannel(
      token: token,
      channelId: channel,

      //controls various media settings like auto subscribing to audio video etc
      options: const ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
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
        //This event is triggered when the local user successfully joins the channel
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("Local user ${connection.localUid} joined");
          setState(() => _localUserJoined = true);
        },

        //triggered when a remote user joins the channel
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("Remote user $remoteUid joined");
          setState(() => _remoteUid = remoteUid);
        },

          // triggered when a remote user leaves the channel
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("Remote user $remoteUid left");
          setState(() => _remoteUid = null);
        },
      ),
    );
  }

  Future<void> _setupLocalVideo() async {
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
              RenderModeType.renderModeHidden, // Sets the video rendering mode, this isnot understands
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

  Future<void> _requestPermission() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calling App"),
      ),
      body: Stack(children: [
        Center(
          child: _remoteVideo(),
        ),
        Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              height: 150,
              width: 100,
              child: _localUserJoined
                  ? _localVideo()
                  : Center(child: const CircularProgressIndicator()),
            ))
      ]),
    );
  }
}
