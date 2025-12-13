import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../recording/domain/entities/recording.dart';

abstract class AdminRepository {
  /// Get users list - GET /admin/users
  Future<Either<Failure, List<User>>> getUsers({
    String? email,
    int? tierId,
    bool? isActive,
  });

  /// Update user - PATCH /admin/users/:id
  Future<Either<Failure, User>> updateUser({
    required String userId,
    int? tierId,
    bool? isActive,
    String? role,
  });

  /// Get user recordings - GET /admin/users/:id/recordings
  Future<Either<Failure, List<Recording>>> getUserRecordings(String userId);

  /// Get admin recording detail - GET /admin/recordings/:id
  Future<Either<Failure, Recording>> getAdminRecordingDetail(String recordingId);
}

