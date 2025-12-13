import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/audio_upload_response.dart';
import '../models/transcription_models.dart';

abstract class TranscriptionRemoteDataSource {
  Future<AudioUploadResponseModel> uploadAudio(File audioFile);
  Future<TranscriptionResponseModel> transcribeAudio(TranscriptionRequestModel request);
  
  // Recording-based transcription (new API)
  Future<TranscriptionResponseModel> transcribeRecording(String recordingId);
  Future<List<TranscriptModel>> getTranscripts({
    required String recordingId,
    bool? latest,
  });
  Future<Map<String, dynamic>> getTranscriptDetail(String transcriptId);
  Future<TranscriptModel> updateTranscript({
    required String transcriptId,
    String? language,
    bool? isActive,
  });
  Future<TranscriptSegmentModel> updateSegment({
    required String transcriptId,
    required int segmentId,
    String? content,
    String? speakerLabel,
  });
  
  // Speakers management
  Future<List<RecordingSpeakerModel>> getSpeakers(String recordingId);
  Future<RecordingSpeakerModel> updateSpeaker({
    required String recordingId,
    required String speakerLabel,
    String? displayName,
    String? color,
  });
  
  // Folder management
  Future<FolderModel> createFolder({
    required String name,
    String? parentFolderId,
  });
  Future<List<FolderModel>> getFolders({String? parentFolderId});
  Future<FolderModel> updateFolder({
    required String folderId,
    String? name,
    String? parentFolderId,
  });
  Future<void> deleteFolder(String folderId);
}

class TranscriptionRemoteDataSourceImpl implements TranscriptionRemoteDataSource {
  final Dio dio;

  TranscriptionRemoteDataSourceImpl({required this.dio});

  @override
  Future<AudioUploadResponseModel> uploadAudio(File audioFile) async {
    try {
      // Create FormData for multipart upload
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          audioFile.path,
          filename: audioFile.path.split('/').last,
        ),
      });

      final response = await dio.post(
        '/audio/upload',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        return AudioUploadResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to upload audio file');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<TranscriptionResponseModel> transcribeAudio(TranscriptionRequestModel request) async {
    try {
      final response = await dio.post(
        '/transcript/transcribe',
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return TranscriptionResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to transcribe audio');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<FolderModel> createFolder({
    required String name,
    String? parentFolderId,
  }) async {
    try {
      final response = await dio.post(
        AppConstants.foldersEndpoint,
        data: {
          'name': name,
          'parent_folder_id': parentFolderId,
        },
      );
      if (response.statusCode == 201) {
        return FolderModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create folder');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<List<FolderModel>> getFolders({String? parentFolderId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (parentFolderId != null) queryParams['parent_folder_id'] = parentFolderId;

      final response = await dio.get(
        AppConstants.foldersEndpoint,
        queryParameters: queryParams,
      );
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => FolderModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to get folders');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<FolderModel> updateFolder({
    required String folderId,
    String? name,
    String? parentFolderId,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (parentFolderId != null) data['parent_folder_id'] = parentFolderId;

      final response = await dio.patch(
        '${AppConstants.foldersEndpoint}/$folderId',
        data: data,
      );
      if (response.statusCode == 200) {
        return FolderModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update folder');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<void> deleteFolder(String folderId) async {
    try {
      final response = await dio.delete('${AppConstants.foldersEndpoint}/$folderId');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete folder');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<TranscriptionResponseModel> transcribeRecording(String recordingId) async {
    try {
      final response = await dio.post('${AppConstants.recordingsEndpoint}/$recordingId/transcribe');
      if (response.statusCode == 200) {
        return TranscriptionResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to transcribe recording');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<List<TranscriptModel>> getTranscripts({
    required String recordingId,
    bool? latest,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (latest != null) queryParams['latest'] = latest;

      final response = await dio.get(
        '${AppConstants.recordingsEndpoint}/$recordingId/transcripts',
        queryParameters: queryParams,
      );
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => TranscriptModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to get transcripts');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getTranscriptDetail(String transcriptId) async {
    try {
      final response = await dio.get('${AppConstants.transcriptsEndpoint}/$transcriptId');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to get transcript detail');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<TranscriptModel> updateTranscript({
    required String transcriptId,
    String? language,
    bool? isActive,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (language != null) data['language'] = language;
      if (isActive != null) data['is_active'] = isActive;

      final response = await dio.patch(
        '${AppConstants.transcriptsEndpoint}/$transcriptId',
        data: data,
      );
      if (response.statusCode == 200) {
        return TranscriptModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update transcript');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<TranscriptSegmentModel> updateSegment({
    required String transcriptId,
    required int segmentId,
    String? content,
    String? speakerLabel,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (content != null) data['content'] = content;
      if (speakerLabel != null) data['speaker_label'] = speakerLabel;

      final response = await dio.patch(
        '${AppConstants.transcriptsEndpoint}/$transcriptId/segments/$segmentId',
        data: data,
      );
      if (response.statusCode == 200) {
        return TranscriptSegmentModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update segment');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<List<RecordingSpeakerModel>> getSpeakers(String recordingId) async {
    try {
      final response = await dio.get('${AppConstants.recordingsEndpoint}/$recordingId/speakers');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => RecordingSpeakerModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to get speakers');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<RecordingSpeakerModel> updateSpeaker({
    required String recordingId,
    required String speakerLabel,
    String? displayName,
    String? color,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (displayName != null) data['display_name'] = displayName;
      if (color != null) data['color'] = color;

      final response = await dio.patch(
        '${AppConstants.recordingsEndpoint}/$recordingId/speakers/$speakerLabel',
        data: data,
      );
      if (response.statusCode == 200) {
        return RecordingSpeakerModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update speaker');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}