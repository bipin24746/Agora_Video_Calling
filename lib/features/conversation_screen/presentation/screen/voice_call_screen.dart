import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_calling_app/constant/constant.dart';
import 'package:video_calling_app/router/app_router.gr.dart';

@RoutePage()
class VoiceCallScreen extends StatefulWidget {
  const VoiceCallScreen({super.key});

  @override
  State<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool _isMicOn = true;
  bool _isOnSpeaker = false;

  @override
  void initState() {
    super.initState();
    _startVoiceCalling();
  }

  // Main setup process for initiating the voice call
  Future<void> _startVoiceCalling() async {
    await _requestPermission(); // Request microphone permission
    await _initializeAgoraVoiceSDK(); // Initialize Agora SDK
    _setupEventHandlers(); // Register event handlers
    await _joinChannel(); // Join the voice call channel
  }

  // Initialize the Agora RTC engine for voice call
  Future<void> _initializeAgoraVoiceSDK() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: appId, // Ensure your Agora app ID is correct
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
  }

  // Join a channel
  Future<void> _joinChannel() async {
    await _engine.joinChannel(
      token: token,
      channelId: channel,
      options: const ChannelMediaOptions(
        autoSubscribeAudio: true, // Automatically subscribe to all audio streams
        publishMicrophoneTrack: true, // Publish microphone-captured audio
        // Use clientRoleBroadcaster to act as a host or clientRoleAudience for audience
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
      uid: 0,
    );
  }

  // Set up event handlers for Agora RTC events
  void _setupEventHandlers() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() => _localUserJoined = true);
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() => _remoteUid = remoteUid);
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          setState(() => _remoteUid = null);
        },
      ),
    );
  }

  // Request permissions for microphone
  Future<void> _requestPermission() async {
    await [Permission.microphone].request();
  }

  @override
  void dispose() {
    _cleanupAgoraEngine();
    super.dispose();
  }

  // Leave the channel and clean up Agora resources
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
    if (_isMicOn) {
      await _engine.muteLocalAudioStream(true);
    } else {
      await _engine.muteLocalAudioStream(false);
    }
    setState(() {
      _isMicOn = !_isMicOn;
    });
  }

  // Toggle speakerphone state
  Future<void> _toggleSpeaker() async {
    if (_isOnSpeaker) {
      // Set speaker to normal (earpiece mode)
      await _engine.setEnableSpeakerphone(false);
      setState(() {
        _isOnSpeaker = false; // Update state to indicate speaker is now off
      });
    } else {
      // Set speaker to loud (speakerphone mode)
      await _engine.setEnableSpeakerphone(true);
      setState(() {
        _isOnSpeaker = true; // Update state to indicate speaker is now on
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voice Call"),
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteUid == null
                ? const Center(child: Text('Waiting for remote user to join...'))
                : const SizedBox.shrink(), // Display a message or empty widget
          ),
        ],
      ),
      // Add a BottomAppBar with an End Call button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), border: Border.all()),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: _toggleMic, // Toggle mic state
                  child: Icon(
                    _isMicOn ? Icons.mic : Icons.mic_off,
                    color: _isMicOn ? Colors.black : Colors.grey,
                  ),
                ),
                GestureDetector(

                  onTap: _toggleSpeaker, // Toggle speaker state
                  child: Icon(


                    _isOnSpeaker ? Icons.speaker : Icons.speaker_group,
                    color: _isOnSpeaker ? Colors.black : Colors.grey,
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
  }
}
