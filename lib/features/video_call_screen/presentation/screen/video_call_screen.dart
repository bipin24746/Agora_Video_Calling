// import 'package:auto_route/annotations.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/video_call_bloc.dart';
// import '../bloc/video_call_event.dart';
// import '../bloc/video_call_state.dart';
// import 'package:video_calling_app/di/injection.dart'; // sl from DI
//
// @RoutePage()
// class VideoCallScreen extends StatefulWidget {
//   const VideoCallScreen({Key? key}) : super(key: key);
//
//   @override
//   State<VideoCallScreen> createState() => _VideoCallScreenState();
// }
//
// class _VideoCallScreenState extends State<VideoCallScreen> {
//   bool isMuted = false;
//   bool isVideoEnabled = true;
//
//
//   // @override
//   // void initState(){
//   //   super.initState();
//   //   sl<VideoCallBloc>().add(JoinCallEvent());
//   // }
//
//   @override
//   void dispose() {
//     context.read<VideoCallBloc>().add(LeaveCallEvent());
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: BlocProvider(
//         create: (_) => sl<VideoCallBloc>(),
//         child: BlocBuilder<VideoCallBloc, VideoCallState>(
//           builder: (context, state) {
//             if (state is VideoCallError) {
//               // Show error message using SnackBar
//               Future.delayed(Duration.zero, () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text(state.message)),
//                 );
//               });
//             }
//
//             return Stack(
//               children: [
//                 const Center(
//                   child: Text(
//                     'Remote/Local Video View',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 24,
//                   left: 24,
//                   right: 24,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       _circleButton(
//                         icon: isMuted ? Icons.mic_off : Icons.mic,
//                         onTap: () {
//                           setState(() => isMuted = !isMuted);
//                           context.read<VideoCallBloc>().add(MuteMicEvent(isMuted));
//                         },
//                       ),
//                       _circleButton(
//                         icon: Icons.call_end,
//                         color: Colors.red,
//                         onTap: () {
//                           context.read<VideoCallBloc>().add(LeaveCallEvent());
//                           Navigator.of(context).pop(); // Exit screen
//                         },
//                       ),
//                       _circleButton(
//                         icon: Icons.cameraswitch,
//                         onTap: () {
//                           context.read<VideoCallBloc>().add(SwitchCameraEvent());
//                         },
//                       ),
//                       _circleButton(
//                         icon: isVideoEnabled ? Icons.videocam : Icons.videocam_off,
//                         onTap: () {
//                           setState(() => isVideoEnabled = !isVideoEnabled);
//                           context.read<VideoCallBloc>().add(EnableVideoEvent(isVideoEnabled));
//                         },
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _circleButton({
//     required IconData icon,
//     required VoidCallback onTap,
//     Color color = Colors.white,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: CircleAvatar(
//         backgroundColor: Colors.grey.shade800,
//         radius: 26,
//         child: Icon(icon, color: color),
//       ),
//     );
//   }
// }
