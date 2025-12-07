import 'package:equatable/equatable.dart';

class RecordingSpeaker extends Equatable {
  final int id; // bigint id PK
  final String recordingId; // uuid recording_id FK
  final String speakerLabel; // VD: SPEAKER_01
  final String displayName; // VD: Giáo sư X (Tên người dùng)

  const RecordingSpeaker({
    required this.id,
    required this.recordingId,
    required this.speakerLabel,
    required this.displayName,
  });

  @override
  List<Object?> get props => [
    id,
    recordingId,
    speakerLabel,
    displayName,
  ];
}

