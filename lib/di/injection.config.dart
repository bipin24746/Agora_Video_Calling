// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:agora_rtc_engine/agora_rtc_engine.dart' as _i703;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:video_calling_app/di/injection.dart' as _i885;
import 'package:video_calling_app/features/video_call_screen/data/data_source/video_call_remote_data_source.dart'
    as _i405;
import 'package:video_calling_app/features/video_call_screen/data/repositories_impl/video_call_repo_impl.dart'
    as _i21;
import 'package:video_calling_app/features/video_call_screen/domain/repositories/video_call_repository.dart'
    as _i634;
import 'package:video_calling_app/features/video_call_screen/domain/use_cases/end_call_usecase.dart'
    as _i980;
import 'package:video_calling_app/features/video_call_screen/domain/use_cases/start_video_call_usecase.dart'
    as _i907;
import 'package:video_calling_app/features/video_call_screen/domain/use_cases/toggle_camera_usecase.dart'
    as _i644;
import 'package:video_calling_app/features/video_call_screen/domain/use_cases/toggle_mic_usecase.dart'
    as _i662;
import 'package:video_calling_app/features/video_call_screen/domain/use_cases/toggle_video_usecase.dart'
    as _i272;
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
    gh.factory<_i309.VideoCallBloc>(() => _i309.VideoCallBloc());
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i703.RtcEngine>(() => registerModule.rtcEngine);
    gh.lazySingleton<_i405.VideoCallRemoteDataSource>(
        () => _i405.VideoCallRemoteDataSourceImpl());
    gh.lazySingleton<_i634.VideoCallRepository>(() =>
        _i21.VideoCallRepositoryImpl(gh<_i405.VideoCallRemoteDataSource>()));
    gh.lazySingleton<_i980.EndCallUseCase>(
        () => _i980.EndCallUseCase(gh<_i634.VideoCallRepository>()));
    gh.lazySingleton<_i907.StartVideoCallUseCase>(
        () => _i907.StartVideoCallUseCase(gh<_i634.VideoCallRepository>()));
    gh.lazySingleton<_i644.ToggleVideCallUseCase>(
        () => _i644.ToggleVideCallUseCase(gh<_i634.VideoCallRepository>()));
    gh.lazySingleton<_i662.ToggleMicUseCase>(
        () => _i662.ToggleMicUseCase(gh<_i634.VideoCallRepository>()));
    gh.lazySingleton<_i272.ToggleVideoUseCase>(
        () => _i272.ToggleVideoUseCase(gh<_i634.VideoCallRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i885.RegisterModule {}
