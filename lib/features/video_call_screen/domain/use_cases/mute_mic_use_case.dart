

import 'package:injectable/injectable.dart';
import 'package:video_calling_app/features/video_call_screen/domain/repository/video_call_repository.dart';

@lazySingleton
class MuteMicUseCase {
  final VideoCallRepository repository;

  MuteMicUseCase(this.repository);

  Future<void> call(bool mute) async {
    await repository.muteMic(mute);
  }
}
