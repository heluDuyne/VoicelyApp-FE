import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../recording/domain/entities/recording.dart';
import '../datasources/admin_remote_data_source.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final AuthLocalDataSource authLocalDataSource;

  AdminRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, List<User>>> getUsers({
    String? email,
    int? tierId,
    bool? isActive,
  }) async {
    final token = await authLocalDataSource.getAccessToken();
    if (token == null) {
      return const Left(UnauthorizedFailure('Please login to get users'));
    }

    if (await networkInfo.isConnected) {
      try {
        final userModels = await remoteDataSource.getUsers(
          email: email,
          tierId: tierId,
          isActive: isActive,
        );
        return Right(userModels);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to get users: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> updateUser({
    required String userId,
    int? tierId,
    bool? isActive,
    String? role,
  }) async {
    final token = await authLocalDataSource.getAccessToken();
    if (token == null) {
      return const Left(UnauthorizedFailure('Please login to update user'));
    }

    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.updateUser(
          userId: userId,
          tierId: tierId,
          isActive: isActive,
          role: role,
        );
        return Right(userModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to update user: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Recording>>> getUserRecordings(String userId) async {
    final token = await authLocalDataSource.getAccessToken();
    if (token == null) {
      return const Left(UnauthorizedFailure('Please login to get user recordings'));
    }

    if (await networkInfo.isConnected) {
      try {
        final recordingModels = await remoteDataSource.getUserRecordings(userId);
        return Right(recordingModels);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to get user recordings: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Recording>> getAdminRecordingDetail(String recordingId) async {
    final token = await authLocalDataSource.getAccessToken();
    if (token == null) {
      return const Left(UnauthorizedFailure('Please login to get recording detail'));
    }

    if (await networkInfo.isConnected) {
      try {
        final recordingModel = await remoteDataSource.getAdminRecordingDetail(recordingId);
        return Right(recordingModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to get admin recording detail: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}

