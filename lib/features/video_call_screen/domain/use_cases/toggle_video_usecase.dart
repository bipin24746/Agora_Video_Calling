import 'package:injectable/injectable.dart';
import 'package:video_calling_app/features/video_call_screen/domain/repositories/video_call_repository.dart';

@lazySingleton
class ToggleVideoUseCase {
  final VideoCallRepository repository;

  ToggleVideoUseCase(this.repository);

  Future<void> call(bool isVideoOn) async {
    await repository.toggleVideo(isVideoOn);
  }
}
