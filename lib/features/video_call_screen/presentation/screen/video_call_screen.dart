// // video_call_screen.dart
// import 'package:auto_route/annotations.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:video_calling_app/di/injection.dart';
// import 'package:video_calling_app/features/video_call_screen/presentation/bloc/video_call_bloc.dart';
// import 'package:video_calling_app/features/video_call_screen/presentation/bloc/video_call_event.dart';
// import 'package:video_calling_app/features/video_call_screen/presentation/bloc/video_call_state.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:video_calling_app/constant/constant.dart';
//
// @RoutePage()
// class VideoCallScreen extends StatelessWidget {
//   const VideoCallScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => sl<VideoCallBloc>()..add(StartVideoCall()),
//       child: Scaffold(
//         appBar: AppBar(title: const Text("Video Call")),
//         body: BlocBuilder<VideoCallBloc, VideoCallState>(
//           builder: (context, state) {
//             if (state is VideoCallLoading) {
//               return Stack(
//                 children: [
//                   Center(
//                     child: state.remoteUid != null
//                         ? AgoraVideoView(
//                       controller: VideoViewController.remote(
//                         rtcEngine: context.read<VideoCallBloc>().engine,  // Access the engine here
//                         canvas: VideoCanvas(uid: state.remoteUid),
//                         connection: RtcConnection(channelId: channel),
//                       ),
//                     )
//                         : const Text('Waiting for remote user to join...'),
//                   ),
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: SizedBox(
//                       height: 150,
//                       width: 100,
//                       child: state.localUserJoined
//                           ? AgoraVideoView(
//                         controller: VideoViewController(
//                           rtcEngine: context.read<VideoCallBloc>().engine, // Access the engine here
//                           canvas: const VideoCanvas(
//                             uid: 0,
//                             renderMode: RenderModeType.renderModeHidden,
//                           ),
//                         ),
//                       )
//                           : const Center(child: Text("Camera Off")),
//                     ),
//                   ),
//                 ],
//               );
//             } else {
//               return const Center(child: CircularProgressIndicator());
//             }
//           },
//         ),
//
//
//
//       ),
//     );
//   }
// }
