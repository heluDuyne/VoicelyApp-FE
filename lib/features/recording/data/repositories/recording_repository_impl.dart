import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../domain/entities/recording.dart';
import '../../domain/entities/marker.dart';
import '../../domain/entities/recording_tag.dart';
import '../../domain/repositories/recording_repository.dart';
import '../datasources/recording_local_data_source.dart';
import '../datasources/recording_remote_data_source.dart';

class RecordingRepositoryImpl implements RecordingRepository {
  final RecordingLocalDataSource localDataSource;
  final RecordingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final AuthLocalDataSource authLocalDataSource;

  RecordingRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, void>> startRecording() async {
    try {
      await localDataSource.startRecording();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Recording>> stopRecording() async {
    try {
      final recording = await localDataSource.stopRecording();
      return Right(recording);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> pauseRecording() async {
    try {
      await localDataSource.pauseRecording();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resumeRecording() async {
    try {
      await localDataSource.resumeRecording();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, File>> importAudioFile() async {
    try {
      final file = await localDataSource.importAudioFile();
      return Right(file);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  LocalRecordingState getRecordingStatus() {
    return localDataSource.getRecordingStatus();
  }

  @override
  Stream<Duration> get durationStream => localDataSource.durationStream;

  // API-based methods
  @override
  Future<Either<Failure, Recording>> createRecording({
    required String? folderId,
    required String title,
    required String sourceType,
  }) async {
    final token = await authLocalDataSource.getAccessToken();
    if (token == null) {
      return const Left(
        UnauthorizedFailure('Please login to create recording'),
      );
    }

    if (await networkInfo.isConnected) {
      try {
        final recording = await remoteDataSource.createRecording(
          folderId: folderId,
          title: title,
          sourceType: sourceType,
        );
        return Right(recording);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to create recording: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Recording>> completeUpload({
    required String recordingId,
    required String filePath,
    required double fileSizeMb,
    required double durationSeconds,
    required String originalFileName,
  }) async {
    final token = await authLocalDataSource.getAccessToken();
    if (token == null) {
      return const Left(UnauthorizedFailure('Please login to complete upload'));
    }

    if (await networkInfo.isConnected) {
      try {
        final recording = await remoteDataSource.completeUpload(
          recordingId: recordingId,
          filePath: filePath,
          fileSizeMb: fileSizeMb,
          durationSeconds: durationSeconds,
          originalFileName: originalFileName,
        );
        return Right(recording);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to complete upload: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Recording>>> getRecordings({
    String? folderId,
    bool? isTrashed,
    String? search,
    String? tag,
    int? page,
    int? pageSize,
  }) async {
    final token = await authLocalDataSource.getAccessToken();
    if (token == null) {
      return const Left(UnauthorizedFailure('Please login to get recordings'));
    }

    if (await networkInfo.isConnected) {
      try {
        final recordings = await remoteDataSource.getRecordings(
          folderId: folderId,
          isTrashed: isTrashed,
          search: search,
          tag: tag,
          page: page,
          pageSize: pageSize,
        );
        return Right(recordings);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to get recordings: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Recording>> getRecordingDetail(
    String recordingId,
  ) async {
    final token = await authLocalDataSource.getAccessToken();
    if (token == null) {
      return const Left(
        UnauthorizedFailure('Please login to get recording detail'),
      );
    }

    if (await networkInfo.isConnected) {
      try {
        final recording = await remoteDataSource.getRecordingDetail(
          recordingId,
        );
        return Right(recording);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to get recording detail: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Recording>> updateRecording({
    required String recordingId,
    String? title,
    String? folderId,
    bool? isPinned,
    double? lastPlayPosition,
  }) async {
    final token = await authLocalDataSource.getAccessToken();
    if (token == null) {
      return const Left(
        UnauthorizedFailure('Please login to update recording'),
      );
    }

    if (await networkInfo.isConnected) {
      try {
        final recording = await remoteDataSource.updateRecording(
          recordingId: recordingId,
          title: title,
          folderId: folderId,
          isPinned: isPinned,
          lastPlayPosition: lastPlayPosition,
        );
        return Right(recording);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to update recording: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> softDeleteRecording(String recordingId) async {
    final token = await authLocalDataSource.getAccessToken();
    if (token == null) {
      return const Left(
        UnauthorizedFailure('Please login to delete recording'),
      );
    }

    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.softDeleteRecording(recordingId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to soft delete recording: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Recording>> restoreRecording(
    String recordingId,
  ) async {
    final token = await authLocalDataSource.getAccessToken();
    if (token == null) {
      return const Left(
        UnauthorizedFailure('Please login to restore recording'),
      );
    }

    if (await networkInfo.isConnected) {
      try {
        final recording = await remoteDataSource.restoreRecording(recordingId);
        return Right(recording);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to restore recording: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> hardDeleteRecording(String recordingId) async {
    final token = await authLocalDataSource.getAccessToken();
    if (token == null) {
      return const Left(
        UnauthorizedFailure('Please login to delete recording'),
      );
    }

    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.hardDeleteRecording(recordingId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to hard delete recording: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  // Markers management
  @override
  Future<Either<Failure, Marker>> createMarker({
    required String recordingId,
    required double timeSeconds,
    required String label,
    required String type,
    String? description,
  }) async {
    final token = await authLocalDataSource.getAccessToken();
    if (token == null) {
      return const Left(UnauthorizedFailure('Please login to create marker'));
    }

    if (await networkInfo.isConnected) {
      try {
        final marker = await remoteDataSource.createMarker(
          recordingId: recordingId,
          timeSeconds: timeSeconds,
          label: label,
          type: type,
          description: description,
        );
        return Right(marker);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to create marker: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Marker>>> getMarkers(String recordingId) async {
    final token = await authLocalDataSource.getAccessToken();
    if (token == null) {
      return const Left(UnauthorizedFailure('Please login to get markers'));
    }

    if (await networkInfo.isConnected) {
      try {
        final markers = await remoteDataSource.getMarkers(recordingId);
        return Right(markers);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to get markers: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Marker>> updateMarker({
    required int markerId,
    String? label,
    String? type,
    String? description,
  }) async {
    final token = await authLocalDataSource.getAccessToken();
    if (token == null) {
      return const Left(UnauthorizedFailure('Please login to update marker'));
    }

    if (await networkInfo.isConnected) {
      try {
        final marker = await remoteDataSource.updateMarker(
          markerId: markerId,
          label: label,
          type: type,
          description: description,
        );
        return Right(marker);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to update marker: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMarker(int markerId) async {
    final token = await authLocalDataSource.getAccessToken();
    if (token == null) {
      return const Left(UnauthorizedFailure('Please login to delete marker'));
    }

    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteMarker(markerId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to delete marker: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  // Tags management
  @override
  Future<Either<Failure, List<RecordingTag>>> addTags({
    required String recordingId,
    required List<String> tags,
  }) async {
    final token = await authLocalDataSource.getAccessToken();
    if (token == null) {
      return const Left(UnauthorizedFailure('Please login to add tags'));
    }

    if (await networkInfo.isConnected) {
      try {
        final tagModels = await remoteDataSource.addTags(
          recordingId: recordingId,
          tags: tags,
        );
        return Right(tagModels);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to add tags: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> removeTag({
    required String recordingId,
    required String tag,
  }) async {
    final token = await authLocalDataSource.getAccessToken();
    if (token == null) {
      return const Left(UnauthorizedFailure('Please login to remove tag'));
    }

    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.removeTag(recordingId: recordingId, tag: tag);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to remove tag: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<RecordingTag>>> getTags(
    String recordingId,
  ) async {
    final token = await authLocalDataSource.getAccessToken();
    if (token == null) {
      return const Left(UnauthorizedFailure('Please login to get tags'));
    }

    if (await networkInfo.isConnected) {
      try {
        final tagModels = await remoteDataSource.getTags(recordingId);
        return Right(tagModels);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to get tags: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}




