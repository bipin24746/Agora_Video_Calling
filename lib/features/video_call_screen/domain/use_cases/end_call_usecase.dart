import 'package:injectable/injectable.dart';
import 'package:video_calling_app/features/video_call_screen/domain/repositories/video_call_repository.dart';

@lazySingleton
class EndCallUseCase{
  final VideoCallRepository repository;
  EndCallUseCase(this.repository);

  Future<void> call() async{
    await repository.initAgora();
    await repository.leaveChannel();
  }
}