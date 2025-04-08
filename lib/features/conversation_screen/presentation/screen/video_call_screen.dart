// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:auto_route/annotations.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:video_calling_app/constant/constant.dart';
// import 'package:video_calling_app/router/app_router.gr.dart';
//
// @RoutePage()
// class VideoCallScreen extends StatefulWidget {
//   const VideoCallScreen({super.key});
//
//   @override
//   State<VideoCallScreen> createState() => _VideoCallScreenState();
// }
//
// class _VideoCallScreenState extends State<VideoCallScreen> {
//   int? _remoteUid;
//   bool _localUserJoined = false;
//   late RtcEngine _engine;
//   bool _isMicOn = true;
//   bool _isCameraFront = true;
//   bool _isVideoOn = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _startVideoCalling();
//   }
//
//   // Main setup process for initiating the video call
//   Future<void> _startVideoCalling() async {
//     await _requestPermission(); // Request camera and microphone permissions
//     await _initializeAgoraVideoSDK(); // Initialize Agora SDK
//     await _setupLocalVideo(); // Set up local video feed
//     _setupEventHandlers(); // Register event handlers
//     await _joinChannel(); // Join the video call channel
//   }
//
//   // Initialize the Agora RTC engine
//   Future<void> _initializeAgoraVideoSDK() async {
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(RtcEngineContext(
//       appId: appId, // Ensure your Agora app ID is correct
//       channelProfile: ChannelProfileType.channelProfileCommunication,
//     ));
//   }
//
//   // Join a channel for video calling
//   Future<void> _joinChannel() async {
//     await _engine.joinChannel(
//       token: token,
//       channelId: channel,
//       options: const ChannelMediaOptions(
//         autoSubscribeAudio: true,
//         autoSubscribeVideo: true,
//         publishCameraTrack: true,
//         publishMicrophoneTrack: true,
//         clientRoleType: ClientRoleType.clientRoleBroadcaster,
//       ),
//       uid: 0,
//     );
//   }
//
//   // Set up event handlers for Agora RTC events
//   void _setupEventHandlers() {
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           setState(() => _localUserJoined = true);
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           setState(() => _remoteUid = remoteUid);
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           setState(() => _remoteUid = null);
//         },
//       ),
//     );
//   }
//
//   // Set up the local video preview
//   Future<void> _setupLocalVideo() async {
//     await _engine.enableVideo();
//     await _engine.startPreview();
//   }
//
//   // Display the local user's video only if the video is on
//   Widget _localVideo() {
//     if (!_isVideoOn) {
//       // When video is off, do not show local user's video feed
//       return const SizedBox.shrink();
//     } else {
//       return AgoraVideoView(
//         controller: VideoViewController(
//           rtcEngine: _engine,
//           canvas: const VideoCanvas(
//             uid: 0, // Local user's UID
//             renderMode: RenderModeType.renderModeHidden, // Render hidden, don't show self-video
//           ),
//         ),
//       );
//     }
//   }
//
//   // Display remote user's video if available
//   Widget _remoteVideo() {
//     if (_remoteUid != null) {
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: _engine,
//           canvas: VideoCanvas(uid: _remoteUid),
//           connection: const RtcConnection(channelId: channel),
//         ),
//       );
//     } else {
//       return const Center(
//         child: Text('Waiting for remote user to join...'),
//       );
//     }
//   }
//
//   // Request permissions for microphone and camera
//   Future<void> _requestPermission() async {
//     await [Permission.microphone, Permission.camera].request();
//   }
//
//   @override
//   void dispose() {
//     _cleanupAgoraEngine();
//     super.dispose();
//   }
//
//   // Leave the channel and clean up Agora resources
//   Future<void> _cleanupAgoraEngine() async {
//     await _engine.leaveChannel();
//     await _engine.release();
//   }
//
//   // Handle the "End Call" functionality
//   Future<void> _endCall() async {
//     await _cleanupAgoraEngine(); // Clean up Agora resources
//     AutoRouter.of(context).replace(ConversationScreenRoute());
//   }
//
//   // Toggle microphone state
//   Future<void> _toggleMic() async {
//     if (_isMicOn) {
//       await _engine.muteLocalAudioStream(true);
//     } else {
//       await _engine.muteLocalAudioStream(false);
//     }
//     setState(() {
//       _isMicOn = !_isMicOn;
//     });
//   }
//
//   // Switch between front and back camera
//   Future<void> _toggleCamera() async {
//     await _engine.switchCamera();
//     setState(() {
//       _isCameraFront = !_isCameraFront;
//     });
//   }
//
//   // Toggle local video stream
//   Future<void> _toggleVideo() async {
//     if (_isVideoOn) {
//       // Turn off video: mute the video stream and stop the preview
//       await _engine.muteLocalVideoStream(true);
//       await _engine.stopPreview();
//       setState(() {
//         _localUserJoined = false; // Hide the local user's video
//       });
//     } else {
//       // Turn on video: unmute the video stream and start the preview
//       await _engine.muteLocalVideoStream(false);
//       await _engine.startPreview();
//       setState(() {
//         _localUserJoined = true; // Show the local user's video again
//       });
//     }
//
//     setState(() {
//       _isVideoOn = !_isVideoOn;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Video Call"),
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: _remoteVideo(),
//           ),
//           Align(
//             alignment: Alignment.topRight,
//             child: SizedBox(
//               height: 150,
//               width: 100,
//               child: _localUserJoined
//                   ? _localVideo() // Only show the local video if it's on
//                   : const Center(child: Text("Camera Off")),
//             ),
//           ),
//         ],
//       ),
//       // Add a BottomAppBar with an End Call button
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Container(
//           height: 70,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(50), border: Border.all()),
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 GestureDetector(
//                   onTap: _toggleVideo, // Toggle video stream
//                   child: Icon(
//                     _isVideoOn ? Icons.videocam : Icons.videocam_off,
//                     color: _isVideoOn ? Colors.black : Colors.grey,
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: _toggleMic, // Toggle mic state
//                   child: Icon(
//                     _isMicOn ? Icons.mic : Icons.mic_off,
//                     color: _isMicOn ? Colors.black : Colors.grey,
//                   ),
//                 ),
//                 // Hide the camera toggle button if video is off
//                 if (_isVideoOn)
//                   GestureDetector(
//                     onTap: _toggleCamera, // Toggle front/back camera
//                     child: Icon(
//                       _isCameraFront ? Icons.camera_front : Icons.camera_rear,
//                     ),
//                   ),
//                 GestureDetector(
//                   onTap: _endCall, // End the call
//                   child: SizedBox(
//                     height: 50,
//                     width: 50,
//                     child: DecoratedBox(
//                       decoration: BoxDecoration(
//                         color: Colors.red,
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                       child: const Icon(
//                         Icons.call_end,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
