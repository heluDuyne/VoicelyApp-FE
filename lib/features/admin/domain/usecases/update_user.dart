import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/admin_repository.dart';
import '../../../auth/domain/entities/user.dart';

class UpdateUser {
  final AdminRepository repository;

  UpdateUser(this.repository);

  Future<Either<Failure, User>> call({
    required String userId,
    int? tierId,
    bool? isActive,
    String? role,
  }) async {
    return await repository.updateUser(
      userId: userId,
      tierId: tierId,
      isActive: isActive,
      role: role,
    );
  }
}

