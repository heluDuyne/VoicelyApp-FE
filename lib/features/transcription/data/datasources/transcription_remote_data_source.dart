import 'dart:io';
import 'package:dio/dio.dart';
import '../models/audio_upload_response.dart';
import '../models/transcription_models.dart';

abstract class TranscriptionRemoteDataSource {
  Future<AudioUploadResponseModel> uploadAudio(File audioFile);
  Future<TranscriptionResponseModel> transcribeAudio(TranscriptionRequestModel request);
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
}