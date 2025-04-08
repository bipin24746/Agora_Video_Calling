// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:video_calling_app/di/injection.dart' as _i885;
import 'package:video_calling_app/features/video_call_screen/data/data_source/video_call_remote_data_source.dart'
    as _i405;
import 'package:video_calling_app/features/video_call_screen/domain/repository/video_call_repository.dart'
    as _i6;
import 'package:video_calling_app/features/video_call_screen/domain/use_cases/enable_video_use_case.dart'
    as _i849;
import 'package:video_calling_app/features/video_call_screen/domain/use_cases/join_channel_use_case.dart'
    as _i482;
import 'package:video_calling_app/features/video_call_screen/domain/use_cases/leave_channel_use_case.dart'
    as _i688;
import 'package:video_calling_app/features/video_call_screen/domain/use_cases/mute_mic_use_case.dart'
    as _i602;
import 'package:video_calling_app/features/video_call_screen/domain/use_cases/switch_camera_use_case.dart'
    as _i692;
import 'package:video_calling_app/features/video_call_screen/presentation/bloc/video_call_bloc.dart'
    as _i309;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i405.VideoCallDataSource>(
        () => _i405.VideoCallRemoteDataSourceImpl());
    gh.lazySingleton<_i849.EnableVideoUseCase>(
        () => _i849.EnableVideoUseCase(gh<_i6.VideoCallRepository>()));
    gh.lazySingleton<_i482.JoinVideoCallUseCase>(
        () => _i482.JoinVideoCallUseCase(gh<_i6.VideoCallRepository>()));
    gh.lazySingleton<_i688.LeaveVideoCallUseCase>(
        () => _i688.LeaveVideoCallUseCase(gh<_i6.VideoCallRepository>()));
    gh.lazySingleton<_i602.MuteMicUseCase>(
        () => _i602.MuteMicUseCase(gh<_i6.VideoCallRepository>()));
    gh.lazySingleton<_i692.SwitchCameraUseCase>(
        () => _i692.SwitchCameraUseCase(gh<_i6.VideoCallRepository>()));
    gh.factory<_i309.VideoCallBloc>(() => _i309.VideoCallBloc(
          joinCall: gh<_i482.JoinVideoCallUseCase>(),
          leaveCall: gh<_i688.LeaveVideoCallUseCase>(),
          muteMic: gh<_i602.MuteMicUseCase>(),
          switchCamera: gh<_i692.SwitchCameraUseCase>(),
          enableVideo: gh<_i849.EnableVideoUseCase>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i885.RegisterModule {}
