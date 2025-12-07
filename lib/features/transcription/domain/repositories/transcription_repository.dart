import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/audio_upload_response.dart';
import '../entities/transcription_request.dart';
import '../entities/transcription_response.dart';

abstract class TranscriptionRepository {
  Future<Either<Failure, AudioUploadResponse>> uploadAudio(File audioFile);
  Future<Either<Failure, TranscriptionResponse>> transcribeAudio(TranscriptionRequest request);
}