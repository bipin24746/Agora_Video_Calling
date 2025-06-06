import 'package:injectable/injectable.dart';
import 'package:video_calling_app/features/video_call_screen/domain/repositories/video_call_repository.dart';


@lazySingleton
class ToggleMicUseCase {
  final VideoCallRepository repository;

  ToggleMicUseCase(this.repository);

  Future<void> call(bool isMicOn) async {
    await repository.toggleMic(isMicOn);
  }
}
