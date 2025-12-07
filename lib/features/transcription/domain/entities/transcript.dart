import 'package:equatable/equatable.dart';

class Transcript extends Equatable {
  final String transcriptId; // uuid transcript_id PK
  final String recordingId; // uuid recording_id FK
  final String language; // VD: en, vi
  final double confidenceScore; // Độ tin cậy AI
  final DateTime createdAt;

  const Transcript({
    required this.transcriptId,
    required this.recordingId,
    required this.language,
    required this.confidenceScore,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    transcriptId,
    recordingId,
    language,
    confidenceScore,
    createdAt,
  ];
}

