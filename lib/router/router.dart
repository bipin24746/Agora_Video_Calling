part of 'app_router.dart';

@AutoRouterConfig(replaceInRouteName: 'page')
class AppRouter extends RootStackRouter {
  RouteType get defaultRouterType => RouteType.adaptive();

  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: ConversationScreenRoute.page, path: '/'),
    AutoRoute(page: VideoCallScreenRoute.page),
    AutoRoute(page: VoiceCallScreenRoute.page)
  ];
}
