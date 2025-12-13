import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/admin_repository.dart';
import '../../../recording/domain/entities/recording.dart';

class GetUserRecordings {
  final AdminRepository repository;

  GetUserRecordings(this.repository);

  Future<Either<Failure, List<Recording>>> call(String userId) async {
    return await repository.getUserRecordings(userId);
  }
}

