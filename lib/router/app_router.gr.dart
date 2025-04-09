// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:video_calling_app/features/conversation_screen/presentation/screen/conversation_screen.dart'
    as _i1;
import 'package:video_calling_app/features/conversation_screen/presentation/screen/voice_call_screen.dart'
    as _i3;
import 'package:video_calling_app/features/video_call_screen/presentation/screen/video_call_screen.dart'
    as _i2;

/// generated route for
/// [_i1.ConversationScreen]
class ConversationScreenRoute extends _i4.PageRouteInfo<void> {
  const ConversationScreenRoute({List<_i4.PageRouteInfo>? children})
    : super(ConversationScreenRoute.name, initialChildren: children);

  static const String name = 'ConversationScreenRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i1.ConversationScreen();
    },
  );
}

/// generated route for
/// [_i2.VideoCallScreen]
class VideoCallScreenRoute extends _i4.PageRouteInfo<void> {
  const VideoCallScreenRoute({List<_i4.PageRouteInfo>? children})
    : super(VideoCallScreenRoute.name, initialChildren: children);

  static const String name = 'VideoCallScreenRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i2.VideoCallScreen();
    },
  );
}

/// generated route for
/// [_i3.VoiceCallScreen]
class VoiceCallScreenRoute extends _i4.PageRouteInfo<void> {
  const VoiceCallScreenRoute({List<_i4.PageRouteInfo>? children})
    : super(VoiceCallScreenRoute.name, initialChildren: children);

  static const String name = 'VoiceCallScreenRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i3.VoiceCallScreen();
    },
  );
}
