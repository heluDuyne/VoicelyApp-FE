import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/transcription_repository.dart';

class DeleteFolder {
  final TranscriptionRepository repository;

  DeleteFolder(this.repository);

  Future<Either<Failure, void>> call(String folderId) async {
    return await repository.deleteFolder(folderId);
  }
}

