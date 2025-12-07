import 'package:equatable/equatable.dart';

class Folder extends Equatable {
  final String folderId; // uuid folder_id PK
  final String userId; // uuid user_id FK
  final String name;
  final String?
  parentFolderId; // uuid parent_folder_id FK - Hỗ trợ thư mục con (Self-reference)
  final DateTime createdAt;

  const Folder({
    required this.folderId,
    required this.userId,
    required this.name,
    this.parentFolderId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    folderId,
    userId,
    name,
    parentFolderId,
    createdAt,
  ];
}
