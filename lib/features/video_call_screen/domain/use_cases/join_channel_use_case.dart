

import 'package:injectable/injectable.dart';
import 'package:video_calling_app/features/video_call_screen/domain/repository/video_call_repository.dart';

@lazySingleton
class JoinVideoCallUseCase {
  final VideoCallRepository repository;

  JoinVideoCallUseCase(this.repository);

  Future<void> call() async {
    await repository.join();
  }
}
