

import 'package:injectable/injectable.dart';
import 'package:video_calling_app/features/video_call_screen/domain/repository/video_call_repository.dart';

@lazySingleton
class EnableVideoUseCase {
  final VideoCallRepository repository;

  EnableVideoUseCase(this.repository);

  Future<void> call(bool enable) async {
    await repository.enableVideo(enable);
  }
}
