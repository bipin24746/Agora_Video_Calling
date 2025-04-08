
import 'package:injectable/injectable.dart';
import 'package:video_calling_app/features/video_call_screen/domain/repository/video_call_repository.dart';

@lazySingleton
class SwitchCameraUseCase {
  final VideoCallRepository repository;

  SwitchCameraUseCase(this.repository);

  Future<void> call() async {
    await repository.switchCamera();
  }
}
