import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/recording_model.dart';
import '../models/marker_model.dart';
import '../models/recording_tag_model.dart';

abstract class RecordingRemoteDataSource {
  Future<RecordingModel> createRecording({
    required String? folderId,
    required String title,
    required String sourceType,
  });
  Future<RecordingModel> completeUpload({
    required String recordingId,
    required String filePath,
    required double fileSizeMb,
    required double durationSeconds,
    required String originalFileName,
  });
  Future<List<RecordingModel>> getRecordings({
    String? folderId,
    bool? isTrashed,
    String? search,
    String? tag,
    int? page,
    int? pageSize,
  });
  Future<RecordingModel> getRecordingDetail(String recordingId);
  Future<RecordingModel> updateRecording({
    required String recordingId,
    String? title,
    String? folderId,
    bool? isPinned,
    double? lastPlayPosition,
  });
  Future<void> softDeleteRecording(String recordingId);
  Future<RecordingModel> restoreRecording(String recordingId);
  Future<void> hardDeleteRecording(String recordingId);

  // Markers
  Future<MarkerModel> createMarker({
    required String recordingId,
    required double timeSeconds,
    required String label,
    required String type,
    String? description,
  });
  Future<List<MarkerModel>> getMarkers(String recordingId);
  Future<MarkerModel> updateMarker({
    required int markerId,
    String? label,
    String? type,
    String? description,
  });
  Future<void> deleteMarker(int markerId);

  // Tags
  Future<List<RecordingTagModel>> addTags({
    required String recordingId,
    required List<String> tags,
  });
  Future<void> removeTag({
    required String recordingId,
    required String tag,
  });
  Future<List<RecordingTagModel>> getTags(String recordingId);
}

class RecordingRemoteDataSourceImpl implements RecordingRemoteDataSource {
  final Dio dio;

  RecordingRemoteDataSourceImpl({required this.dio});

  @override
  Future<RecordingModel> createRecording({
    required String? folderId,
    required String title,
    required String sourceType,
  }) async {
    try {
      final response = await dio.post(
        AppConstants.recordingsEndpoint,
        data: {
          'folder_id': folderId,
          'title': title,
          'source_type': sourceType,
        },
      );
      if (response.statusCode == 201) {
        return RecordingModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create recording');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<RecordingModel> completeUpload({
    required String recordingId,
    required String filePath,
    required double fileSizeMb,
    required double durationSeconds,
    required String originalFileName,
  }) async {
    try {
      final response = await dio.post(
        '${AppConstants.recordingsEndpoint}/$recordingId/complete-upload',
        data: {
          'file_path': filePath,
          'file_size_mb': fileSizeMb,
          'duration_seconds': durationSeconds,
          'original_file_name': originalFileName,
        },
      );
      if (response.statusCode == 200) {
        return RecordingModel.fromJson(response.data);
      } else {
        throw Exception('Failed to complete upload');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<List<RecordingModel>> getRecordings({
    String? folderId,
    bool? isTrashed,
    String? search,
    String? tag,
    int? page,
    int? pageSize,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (folderId != null) queryParams['folder_id'] = folderId;
      if (isTrashed != null) queryParams['is_trashed'] = isTrashed;
      if (search != null) queryParams['search'] = search;
      if (tag != null) queryParams['tag'] = tag;
      if (page != null) queryParams['page'] = page;
      if (pageSize != null) queryParams['page_size'] = pageSize;

      final response = await dio.get(
        AppConstants.recordingsEndpoint,
        queryParameters: queryParams,
      );
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => RecordingModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to get recordings');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<RecordingModel> getRecordingDetail(String recordingId) async {
    try {
      final response = await dio.get('${AppConstants.recordingsEndpoint}/$recordingId');
      if (response.statusCode == 200) {
        return RecordingModel.fromJson(response.data);
      } else {
        throw Exception('Failed to get recording detail');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<RecordingModel> updateRecording({
    required String recordingId,
    String? title,
    String? folderId,
    bool? isPinned,
    double? lastPlayPosition,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (title != null) data['title'] = title;
      if (folderId != null) data['folder_id'] = folderId;
      if (isPinned != null) data['is_pinned'] = isPinned;
      if (lastPlayPosition != null) data['last_play_position'] = lastPlayPosition;

      final response = await dio.patch(
        '${AppConstants.recordingsEndpoint}/$recordingId',
        data: data,
      );
      if (response.statusCode == 200) {
        return RecordingModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update recording');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<void> softDeleteRecording(String recordingId) async {
    try {
      final response = await dio.delete('${AppConstants.recordingsEndpoint}/$recordingId');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to soft delete recording');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<RecordingModel> restoreRecording(String recordingId) async {
    try {
      final response = await dio.post('${AppConstants.recordingsEndpoint}/$recordingId/restore');
      if (response.statusCode == 200) {
        return RecordingModel.fromJson(response.data);
      } else {
        throw Exception('Failed to restore recording');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<void> hardDeleteRecording(String recordingId) async {
    try {
      final response = await dio.delete('${AppConstants.recordingsEndpoint}/$recordingId/hard-delete');
      if (response.statusCode != 204) {
        throw Exception('Failed to hard delete recording');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<MarkerModel> createMarker({
    required String recordingId,
    required double timeSeconds,
    required String label,
    required String type,
    String? description,
  }) async {
    try {
      final response = await dio.post(
        '${AppConstants.recordingsEndpoint}/$recordingId/markers',
        data: {
          'time_seconds': timeSeconds,
          'label': label,
          'type': type,
          'description': description,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return MarkerModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create marker');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<List<MarkerModel>> getMarkers(String recordingId) async {
    try {
      final response = await dio.get('${AppConstants.recordingsEndpoint}/$recordingId/markers');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => MarkerModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to get markers');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<MarkerModel> updateMarker({
    required int markerId,
    String? label,
    String? type,
    String? description,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (label != null) data['label'] = label;
      if (type != null) data['type'] = type;
      if (description != null) data['description'] = description;

      final response = await dio.patch('${AppConstants.markersEndpoint}/$markerId', data: data);
      if (response.statusCode == 200) {
        return MarkerModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update marker');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<void> deleteMarker(int markerId) async {
    try {
      final response = await dio.delete('${AppConstants.markersEndpoint}/$markerId');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete marker');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<List<RecordingTagModel>> addTags({
    required String recordingId,
    required List<String> tags,
  }) async {
    try {
      final response = await dio.post(
        '${AppConstants.recordingsEndpoint}/$recordingId/tags',
        data: {'tags': tags},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return (response.data as List)
            .map((json) => RecordingTagModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to add tags');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<void> removeTag({
    required String recordingId,
    required String tag,
  }) async {
    try {
      final response = await dio.delete('${AppConstants.recordingsEndpoint}/$recordingId/tags/$tag');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to remove tag');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<List<RecordingTagModel>> getTags(String recordingId) async {
    try {
      final response = await dio.get('${AppConstants.recordingsEndpoint}/$recordingId/tags');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => RecordingTagModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to get tags');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}

