import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_calling_app/di/injection.dart';
import 'package:video_calling_app/router/app_router.dart';
import 'package:video_calling_app/features/video_call_screen/presentation/bloc/video_call_bloc.dart';

void main() {
  configureDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VideoCallBloc>(
          create: (_) => sl<VideoCallBloc>(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
