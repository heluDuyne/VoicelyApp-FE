import '../../domain/entities/folder.dart';
import '../../domain/entities/transcript.dart';
import '../../domain/entities/transcript_segment.dart';
import '../../domain/entities/recording_speaker.dart';
import '../../domain/entities/transcription_request.dart';
import '../../domain/entities/transcription_response.dart';
import '../../domain/entities/transcription_segment_response.dart';
import '../../domain/entities/transcription_word.dart';

// Data models for JSON serialization - extend domain entities
class TranscriptionRequestModel extends TranscriptionRequest {
  const TranscriptionRequestModel({
    required int audioId,
    required String languageCode,
  }) : super(audioId: audioId, languageCode: languageCode);

  factory TranscriptionRequestModel.fromEntity(TranscriptionRequest entity) {
    return TranscriptionRequestModel(
      audioId: entity.audioId,
      languageCode: entity.languageCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {'audio_id': audioId, 'language_code': languageCode};
  }
}

class TranscriptionResponseModel extends TranscriptionResponse {
  const TranscriptionResponseModel({
    required int audioId,
    required String transcript,
    required double confidence,
    required String languageCode,
    required List<TranscriptionSegmentResponse> segments,
    required int wordCount,
    double? durationTranscribed,
    required String status,
    required DateTime processedAt,
  }) : super(
         audioId: audioId,
         transcript: transcript,
         confidence: confidence,
         languageCode: languageCode,
         segments: segments,
         wordCount: wordCount,
         durationTranscribed: durationTranscribed,
         status: status,
         processedAt: processedAt,
       );

  factory TranscriptionResponseModel.fromJson(Map<String, dynamic> json) {
    return TranscriptionResponseModel(
      audioId: json['audio_id'],
      transcript: json['transcript'],
      confidence: json['confidence'].toDouble(),
      languageCode: json['language_code'],
      segments:
          (json['segments'] as List)
              .map(
                (segment) =>
                    TranscriptionSegmentResponseModel.fromJson(segment),
              )
              .toList(),
      wordCount: json['word_count'],
      durationTranscribed: json['duration_transcribed']?.toDouble(),
      status: json['status'],
      processedAt: DateTime.parse(json['processed_at']),
    );
  }

  factory TranscriptionResponseModel.fromEntity(TranscriptionResponse entity) {
    return TranscriptionResponseModel(
      audioId: entity.audioId,
      transcript: entity.transcript,
      confidence: entity.confidence,
      languageCode: entity.languageCode,
      segments:
          entity.segments
              .map((s) => TranscriptionSegmentResponseModel.fromEntity(s))
              .toList(),
      wordCount: entity.wordCount,
      durationTranscribed: entity.durationTranscribed,
      status: entity.status,
      processedAt: entity.processedAt,
    );
  }
}

class TranscriptionSegmentResponseModel extends TranscriptionSegmentResponse {
  const TranscriptionSegmentResponseModel({
    required String transcript,
    required double confidence,
    required List<TranscriptionWord> words,
  }) : super(transcript: transcript, confidence: confidence, words: words);

  factory TranscriptionSegmentResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TranscriptionSegmentResponseModel(
      transcript: json['transcript'],
      confidence: json['confidence'].toDouble(),
      words:
          (json['words'] as List)
              .map((word) => TranscriptionWordModel.fromJson(word))
              .toList(),
    );
  }

  factory TranscriptionSegmentResponseModel.fromEntity(
    TranscriptionSegmentResponse entity,
  ) {
    return TranscriptionSegmentResponseModel(
      transcript: entity.transcript,
      confidence: entity.confidence,
      words:
          entity.words
              .map((w) => TranscriptionWordModel.fromEntity(w))
              .toList(),
    );
  }
}

class TranscriptionWordModel extends TranscriptionWord {
  const TranscriptionWordModel({
    required String word,
    required double startTime,
    required double endTime,
    required double confidence,
  }) : super(
         word: word,
         startTime: startTime,
         endTime: endTime,
         confidence: confidence,
       );

  factory TranscriptionWordModel.fromJson(Map<String, dynamic> json) {
    return TranscriptionWordModel(
      word: json['word'],
      startTime: json['start_time'].toDouble(),
      endTime: json['end_time'].toDouble(),
      confidence: json['confidence'].toDouble(),
    );
  }

  factory TranscriptionWordModel.fromEntity(TranscriptionWord entity) {
    return TranscriptionWordModel(
      word: entity.word,
      startTime: entity.startTime,
      endTime: entity.endTime,
      confidence: entity.confidence,
    );
  }
}

class FolderModel extends Folder {
  const FolderModel({
    required String folderId,
    required String userId,
    required String name,
    String? parentFolderId,
    required bool isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
  }) : super(
         folderId: folderId,
         userId: userId,
         name: name,
         parentFolderId: parentFolderId,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
       );

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
      folderId: json['folder_id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      parentFolderId: json['parent_folder_id'] as String?,
      isDeleted: json['is_deleted'] as bool? ?? false,
      deletedAt:
          json['deleted_at'] != null
              ? DateTime.parse(json['deleted_at'] as String)
              : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'folder_id': folderId,
      'user_id': userId,
      'name': name,
      'parent_folder_id': parentFolderId,
      'is_deleted': isDeleted,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class TranscriptModel extends Transcript {
  const TranscriptModel({
    required String transcriptId,
    required String recordingId,
    required String language,
    required double confidenceScore,
    required DateTime createdAt,
  }) : super(
         transcriptId: transcriptId,
         recordingId: recordingId,
         language: language,
         confidenceScore: confidenceScore,
         createdAt: createdAt,
       );

  factory TranscriptModel.fromJson(Map<String, dynamic> json) {
    return TranscriptModel(
      transcriptId: json['transcript_id'] as String,
      recordingId: json['recording_id'] as String,
      language: json['language'] as String,
      confidenceScore: (json['confidence_score'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transcript_id': transcriptId,
      'recording_id': recordingId,
      'language': language,
      'confidence_score': confidenceScore,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class TranscriptSegmentModel extends TranscriptSegment {
  const TranscriptSegmentModel({
    required int segmentId,
    required String transcriptId,
    required double startTime,
    required double endTime,
    required String content,
    required String speakerLabel,
  }) : super(
         segmentId: segmentId,
         transcriptId: transcriptId,
         startTime: startTime,
         endTime: endTime,
         content: content,
         speakerLabel: speakerLabel,
       );

  factory TranscriptSegmentModel.fromJson(Map<String, dynamic> json) {
    return TranscriptSegmentModel(
      segmentId: json['segment_id'] as int,
      transcriptId: json['transcript_id'] as String,
      startTime: (json['start_time'] as num).toDouble(),
      endTime: (json['end_time'] as num).toDouble(),
      content: json['content'] as String,
      speakerLabel: json['speaker_label'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'segment_id': segmentId,
      'transcript_id': transcriptId,
      'start_time': startTime,
      'end_time': endTime,
      'content': content,
      'speaker_label': speakerLabel,
    };
  }
}

class RecordingSpeakerModel extends RecordingSpeaker {
  const RecordingSpeakerModel({
    required int id,
    required String recordingId,
    required String speakerLabel,
    required String displayName,
    String? color,
  }) : super(
         id: id,
         recordingId: recordingId,
         speakerLabel: speakerLabel,
         displayName: displayName,
         color: color,
       );

  factory RecordingSpeakerModel.fromJson(Map<String, dynamic> json) {
    return RecordingSpeakerModel(
      id: json['id'] as int,
      recordingId: json['recording_id'] as String,
      speakerLabel: json['speaker_label'] as String,
      displayName: json['display_name'] as String,
      color: json['color'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recording_id': recordingId,
      'speaker_label': speakerLabel,
      'display_name': displayName,
      'color': color,
    };
  }
}
