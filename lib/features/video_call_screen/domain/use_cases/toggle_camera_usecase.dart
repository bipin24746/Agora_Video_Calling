import 'package:injectable/injectable.dart';
import 'package:video_calling_app/features/video_call_screen/domain/repositories/video_call_repository.dart';

@lazySingleton
class ToggleVideCallUseCase{
  final VideoCallRepository repository;
  ToggleVideCallUseCase(this.repository);

  Future<void> call() async{
    await repository.initAgora();
    await repository.leaveChannel();
  }
}