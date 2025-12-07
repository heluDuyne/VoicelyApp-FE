import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/tier.dart';

abstract class TierRepository {
  Future<Either<Failure, Tier>> getTier(int tierId);
  Future<Either<Failure, List<Tier>>> getAllTiers();
  Future<Either<Failure, Tier>> updateTier(Tier tier);
}

