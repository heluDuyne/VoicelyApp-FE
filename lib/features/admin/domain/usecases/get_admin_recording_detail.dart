import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/admin_repository.dart';
import '../../../recording/domain/entities/recording.dart';

class GetAdminRecordingDetail {
  final AdminRepository repository;

  GetAdminRecordingDetail(this.repository);

  Future<Either<Failure, Recording>> call(String recordingId) async {
    return await repository.getAdminRecordingDetail(recordingId);
  }
}

