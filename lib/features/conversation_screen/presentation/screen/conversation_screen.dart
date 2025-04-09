import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:video_calling_app/router/app_router.gr.dart';


@RoutePage()
class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Calling App"),
            Spacer(),
            IconButton(
              onPressed: () {
                AutoRouter.of(context).push(VideoCallScreenRoute());
              },
              icon: Icon(Icons.videocam_rounded),
            ),
            IconButton(
                onPressed: () {
                  AutoRouter.of(context).push(VoiceCallScreenRoute());
                },
                icon: Icon(Icons.call))
          ],
        ),
      ),

    );
  }
}
