import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/folder.dart';
import '../repositories/transcription_repository.dart';

class GetFolders {
  final TranscriptionRepository repository;

  GetFolders(this.repository);

  Future<Either<Failure, List<Folder>>> call({String? parentFolderId}) async {
    return await repository.getFolders(parentFolderId: parentFolderId);
  }
}

