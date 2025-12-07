import '../../domain/entities/recording.dart';

class RecordingModel extends Recording {
  const RecordingModel({
    required String recordingId,
    required String userId,
    String? folderId,
    required String title,
    required String filePath,
    required double durationSeconds,
    required double fileSizeMb,
    required RecordingStatus status,
    required DateTime createdAt,
    DateTime? deletedAt,
  }) : super(
         recordingId: recordingId,
         userId: userId,
         folderId: folderId,
         title: title,
         filePath: filePath,
         durationSeconds: durationSeconds,
         fileSizeMb: fileSizeMb,
         status: status,
         createdAt: createdAt,
         deletedAt: deletedAt,
       );

  factory RecordingModel.fromEntity(Recording recording) {
    return RecordingModel(
      recordingId: recording.recordingId,
      userId: recording.userId,
      folderId: recording.folderId,
      title: recording.title,
      filePath: recording.filePath,
      durationSeconds: recording.durationSeconds,
      fileSizeMb: recording.fileSizeMb,
      status: recording.status,
      createdAt: recording.createdAt,
      deletedAt: recording.deletedAt,
    );
  }

  factory RecordingModel.fromJson(Map<String, dynamic> json) {
    return RecordingModel(
      recordingId: json['recording_id'] as String,
      userId: json['user_id'] as String,
      folderId: json['folder_id'] as String?,
      title: json['title'] as String,
      filePath: json['file_path'] as String,
      durationSeconds: (json['duration_seconds'] as num).toDouble(),
      fileSizeMb: (json['file_size_mb'] as num).toDouble(),
      status: RecordingStatus.fromString(
        json['status'] as String? ?? 'UPLOADING',
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      deletedAt:
          json['deleted_at'] != null
              ? DateTime.parse(json['deleted_at'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recording_id': recordingId,
      'user_id': userId,
      'folder_id': folderId,
      'title': title,
      'file_path': filePath,
      'duration_seconds': durationSeconds,
      'file_size_mb': fileSizeMb,
      'status': status.value,
      'created_at': createdAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
