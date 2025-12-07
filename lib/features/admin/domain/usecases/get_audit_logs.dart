import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/audit_log.dart';
import '../repositories/audit_log_repository.dart';

class GetAuditLogs {
  final AuditLogRepository repository;

  GetAuditLogs(this.repository);

  Future<Either<Failure, List<AuditLog>>> call({
    String? userId,
    String? resourceType,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    return await repository.getAuditLogs(
      userId: userId,
      resourceType: resourceType,
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );
  }
}

